# Terraform-RoboShop-Main — Full Production Infrastructure on AWS

A complete, production-grade AWS infrastructure deployment for the RoboShop e-commerce platform, built entirely with Terraform across **10 independently state-managed layers**. The project follows a strict layered dependency model where each layer stores its outputs in **AWS SSM Parameter Store** and is consumed by downstream layers — enabling zero-hardcoded cross-layer references and full environment isolation.

---

## Architecture Overview

```
Internet
  └─→ dev.anuragaws.shop  (CloudFront CDN — geo-restricted, cache policies)
        └─→ roboshop-dev.anuragaws.shop  (Frontend ALB — HTTPS 443, ACM TLS, SNI)
              └─→ frontend EC2  (Nginx, port 80)
                    └─→ *.backend-alb-dev.anuragaws.shop  (Backend ALB — HTTP 80, internal)
                          ├─→ catalogue:8080  ──→  MongoDB:27017
                          ├─→ user:8080       ──→  MongoDB:27017 + Redis:6379
                          ├─→ cart:8080       ──→  Redis:6379
                          ├─→ payment:8080    ──→  RabbitMQ:5672
                          └─→ shipping:8080   ──→  MySQL:3306

Management:
  openvpn-dev.anuragaws.shop  ──→  SSH/8080 to all services + DB ports
  Bastion (public subnet)     ──→  SSH to all + auto-provisions DB & service layers on boot
```

---

## Layered Deployment Architecture (10 Stages)

Each stage is an independent Terraform root module with its own **S3 remote state** and **SSM Parameter Store** integration.

| Layer | Folder | What It Provisions | State Key |
|---|---|---|---|
| 00 | `00-vpc-test` | VPC, 3-tier subnets, IGW, NAT, route tables | `remote-state-roboshop-00-vpc-test` |
| 10 | `10-sg-test` | 14 Security Groups (all services + ALBs + mgmt) | `remote-state-roboshop-10-sg-test` |
| 20 | `20-bastion` | Bastion EC2 (self-bootstrapping, auto-provisions infra) | `remote-state-roboshop-dev-bastion` |
| 21 | `21-vpn` | OpenVPN EC2 + Route53 + openvpn.sh auto-config | `remote-state-roboshop-dev-21-vpn` |
| 30 | `30-sg-rules` | All SG-to-SG ingress rules (service mesh security) | *(stateful rules layer)* |
| 40 | `40-databases` | 4 DB EC2s (MongoDB, Redis, MySQL, RabbitMQ) + Route53 private DNS | `remote-state-roboshop-dev-40-databases` |
| 50 | `50-backend-alb` | Internal ALB + wildcard Route53 alias + listener ARN → SSM | `remote-state-roboshop-dev-50-backend-alb` |
| 60 | `60-ACM` | Wildcard ACM cert (`*.anuragaws.shop`) + DNS validation + cert ARN → SSM | `remote-state-roboshop-dev-60-ACM` |
| 70 | `70-frontend-alb` | Internet-facing ALB + HTTPS 443 + TLS 1.3 + listener ARN → SSM | `remote-state-roboshop-dev-70-frontend-alb` |
| 80 | `80-service` | All 6 app services via `for_each` + reusable service module | `remote-state-roboshop-dev-80-service` |
| 90 | `90-cloudfront` | CloudFront CDN + geo-restriction + cache policies + Route53 alias | `remote-state-roboshop-dev-90-cloudfront` |

---

## SSM Parameter Store — The Glue

Every layer writes its outputs to SSM. Every downstream layer reads from SSM. No `terraform_remote_state` data sources, no hardcoded IDs.

```
/roboshop/dev/vpc_id
/roboshop/dev/public_subnet_ids
/roboshop/dev/private_subnet_ids
/roboshop/dev/database_subnet_ids
/roboshop/dev/<service>_sg_id        (× 14 security groups)
/roboshop/dev/ssh/loginpass
/roboshop/dev/backend_alb_listener_arn
/roboshop/dev/frontend_alb_listener_arn
/roboshop/dev/frontend_alb_certificate_arn
```

---

## Key Components In Detail

### 00-vpc-test — 3-Tier VPC
- VPC `10.0.0.0/16` with public `[10.0.1/2.0/24]`, private `[10.0.11/12.0/24]`, database `[10.0.21/22.0/24]` subnets
- NAT Gateway in `public[0]`, IGW for public tier
- Calls custom module: `github.com/AnuragBojja/terraform-aws-00-vpc`
- All subnet IDs stored as comma-separated strings in SSM

### 10-sg-test — 14 Security Groups
- Loops over `var.sg_names` using `count`, calls `github.com/AnuragBojja/terraform-aws-10-sg` per SG
- SGs: `mongodb`, `redis`, `rabbitmq`, `mysql`, `catalogue`, `user`, `cart`, `payment`, `shipping`, `frontend`, `bastion`, `openvpn`, `frontend_alb`, `backend_alb`
- Each SG ID stored as `/${project}/${env}/${sg_name}_sg_id` in SSM

### 20-bastion — Self-Bootstrapping Bastion
- Redhat-9 EC2 in public subnet, 50GB gp3, `RoboshopBastionAdminAccess` IAM role
- `user_data` runs `terraform-installation.sh`: expands LVM `/home`, installs Terraform via HashiCorp repo
- **On first boot, automatically clones and applies `40-databases` and `80-service` Terraform repos as `ec2-user`** — the bastion provisions the entire app layer

### 21-vpn — OpenVPN
- Provisions official OpenVPN Access Server AMI (owner `679593333241`)
- `openvpn.sh` auto-configures: accepts EULA, sets admin password, enables UDP/1194, sets DNS (8.8.8.8 + 1.1.1.1), routes all client traffic through VPN
- Route53 A record: `openvpn-dev.anuragaws.shop` → public IP

### 30-sg-rules — Service Mesh Security
Split across `main.tf`, `bastion.tf`, `OpenVPN.tf`, `ALB.tf`:

**Service-to-service rules (main.tf):**
```
catalogue  → mongodb:27017
user       → mongodb:27017, redis:6379
cart       → redis:6379
payment    → rabbitmq:5672
shipping   → mysql:3306
backend_alb → all 5 backend services:8080
frontend_alb → frontend:80
```

**OpenVPN rules (for_each loops):**
```
internet → openvpn: 443, 1194, 943, 22
openvpn  → all services: 22
openvpn  → all backend: 8080
openvpn  → both ALBs: 80
openvpn  → DBs: 27017, 6379, 3306, 5672
```

**Bastion rules:**
```
internet → bastion: 22
bastion  → all DBs: 22
bastion  → all backend services: 22
bastion  → frontend: 22
bastion  → both ALBs: 80
```

### 40-databases — DB EC2s + Terraform→Ansible Pipeline
- 4 EC2 instances (MongoDB, Redis, RabbitMQ, MySQL) in database subnet
- Each uses `terraform_data` provisioner to SSH in and run `bootstrap.sh <service> dev`
- **`bootstrap.sh`**: installs Python3+git, installs Ansible+boto3+botocore, clones `terraform-anisble-roboshop` repo (or `git pull` if exists), runs `ansible-playbook -e service_name=<db> -e env=dev main.yaml`
- Route53 private A records: `mongodb-dev`, `redis-dev`, `rabbitmq-dev`, `mysql-dev` → `*.anuragaws.shop`

### 50-backend-alb — Internal ALB
- Internal ALB on private subnets, HTTP port 80
- Default listener: fixed-response 200
- Wildcard Route53 alias: `*.backend-alb-dev.anuragaws.shop` → ALB DNS
- `backend_alb_listener_arn` stored in SSM for service module consumption

### 60-ACM — TLS Certificate
- Wildcard cert `*.anuragaws.shop` via ACM DNS validation
- Route53 validation records auto-created with `for_each` over `domain_validation_options`
- `aws_acm_certificate_validation` resource ensures cert is fully issued before proceeding
- Cert ARN stored in SSM

### 70-frontend-alb — Public ALB
- Internet-facing ALB on public subnets, HTTPS 443
- TLS 1.3 security policy, SNI, ACM cert from SSM
- Route53 alias: `roboshop-dev.anuragaws.shop` → ALB
- `frontend_alb_listener_arn` stored in SSM

### 80-service — All 6 App Services via for_each
```hcl
for_each over {
  catalogue = { priority = 10 }
  user      = { priority = 20 }
  cart      = { priority = 30 }
  payment   = { priority = 40 }
  shipping  = { priority = 50 }
  frontend  = { priority = 10 }
}
```
Each calls `github.com/AnuragBojja/terraform-roboshop-dev-service-config` → EC2 → bootstrap → AMI bake → Launch Template → ASG (rolling refresh) → ALB Target Group → Listener Rule

### 90-cloudfront — CDN
- CloudFront distribution with origin `roboshop-dev.anuragaws.shop` (HTTPS-only, TLSv1.2)
- Alias: `dev.anuragaws.shop`
- `CachingDisabled` for default (dynamic API traffic)
- `CachingOptimized` for `/media/*` and `/images/*`
- Geo-restricted to: US, CA, GB, DE
- SNI TLS with ACM cert
- Route53 alias: `dev.anuragaws.shop` → CloudFront

---

## Project File Structure

```
Terraform-RoboShop-Main/
├── 00-vpc-test/         provider.tf, variables.tf, locals.tf, module.tf, outputs.tf, ssm.tf
├── 10-sg-test/          provider.tf, variables.tf, locals.tf, module.tf, outputs.tf, ssm.tf
├── 20-bastion/          provider.tf, variables.tf, locals.tf, data.tf, ec2.tf, terraform-installation.sh
├── 21-vpn/              provider.tf, variables.tf, locals.tf, data.tf, main.tf, openvpn.sh
├── 30-sg-rules/         provider.tf, variables.tf, locals.tf, data.tf, main.tf, bastion.tf, OpenVPN.tf, ALB.tf
├── 40-databases/        provider.tf, variables.tf, locals.tf, data.tf, main.tf, route53.tf, bootstrap.sh
├── 50-backend-alb/      provider.tf, variables.tf, locals.tf, data.tf, main.tf, route53.tf, ssm.tf
├── 60-ACM/              provider.tf, variables.tf, locals.tf, data.tf, main.tf, ssm.tf
├── 70-frontend-alb/     provider.tf, variables.tf, locals.tf, data.tf, main.tf, route53.tf, ssm.tf
├── 80-service/          provider.tf, variables.tf, main.tf, bootstrap.sh
└── 90-cloudfront/       provider.tf, variables.tf, locals.tf, data.tf, main.tf, route53.tf
```

---

## Deployment Order

```bash
cd 00-vpc-test    && terraform init && terraform apply -auto-approve
cd 10-sg-test     && terraform init && terraform apply -auto-approve
cd 20-bastion     && terraform init && terraform apply -auto-approve   # auto-provisions rest
cd 21-vpn         && terraform init && terraform apply -auto-approve
cd 30-sg-rules    && terraform init && terraform apply -auto-approve
cd 40-databases   && terraform init && terraform apply -auto-approve
cd 50-backend-alb && terraform init && terraform apply -auto-approve
cd 60-ACM         && terraform init && terraform apply -auto-approve
cd 70-frontend-alb && terraform init && terraform apply -auto-approve
cd 80-service     && terraform init && terraform apply -auto-approve
cd 90-cloudfront  && terraform init && terraform apply -auto-approve
```

---

## Modules Used

| Module | Source | Used In |
|---|---|---|
| VPC | `AnuragBojja/terraform-aws-00-vpc` | 00-vpc-test |
| Security Group | `AnuragBojja/terraform-aws-10-sg` | 10-sg-test |
| Service Config | `AnuragBojja/terraform-roboshop-dev-service-config` | 80-service |

---

## Author

**Anurag Bojja**
Milwaukee, WI | [LinkedIn](https://www.linkedin.com/in/anurag-bojja-81a405192/) | [GitHub](https://github.com/AnuragBojja)
