param(
    [string]$domain
)

# DNS servers to query
$dnsServers = "8.8.8.8","8.8.4.4","208.67.222.222","208.67.220.220"

foreach($dnsServer in $dnsServers){
    $nsRecords = (Resolve-DnsName -Type NS -Name $domain -Server $dnsServer)
    $aRecords = (Resolve-DnsName -Type A -Name $domain -Server $dnsServer)
    $mxRecords = (Resolve-DnsName -Type MX -Name $domain -Server $dnsServer)
    if ($nsRecords -or $aRecords -or $mxRecords) {
        Write-Host "*****************************************************************************************************"
        Write-Host "DNS Server Used: $dnsServer"
        Write-Host "ANSWER SECTION:"
        if ($nsRecords) {
            Write-Host "    NS Records:"
            $nsRecords.NameHost | % { Write-Host "        $($_)" }
        }
        if ($aRecords) {
            Write-Host "    A Records:"
            $aRecords.IPAddress | % { Write-Host "        $($_)" }
        }
        if ($mxRecords) {
            Write-Host "    MX Records:"
            $mxRecords.MailExchange | % { Write-Host "        $($_)" }
        }
        Write-Host "Timestamp: $(Get-Date)"
        Write-Host "Query time: $($nsRecords.QueryTime) ms"
    }
}
