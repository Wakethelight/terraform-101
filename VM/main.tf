#build resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_location
}

#create public IP
resource "azurerm_public_ip" "vm1" {

  name                = "pip-${var.application_name}-${var.environment_name}-vm1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    environment = var.environment_name
  }
}

#get the virtual network and subnet
data "azurerm_subnet" "bravo" {
  name                 = "snet-bravo"
  virtual_network_name = "vnet-network-${var.environment_name}"
  resource_group_name  = "rg-network-${var.environment_name}"
}

#set up the network interface (NIC)
resource "azurerm_network_interface" "vm1" {
  name                = "nic-${var.application_name}-${var.environment_name}-vm1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.bravo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm1.id
  }
}

#make the ssh key
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/*make local files for ssh key
resource local_file "private_key" {
  filename = pathexpand("~/.ssh/vm1")
  content  = tls_private_key.vm1.private_key_pem
  file_permission = "0600"
}
resource local_file "public_key" {
  filename = pathexpand("~/.ssh/vm1.pub")
  content  = tls_private_key.vm1.public_key_openssh
  file_permission = "0600"
}
*/

#move ssh key to keyvault as secret
data "azurerm_key_vault" "main" {
  name                = "kv-devops-dev-dgzc10"
  resource_group_name = "rg-devops-dev"
}
resource "azurerm_key_vault_secret" "vm1-private" {
  name         = "vm1-ssh-private"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}
resource "azurerm_key_vault_secret" "vm1-public" {
  name         = "vm1-ssh-public"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}

#make the vm
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1${var.application_name}${var.environment_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm1.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
    
  }
}

#vm extension
resource "azurerm_virtual_machine_extension" "entra_id_login" {
  name                 = "${azurerm_linux_virtual_machine.vm1.name}-AzureSSH"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm1.id
  publisher            = "Microsoft.Azure.activeDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true

}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "vm1" {
  principal_id   = azuread_group.remote_access_users.object_id
  role_definition_name = "Virtual Machine Administrator Login"
  scope          = azurerm_linux_virtual_machine.vm1.id
}
