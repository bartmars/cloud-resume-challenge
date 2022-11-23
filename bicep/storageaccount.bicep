param stName string
param stLocation string
param stKind string
param stSkuName string = 'Standard_LRS'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stName
  location: stLocation
  kind: stKind
  sku: {
    name: stSkuName
  }
  properties: {
    supportsHttpsTrafficOnly: true
    customDomain: {
      name: 'resume.bartmars.dev'
      useSubDomainName: true
    }
  }
}

