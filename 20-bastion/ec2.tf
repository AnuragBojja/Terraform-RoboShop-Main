resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id = local.public_subnet_id
  user_data = file("./terraform-installation.sh")
  iam_instance_profile = aws_iam_instance_profile.Bastion-AdminAccess.name
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = merge(
    var.bastion_tags,
    local.common_tags,
    {
        Name = "${local.common_name}-bastion"
    }
  )
}

resource "aws_iam_instance_profile" "Bastion-AdminAccess" {
  name = "Roboshop-Bastion-AdminAccess"
  role = "RoboshopBastionAdminAccess"
  }