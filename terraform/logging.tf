# Logging Group for centralized logging
resource "oci_logging_log_group" "k8s_log_group" {
  compartment_id = data.oci_identity_compartment.compartment.id
  display_name   = "k8s-logs"
}

# Custom Log for application logs
# resource "oci_logging_log" "application_log" {
#   display_name = "application-logs"
#   log_group_id = oci_logging_log_group.k8s_log_group.id
#   log_type     = "CUSTOM"
  
#   configuration {
#     source {
#       category    = "all"
#       resource    = oci_core_instance.k8s_master.id
#       service     = "objectstorage"
#       source_type = "OCISERVICE"
#     }
#   }
  
#   is_enabled         = true
#   retention_duration = 30
# }
