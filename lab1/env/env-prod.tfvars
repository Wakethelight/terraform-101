environment_name = "prod"
instance_count = 5
enabled = true
regions = ["eastus", "westus", "eastus"]
region_instance_count = {
    "eastus" = 7
    "westus" = 9
}
region_set = ["eastus", "westus"]
sku_settings = {
    kind = "D"
    tier = "Business"
}