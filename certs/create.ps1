param(
[string] $server,
[string] $friendlyName,
[string] $adminName,
[string] $adminPwd,
[string] $workingDir
)

Write-Host "Creating Certificate request (CSR) for $server `r"
$infFile = "cert.inf"
$requestFile = "$workingDir\$server.inf"

$today = get-date -format "MMddyyyyhhmmss"
$expires = ((get-date).AddYears(2).AddDays(-1)).ToString("MMddyyyyhhmmss")

$certName = "$friendlyName $today-$expires"
$certFile = "$workingDir\$certName.cer"
$caAuthority= "cert authority url"
$template = "CertificateTemplate:SSLCert-SHA256"
$csrPath = "$workingDir\$certName.req"
$user = "$adminName@codenewa"

if(test-path -path $csrPath){
    Remove-Item -Path $csrPath -Force
}

if(test-path -Path $infFile){
    Write-Host "INF File to use is: $infFile"

    $INF = get-content $infFile
    $INF = $INF.Replace("<<certName>>","$certName")

    $INF | out-file $requestFile

    certreq -new $requestFile $csrPath

    Write-Host "Certificate Request has been generated."

    Write-Host (get-content $csrPath)
    
    Write-Host "Generating Certificate now from $csrPath"

    Write-Host "Requesting for cert from CA: $caAuthority" 
    WRite-Host "File to submit is $csrPath"
    Write-Host "Cert requested is $certFile"
    Write-Host "Creating cert as $user"
    Write-Host "Certificate Generation does not work atm. Please generate manually."
    certreq -f -attrib $template -config $caAuthority -submit -username $user -p $adminPwd $csrPath $certFile -q

    if(test-path -path $certFile)
    {
        Write-Host "Certificate created at: $certFile"

        $thumbPrint = (Get-PfxCertificate $certFile).Thumbprint
        Write-Host "Thumbprint: $thumbPrint"

        Write-Host "Installing Certificate"

        Import-Certificate -FilePath $certFile -CertStoreLocation Cert:\LocalMachine\My

        Write-Host "Installed Certificate"


        Write-Host "Adding to IIS"
        Write-Host "Creating App ID"

        $appId = new-guid

        netsh http delete sslcert ipport=0.0.0.0:443
        netsh http add sslcert ipport=0.0.0.0:443 certhash=$thumbPrint appid="{$appId}"

        Write-Host "Assigned cert with hash $thumbPrint to 443 port with appId: $appId"
    }

}else{
    Write-Host "INF file not found for $server. Make sure it is in the repository."
    Exit 1
}
