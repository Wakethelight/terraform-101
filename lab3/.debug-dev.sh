# set the subscription
export ARM_SUBSCRIPTION_ID="bb8f3354-1ce0-4efc-b2a7-8506304c5362"

# set the application / environment
export TF_VAR_application_name="observability"
export TF_VAR_environment_name="dev"

# set the backend
export BACKEND_RESOURCE_GROUP_NAME="rg-terraform-state-dev"
export BACKEND_STORAGE_ACCOUNT_NAME="stdkvh533uhk"
export BACKEND_CONTAINER_NAME="tfstate"
export BACKEND_KEY=$TF_VAR_application_name-$TF_VAR_environment_name

# run terraform
terraform init \
    -backend-config="resource_group_name=${BACKEND_RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${BACKEND_STORAGE_ACCOUNT_NAME}" \
    -backend-config="container_name=${BACKEND_CONTAINTER_NAME}" \
    -backend-config="key=${BACKEND_KEY}"

terraform $*