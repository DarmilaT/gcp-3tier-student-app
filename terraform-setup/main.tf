# module "project" {
#   source = "./modules/projects"
#   project_name        = var.project_name
#   project_id          = var.project_id
#   billing_account_id  = var.billing_account_id
# }

module "network" {
  source = "./modules/network"
  project_id = var.project_id
  region     = var.region
}

module "db" {
  source = "./modules/db"
  zone       = var.zone
  project_id = var.project_id
  subnet     = module.network.database_subnet_self_link
}