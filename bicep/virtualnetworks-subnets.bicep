

@batchSize(1)
resource snetHub 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for (snet, index) in snetHubConfig: {
  name: snet.name
  parent: vnetHub
  properties: {
    addressPrefix: snet.subnetPrefix
  }
}]
