module "sg" {
  count = length(var.sg_names)
  source = "git::https://github.com/AnuragBojja/terraform-aws-10-sg.git?ref=main"
  project_name = var.project_name
  env = var.env
  sg_names = var.sg_names[count.index]
  vpc_id = local.vpc_id
}