# virtual network
resource "azurerm_virtual_network" "ecomm_vnet" {
   name = "ecomm_network"  
   resource_group_name = azurerm_resource_group.ecomm_rg.name
   location = azurerm_resource_group.ecomm_rg.location
   address_space = ["10.0.0.0/16"]
   tags = {
    env = "dev"                        
   }                
            
}

# public subnet 
 resource "azurerm_subnet" "ecomm_pub_sn" {
    name = "ecomm_web_subnet"
    resource_group_name = azurerm_resource_group.ecomm_rg.name
    virtual_network_name = azurerm_virtual_network.ecomm_vnet.name
    address_prefixes = ["10.0.1.0/24"]
 }

 
# private subnet 
 resource "azurerm_subnet" "ecomm_pvt_sn" {
    name = "ecomm_database_subnet"
    resource_group_name = azurerm_resource_group.ecomm_rg.name
    virtual_network_name = azurerm_virtual_network.ecomm_vnet.name
    address_prefixes = ["10.0.2.0/24"]
 }

 # public network security group
 resource "azurerm_network_security_group" "ecomm_pub_nsg" {
    name = "ecomm_web_nsg"
    resource_group_name = azurerm_resource_group.ecomm_rg.name
    location = azurerm_resource_group.ecomm_rg.location
   security_rule {
       protocol                     = "Tcp"
       access                       = "Allow"
       name                         = "ssh"
       direction                    = "Inbound"
       priority                     = 1000
       source_port_range            = "*"
       destination_port_range       = "22"
       source_address_prefix        = "*"
       destination_address_prefix   = "*"

   }   

 security_rule {
       protocol                     = "Tcp"
       access                       = "Allow"
       name                         = "http"
       direction                    = "Inbound"
       priority                     = 1100
       source_port_range            = "*"
       destination_port_range       = "80"
       source_address_prefix        = "*"
       destination_address_prefix   = "*"

   } 

   tags = {
    env = "dev"                        
   }  
}
 
 # private network security group 
 resource "azurerm_network_security_group" "ecomm_pvt_nsg" {
   name                           = "ecomm_database_nsg"
   resource_group_name            =  azurerm_resource_group.ecomm_rg.name
   location                       = azurerm_resource_group.ecomm_rg.location
   security_rule {
       protocol = "Tcp"
       name     = "ssh"
       priority =  1000
       direction =  "Inbound"
       access    = "Allow"
       source_port_range = "*"
       destination_port_range = "22"
       source_address_prefix = "10.0.0.0/16"
       destination_address_prefix = "*"

   }

 security_rule {
       protocol = "Tcp"
       name     = "postgres"
       priority =  1100
       direction =  "Inbound"
       access    = "Allow"
       source_port_range = "*"
       destination_port_range = "22"
       source_address_prefix = "10.0.0.0/16"
       destination_address_prefix = "*"

   }
    tags = {
     env = "dev"                       
    }

 }

 #pub nsg association
 resource "azurerm_subnet_network_security_group_association" "ecomm_pub_nsg_a" {
     subnet_id = azurerm_subnet.ecomm_pub_sn.id
     network_security_group_id = azurerm_network_security_group.ecomm_pub_nsg.id

 }

  #pvt nsg association
 resource "azurerm_subnet_network_security_group_association" "ecomm_pvt_nsg_a" {
     subnet_id = azurerm_subnet.ecomm_pvt_sn.id
     network_security_group_id = azurerm_network_security_group.ecomm_pvt_nsg.id

 }

 # public ip on vm
 resource "azurerm_public_ip" "ecomm_pip" {
    name = "ecomm_web_pip"
    resource_group_name = azurerm_resource_group.ecomm_rg.name
    location = azurerm_resource_group.ecomm_rg.location
    allocation_method = "Static"
    tags = {
      env = "dev"                      
    }                        
 } 

 #  public nic
 resource "azurerm_network_interface" "ecomm_pub_nic" {
      name = "ecomm_web_nic"
      resource_group_name = azurerm_resource_group.ecomm_rg.name
      location = azurerm_resource_group.ecomm_rg.location

      ip_configuration {
         name = "internal"
         subnet_id = azurerm_subnet.ecomm_pub_sn.id
         public_ip_address_id = azurerm_public_ip.ecomm_pip.id
         private_ip_address_allocation = "Dynamic"                   
    }                      
 }