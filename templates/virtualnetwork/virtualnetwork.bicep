@description('Enter customer name abbreviation (3 letters)')
@maxLength(3)
param customerName string

@description('Environment stage for resources: dev, tst, stg, prd')
@allowed([
  'dev' // development
  'tst' // test
  'stg' // staging
  'prd' // production
])
@maxLength(3)
param environment string

@allowed([
  'weu' // west europe
  'neu' // north europe
])
@maxLength(3)
param locationAbbreviation string

@description('Enter the location for resources')
@allowed([
  'westeurope' // west europe
  'northeurope' // north europe
])
param location string

@description('Enter the address prefix (ie. 10.0.0.0/24)')
param addressPrefix string

@description('Enter vnet usage: hub or spoke')
param usage string

@description('Add tag for datetime of creation: default(utcNow())')
param createdOn string = utcNow()

@description('Enter costcenter for billing')
param costcenter string

@description('Enter department code')
param department string

param vnetSettings object = {
  name: format('vnet{0}{1}{2}{3}', customerName, environment, locationAbbreviation, usage)
  location: location
  addressPrefixes: [
    {
      name: format('vnet{0}{1}{2}{3}', customerName, environment, locationAbbreviation, usage)
      addressPrefix: addressPrefix
    }
  ]
  subnets: [
    {
      name: 'subnet0'
      addressPrefix: '10.0.0.0/24'
    }
    {
      name: 'subnet1'
      addressPrefix: '10.0.1.0/24'
    }
  ]
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetSettings.name
  location: vnetSettings.location
  tags: {
    environment: environment
    createdOn: createdOn
    costcenter: costcenter
    department: department    
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetSettings.addressPrefixes[0].addressPrefix
      ]
    }
    subnets: [
      {
        name: vnetSettings.subnets[0].name
        properties: {
          addressPrefix: vnetSettings.subnets[0].addressPrefix
        }
      }
      {
        name: vnetSettings.subnets[1].name
        properties: {
          addressPrefix: vnetSettings.subnets[1].addressPrefix
        }
      }
    ]
  }
}







