environment_name = "test"
instance_count = 5
enabled = false
regions = ["eastus", "westus"]
region_instance_count = {
    "eastus" = 5
    "westus" = 5
}
region_set = ["eastus", "westus"]
sku_settings = {
    kind = "D"
    tier = "Business"
}