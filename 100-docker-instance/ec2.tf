resource "aws_instance" "docker" {
  ami           = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data = file("./docker-installation.sh")
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-docker"
    }
  )
}

resource "aws_security_group" "main" {
  name        = "${local.common_name}-docker"
  description = var.sg_descripition
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-docker"
    }
    
  )
}
