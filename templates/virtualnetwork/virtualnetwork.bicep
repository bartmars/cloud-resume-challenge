// Parameters
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
param tagEnvironment string

@description('Enter the location for resources')
@allowed([
  'westeurope' // west europe
  'northeurope' // north europe
])
param location string

@description('Enter the address prefix (ie. 10.0.0.0/24)')
param vnetAddressPrefix string

@description('Enter vnet usage: hub or spoke')
param vnetUsage string

@description('Enter instance number')
param vnetInstance int

@description('Add tag for datetime of creation: default(utcNow())')
param createdOn string = utcNow()

@description('Enter costcenter for billing')
param tagCostcenter string

@description('Enter department code')
param tagDepartment string

@description('Enter the subnets that needs to be created in parameter file')
param subnets array

// Variables
@description('Get customername and only use first 3 characters')
var customerPrefix = substring(customerName, 0, 3)

// Resources
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: format('vnet{0}{1}{2}{3}', customerPrefix, tagEnvironment, vnetUsage, vnetInstance )
  location: location
  tags: {
    environment: tagEnvironment
    createdOn: createdOn
    costcenter: tagCostcenter
    department: tagDepartment    
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
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







