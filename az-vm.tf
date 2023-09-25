 # Azure virtual machine
    resource "azurerm_linux_virtual_machine" "ecomm_vm" {
  name                = "srikanth-server"
  resource_group_name = azurerm_resource_group.ecomm_rg.name
  location            = azurerm_resource_group.ecomm_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  custom_data = filebase64("ecomm.sh")
  network_interface_ids = [
    azurerm_network_interface.ecomm_pub_nic.id,
  ]


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}