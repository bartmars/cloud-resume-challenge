@description('Location of the resources')
param location string = resourceGroup().location

@description('Name for Hub vNet')
param vnetHubName string = 'vnet-hub'

@description('Name for remote spoke #1')
param vnetSpoke1Name string = 'vnet-spoke1'

@description('Name for remote spoke #2')
param vnetSpoke2Name string = 'vnet-spoke2'

var vnetHubConfig = {
  addressSpacePrefix: '10.0.0.0/16'
}

var vnetSpoke1Config = {
  addressSpacePrefix: '10.1.0.0/16'
}

var vnetSpoke2Config = {
  addressSpacePrefix: '10.2.0.0/16'
}

var snetSpoke1Config = [
  {
    name: 'gateway'
    subnetPrefix: '10.1.0.0/24'
  }
]

var snetSpoke2Config = [
  {
    name: 'gateway'
    subnetPrefix: '10.2.0.0/24'
  }
]

resource vnetHub 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetHubName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetHubConfig.addressSpacePrefix
      ]
    }
  }
}

module snetHub 'virtualnetworks.hub.bicep' = {
  name: 'DeployHubSubnets'
  scope: resourceGroup()
}

resource vnetSpoke1 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetSpoke1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetSpoke1Config.addressSpacePrefix
      ]
    }
  }
}

module snetSpoke1 'virtualnetworks.hub.bicep' = {
  name: 'DeploySpoke1Subnets'
  scope: resourceGroup()
}

@batchSize(1)
resource snetSpoke1 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for (snet, index) in snetSpoke1Config: {
  name: snet.name
  parent: vnetSpoke1
  properties: {
    addressPrefix: snet.subnetPrefix
  }
}]

resource vnetSpoke2 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetSpoke2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetSpoke2Config.addressSpacePrefix
      ]
    }
  }
}

@batchSize(1)
resource snetSpoke2 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for (snet, index) in snetSpoke2Config: {
  name: snet.name
  parent: vnetSpoke2
  properties: {
    addressPrefix: snet.subnetPrefix
  }
}]
