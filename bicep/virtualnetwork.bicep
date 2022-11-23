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
]

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

@batchSize(1)
resource snetHub 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = [for (snet, index) in snetHubConfig: {
  name: snet.name
  parent: vnetHub
  properties: {
    addressPrefix: snet.subnetPrefix
  }
}]

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
