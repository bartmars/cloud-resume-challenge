@description('Name for remote spoke #1')
param vnetSpoke1Name string = 'vnet-spoke1'

var snetSpoke1Config = [
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

resource vnetSpoke1 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetSpoke1Name
}

@batchSize(1)
resource snetSpoke1 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for (snet, index) in snetSpoke1Config: {
  name: snet.name
  parent: vnetSpoke1
  properties: {
    addressPrefix: snet.subnetPrefix
  }
}]

