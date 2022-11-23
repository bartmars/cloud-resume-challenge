param rgName string = 'bicep'
param rgLocation string = 'westeurope'

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: rgLocation
}

module vnetHub 'bicep/virtualnetwork.bicep' = {
  name: 'DeployHubVNet'
  scope: rg
}

