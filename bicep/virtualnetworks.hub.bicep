@description('Name for Hub vNet')
param vnetHubName string = 'vnet-hub'

var snetHubConfig = [
  {
    name: 'gateway'
    subnetPrefix: '10.0.0.0/24'
  }
  {
    name: 'AzureBastionSubnet'
    subnetPrefix: '10.0.1.0/24'
  }
  {
    name: 'AzureFirewallSubnet'
    subnetPrefix: '10.0.2.0/24'
  }
  {
    name: 'subnet10'
    subnetPrefix: '10.0.10.0/24'
  }
]

resource vnetHub 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetHubName
}

@batchSize(1)
resource snetHub 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for (snet, index) in snetHubConfig: {
  name: snet.name
  parent: vnetHub
  properties: {
    addressPrefix: snet.subnetPrefix
  }
}]
