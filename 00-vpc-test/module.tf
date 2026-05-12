module "vpc" {
  source = "git::https://github.com/AnuragBojja/terraform-aws-00-vpc.git?ref=main"
  env = var.env
  project_name = var.project_name
  vpc_cider = var.vpc_cider
  vpc_tags = var.vpc_tags
  igw_tags = var.igw_tags
  public_ciders = var.public_ciders
  private_ciders = var.private_ciders
  database_ciders = var.database_ciders

}