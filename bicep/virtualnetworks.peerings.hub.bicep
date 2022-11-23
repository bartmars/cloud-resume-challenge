@description('Location of the resources')
param location string = resourceGroup().location

@description('Name for Hub vNet')
param vnetHubName string = 'vnet-hub'

@description('Name for remote spoke #1')
param vnetSpoke1Name string = 'vnet-spoke1'

// @description('Name for remote spoke #2')
// param vnetSpoke2Name string = 'vnet-spoke2'

resource vnetHub 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetHubName
}

resource vnetSpoke1 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetSpoke1Name
}

resource hubToSpoke1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  parent: vnetHub
  name: '${vnetHubName}-to-${vnetSpoke1Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: 'vnetSpoke1.id'
    }
  }
}

resource spoke1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  parent: vnetSpoke1
  name: '${vnetSpoke1Name}-to-${vnetHubName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: 'vnetHub.id'
    }
  }
}
