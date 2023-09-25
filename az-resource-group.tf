# resource group
resource "azurerm_resource_group" "ecomm_rg" {
    name = "srikanth_group"
    location = "Eastus"
    tags = {
       env = "dev"                     
    }       
                     
}