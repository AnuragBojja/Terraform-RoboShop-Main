locals {
  public_subnet_ids = join(",",module.vpc.public_subnet_ids)
  private_subnet_ids = join(",",module.vpc.private_subnet_ids)
  database_subnet_ids = join(",",module.vpc.database_subnet_ids)
}