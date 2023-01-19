param(
    [string]$domain
)

# DNS servers to query
$dnsServers = "8.8.8.8","8.8.4.4","208.67.222.222","208.67.220.220"

# Loop through the DNS servers and query for NS records
foreach ($dnsServer in $dnsServers) {
    # Get PTR record
    $ptrRecord = (Resolve-DnsName -Type PTR -Name $dnsServer -Server $dnsServer).NameHost
    # Get current date and time
    $timestamp = Get-Date
    # Measure time it takes to complete the DNS query
    $queryTime = Measure-Command {
        $nsRecords = (Resolve-DnsName -Type NS -Name $domain -Server $dnsServer).NameServer
    }

    # Output DNS server and PTR record
    Write-Host "*****************************************************************************************************"
    Write-Host "DNS Server Used: $dnsServer"
    Write-Host "PTR Record: $ptrRecord"
    Write-Host "Timestamp: $timestamp"
    Write-Host "Query time: $($queryTime.TotalMilliseconds) ms"
    Write-Host "ANSWER SECTION:"
    $nsRecords
}
