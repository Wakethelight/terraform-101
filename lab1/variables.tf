// Application Name
variable "application_name" {
    type = string
    validation {
        condition = length(var.application_name) <= 12
        error_message = "The application name must be at least 12 character long."
    }

}

# Environnment Name
variable "environment_name" {
    type = string

/*    validation {
        condition = contains(["dev", "test", "prod"])
        error_message = "The environment name must be one of the following: dev, test, prod."
    }*/
}

/* lots of lines for comments
this is for api key
*/
variable "api_key" {
    type = string
    sensitive = true
}

variable "instance_count" {
    type = number
    validation {
        condition = var.instance_count >= local.min_nodes && var.instance_count <= local.max_nodes && var.instance_count % 2 != 0
        error_message = "Instance count must be between 1 and 9 and not even."
    }
}

variable "enabled" {
    type = bool
}

variable "regions" {
    type = list(string)
}

variable "region_instance_count" {
    type = map(string)
}

variable "region_set" {
    type = set(string)
}

variable "sku_settings" {
    type = object({
      kind = string
      tier = string
    })
}