param(
    [string]$domain
)

# DNS servers to query
$dnsServers = "8.8.8.8","8.8.4.4","208.67.222.222","208.67.220.220"

foreach($dnsServer in $dnsServers){
    $nsRecords = (Resolve-DnsName -Type NS -Name $domain -Server $dnsServer)
    if ($nsRecords) {
        Write-Host "*****************************************************************************************************"
        Write-Host "DNS Server Used: $dnsServer"
        Write-Host "ANSWER SECTION:"
        $nsRecords.NameHost | % { Write-Host "    $($_)" }
        Write-Host "Timestamp: $(Get-Date)"
        Write-Host "Query time: $($nsRecords.QueryTime) ms"
    }
}
