# set the subscription
$env:ARM_SUBSCRIPTION_ID="bb8f3354-1ce0-4efc-b2a7-8506304c5362"

# set the application / environment
$env:TF_VAR_application_name="network"
$env:TF_VAR_environment_name="dev"

# set the backend
$RESOURCE_GROUP_NAME="rg-terraform-state-dev"
$STORAGE_ACCOUNT_NAME="stdkvh533uhk"
$CONTAINTER_NAME="tfstate"
$KEY="$($env:TF_VAR_application_name)-$($env:TF_VAR_environment_name)"

#Var file
$varfile=".\env\dev.tfvars"

# run terraform
terraform init `
    -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" `
    -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" `
    -backend-config="container_name=$CONTAINTER_NAME" `
    -backend-config="key=$KEY" `
    -reconfigure

terraform @args -var-file $varfile


remove-item -path .\.terraform -recurse -force