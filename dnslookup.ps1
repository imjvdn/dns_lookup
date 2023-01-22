param(
    [string]$domain
)

# DNS servers to query
$dnsServers = "8.8.8.8", "8.8.4.4", "208.67.222.222", "208.67.220.220", "8.20.247.10", "8.20.247.11", "50.87.144.163"

foreach ($dnsServer in $dnsServers) {
    try {
        $nsRecords = (Resolve-DnsName -Type NS -Name $domain -Server $dnsServer)
        $aRecords = (Resolve-DnsName -Type A -Name $domain -Server $dnsServer)
        $mxrecords = nslookup -q=MX $domain | Select-String "MX"
        $mxRecords = (Resolve-DnsName -Type MX -Name $domain -Server $dnsServer)
        if ($nsRecords -or $aRecords -or $mxRecords) {
            Write-Host "*****************************************************************************************************"
            Write-Host "DNS Server Used: $dnsServer"
            if ($nsRecords) {
                Write-Host "NS Records:"
                $nsRecords.NameHost | % { Write-Host "        $($_)" }
            }
            if ($aRecords) {
                Write-Host "A Records:"
                $aRecords.IPAddress | % { Write-Host "        $($_)" }
            }
            Write-Host "MX Records:"
            $mxrecords = (nslookup -q=MX $domain | Out-String) -replace "Non-authoritative answer:",""
            Write-Host $mxrecords
        }
        Write-Host "Timestamp: $(Get-Date)"
        Write-Host "Query time: $($nsRecords.QueryTime) ms"
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)"
    }
}