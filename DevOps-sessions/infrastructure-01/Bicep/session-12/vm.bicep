param region string = 'westeurope'
param vmName string
param vnetName string
param subnetName string
param vmImage object
param vmTier string = 'Standard_D1_v2'
param vmDiskTier string
param vmDiskSizeGb int = 30

var subnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource vm 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vmName
  location: region
  properties: {
    hardwareProfile: {
      vmSize: vmTier
    }
    networkProfile: {
      networkApiVersion: '2020-11-01'
      networkInterfaceConfigurations: [
        {
          name: '${vmName}-nic'
          properties: {
            ipConfigurations: [
              {
                name: '${vmName}-ipconf'
                properties: {
                  privateIPAddressVersion: 'IPv4'
                  publicIPAddressConfiguration: {
                    name: '${vmName}-publicip'
                    properties: {
                      dnsSettings: {
                          domainNameLabel: vmName
                      }
                      publicIPAddressVersion: 'IPv4'
                    }
                    sku: {
                      name: 'Basic'
                    }
                  }
                  subnet: {
                    id: subnetId
                  }
                }
              }
            ]
          }
        }
      ]
    }
    osProfile: {
      adminPassword: 'P455/w0rd'
      adminUsername: 'azureuser'
      computerName: 'azurepc'
    }
    storageProfile: {
      imageReference: vmImage
      osDisk: {
          createOption: 'fromImage'
          deleteOption: 'Delete'
          diskSizeGB: vmDiskSizeGb
          managedDisk: {
              storageAccountType: vmDiskTier
          }
          name: '${vmName}-osdisk'
      }
    }
  }
}


