# set the subscription
$env:ARM_SUBSCRIPTION_ID="bb8f3354-1ce0-4efc-b2a7-8506304c5362"

# set the application / environment
$env:TF_VAR_application_name="devops"
$env:TF_VAR_environment_name="prod"

# set the backend
$RESOURCE_GROUP_NAME="rg-terraform-state-prod"
$STORAGE_ACCOUNT_NAME="stiyj5byc6d3"
$CONTAINTER_NAME="tfstate"
$KEY="$($env:TF_VAR_application_name)-$($env:TF_VAR_environment_name)"

# run terraform
terraform init `
    -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" `
    -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" `
    -backend-config="container_name=$CONTAINTER_NAME" `
    -backend-config="key=$KEY"

terraform @args


remove-item -path .\.terraform -recurse -force