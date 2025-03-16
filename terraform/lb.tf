# resource "oci_load_balancer" "k8s_lb" {
#   compartment_id = var.compartment_id
#   display_name   = "k8s-load-balancer"
#   shape          = "10Mbps"
#   subnet_ids     = [oci_core_subnet.public_subnet.id]

#   is_private = false
# }

# resource "oci_load_balancer_backend_set" "k8s_backend_set" {
#   name             = "k8s-backend-set"
#   load_balancer_id = oci_load_balancer.k8s_lb.id
#   policy           = "ROUND_ROBIN"

#   health_checker {
#     port                = 80
#     protocol            = "HTTP"
#     url_path            = "/"
#     return_code         = 200
#     interval_ms         = 10000
#     timeout_in_millis   = 3000
#     retries             = 3
#   }
# }

# resource "oci_load_balancer_backend" "k8s_backend" {
#   load_balancer_id = oci_load_balancer.k8s_lb.id
#   backendset_name  = oci_load_balancer_backend_set.k8s_backend_set.name
#   ip_address       = oci_core_instance.k8s_master.private_ip
#   port             = 80
#   backup           = false
#   drain            = false
#   offline          = false
#   weight           = 1
# }

# resource "oci_load_balancer_listener" "k8s_http_listener" {
#   load_balancer_id         = oci_load_balancer.k8s_lb.id
#   name                     = "http-listener"
#   default_backend_set_name = oci_load_balancer_backend_set.k8s_backend_set.name
#   port                     = 80
#   protocol                 = "HTTP"
# }