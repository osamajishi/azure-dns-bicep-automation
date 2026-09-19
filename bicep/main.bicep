@description('The domain name for the public DNS zone.')
param zoneName string = 'dnstest.site'

@description('A-record host name.')
param recordName string = 'www'

@description('Time-to-Live (TTL) in seconds.')
param timeToLive int = 3600

@description('List of target IPv4 addresses for round-robin load balancing.')
param targetIpv4Addresses array = [
  '1.2.3.4'
  '1.2.3.5'
]

@description('Authoritative Public DNS Zone')
resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' = {
  name: zoneName
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

@description('A-record mapped under the DNS zone')
resource aRecord 'Microsoft.Network/dnsZones/A@2023-07-01-preview' = {
  parent: dnsZone
  name: recordName
  properties: {
    TTL: timeToLive
    ARecords: [for ip in targetIpv4Addresses: {
      ipv4Address: ip
    }]
  }
}

output nameServers array = dnsZone.properties.nameServers
output fqdn string = '${recordName}.${zoneName}'
