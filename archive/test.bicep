param vnetLocation string = resourceGroup().location
param subnets array

resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnettest'
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
        }
      }]
  }
}


