environment_name = "dev"
instance_count = 3
enabled = true
regions = ["eastus", "westus"]
region_instance_count = {
    "eastus" = 3
    "westus" = 5
}
region_set = ["eastus", "westus"]
sku_settings = {
    kind = "D"
    tier = "Business"
}