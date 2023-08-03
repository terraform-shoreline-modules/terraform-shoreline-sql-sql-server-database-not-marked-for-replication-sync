terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "sql_server_database_not_marked_for_replication_sync" {
  source    = "./modules/sql_server_database_not_marked_for_replication_sync"

  providers = {
    shoreline = shoreline
  }
}