resource "shoreline_notebook" "sql_server_database_not_marked_for_replication_sync" {
  name       = "sql_server_database_not_marked_for_replication_sync"
  data       = file("${path.module}/data/sql_server_database_not_marked_for_replication_sync.json")
  depends_on = [shoreline_action.invoke_backup_script,shoreline_action.invoke_check_replication_settings,shoreline_action.invoke_replication_check,shoreline_action.invoke_sql_service_restart,shoreline_action.invoke_replication_sync_script,shoreline_action.invoke_network_connectivity_test]
}

resource "shoreline_file" "backup_script" {
  name             = "backup_script"
  input_file       = "${path.module}/data/backup_script.sh"
  md5              = filemd5("${path.module}/data/backup_script.sh")
  description      = "Next Step"
  destination_path = "/agent/scripts/backup_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_replication_settings" {
  name             = "check_replication_settings"
  input_file       = "${path.module}/data/check_replication_settings.sh"
  md5              = filemd5("${path.module}/data/check_replication_settings.sh")
  description      = "Next Step"
  destination_path = "/agent/scripts/check_replication_settings.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "replication_check" {
  name             = "replication_check"
  input_file       = "${path.module}/data/replication_check.sh"
  md5              = filemd5("${path.module}/data/replication_check.sh")
  description      = "Next Step"
  destination_path = "/agent/scripts/replication_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "sql_service_restart" {
  name             = "sql_service_restart"
  input_file       = "${path.module}/data/sql_service_restart.sh"
  md5              = filemd5("${path.module}/data/sql_service_restart.sh")
  description      = "Restart the SQL Server service to see if it resolves the issue."
  destination_path = "/agent/scripts/sql_service_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "replication_sync_script" {
  name             = "replication_sync_script"
  input_file       = "${path.module}/data/replication_sync_script.sh"
  md5              = filemd5("${path.module}/data/replication_sync_script.sh")
  description      = "Check the database replication settings and ensure that it is set to sync with its backup."
  destination_path = "/agent/scripts/replication_sync_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "network_connectivity_test" {
  name             = "network_connectivity_test"
  input_file       = "${path.module}/data/network_connectivity_test.sh"
  md5              = filemd5("${path.module}/data/network_connectivity_test.sh")
  description      = "Check the network connectivity and ensure that it is not blocking the replication process."
  destination_path = "/agent/scripts/network_connectivity_test.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_backup_script" {
  name        = "invoke_backup_script"
  description = "Next Step"
  command     = "`chmod +x /agent/scripts/backup_script.sh && /agent/scripts/backup_script.sh`"
  params      = ["REPLICA_NAME","DATABASE_NAME","BACKUP_NAME"]
  file_deps   = ["backup_script"]
  enabled     = true
  depends_on  = [shoreline_file.backup_script]
}

resource "shoreline_action" "invoke_check_replication_settings" {
  name        = "invoke_check_replication_settings"
  description = "Next Step"
  command     = "`chmod +x /agent/scripts/check_replication_settings.sh && /agent/scripts/check_replication_settings.sh`"
  params      = ["SERVER_NAME"]
  file_deps   = ["check_replication_settings"]
  enabled     = true
  depends_on  = [shoreline_file.check_replication_settings]
}

resource "shoreline_action" "invoke_replication_check" {
  name        = "invoke_replication_check"
  description = "Next Step"
  command     = "`chmod +x /agent/scripts/replication_check.sh && /agent/scripts/replication_check.sh`"
  params      = []
  file_deps   = ["replication_check"]
  enabled     = true
  depends_on  = [shoreline_file.replication_check]
}

resource "shoreline_action" "invoke_sql_service_restart" {
  name        = "invoke_sql_service_restart"
  description = "Restart the SQL Server service to see if it resolves the issue."
  command     = "`chmod +x /agent/scripts/sql_service_restart.sh && /agent/scripts/sql_service_restart.sh`"
  params      = ["SQL_SERVER_SERVICE_NAME"]
  file_deps   = ["sql_service_restart"]
  enabled     = true
  depends_on  = [shoreline_file.sql_service_restart]
}

resource "shoreline_action" "invoke_replication_sync_script" {
  name        = "invoke_replication_sync_script"
  description = "Check the database replication settings and ensure that it is set to sync with its backup."
  command     = "`chmod +x /agent/scripts/replication_sync_script.sh && /agent/scripts/replication_sync_script.sh`"
  params      = ["DATABASE_NAME","SERVER_NAME"]
  file_deps   = ["replication_sync_script"]
  enabled     = true
  depends_on  = [shoreline_file.replication_sync_script]
}

resource "shoreline_action" "invoke_network_connectivity_test" {
  name        = "invoke_network_connectivity_test"
  description = "Check the network connectivity and ensure that it is not blocking the replication process."
  command     = "`chmod +x /agent/scripts/network_connectivity_test.sh && /agent/scripts/network_connectivity_test.sh`"
  params      = ["PORT_NUMBER","HOST_NAME_OR_IP_ADDRESS"]
  file_deps   = ["network_connectivity_test"]
  enabled     = true
  depends_on  = [shoreline_file.network_connectivity_test]
}

