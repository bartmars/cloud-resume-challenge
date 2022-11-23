@description('Name for remote spoke #1')
param vnetSpoke2Name string = 'vnet-spoke2'

var snetSpoke2Config = [
  {
    name: 'gateway'
    subnetPrefix: '10.2.0.0/24'
  }
]

resource vnetSpoke2 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetSpoke2Name
}

@batchSize(1)
resource snetSpoke2 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for (snet, index) in snetSpoke2Config: {
  name: snet.name
  parent: vnetSpoke2
  properties: {
    addressPrefix: snet.subnetPrefix
  }
}]

