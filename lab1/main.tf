locals {
    min_nodes = 3
    max_nodes = 10
}
resource "random_string" "suffix" {
    length = 6
    upper = false
    special = false
}

locals {
    environment_prefix = "${var.application_name}-${var.environment_name}"
    vm_suffix = random_string.suffix.result
    vm_name = "${local.environment_prefix}-${local.vm_suffix}"

    regional_stamps = {
        "foo" = {
            region = "eastus"
            min_node_count = 4
            max_node_count = 8
        },
        "bar" = {
            region = "westus"
            min_node_count = 4
            max_node_count = 8
        }
    }
}


module "regional_stamps" {
    source = "./modules/regional-stamp"

    for_each = local.regional_stamps

    region = each.value.region
    name = each.key
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
}







/*
resource "random_string" "list"{
    
    count = length(var.regions)
    
    length = 6
    upper = false
    special = false
}

resource "random_string" "map"{
    
    for_each = var.region_instance_count
    
    length = 6
    upper = false
    special = false
}

resource "random_string" "if" {

    // the 1 is = true, the 0 = false. if true, set to 1, if false, set to 1
    count = var.enabled ? 1 : 0

    length = 6
    upper = false
    special = false
}

*/