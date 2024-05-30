# Step 1: Create self-signed certificate
#$cert = New-SelfSignedCertificate -Subject "CN=HenrikSt_sandgraven_aad_cert" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable

# Export the public key
$publicCertPath = "C:\Users\micro\OneDrive\Certificates\henrikst_sandgraven_aad_cert.cer"
#Export-Certificate -Cert $cert -FilePath $publicCertPath

# (Optional) Export to PFX for backup
$certPath = "C:\Users\micro\OneDrive\Certificates\henrikst_sandgraven_aad_cert.pfx"
$password = ConvertTo-SecureString -String "GvFh97Dvg9oJ57KBNbkJ" -Force -AsPlainText
#Export-PfxCertificate -Cert $cert -FilePath $certPath -Password $password

# Step 2: (Manual Step) Register app and upload certificate.cer in Azure AD

# Step 3: Authenticate using the certificate
$TenantId = "ea3a1c7e-d8bc-4071-8fe9-5af9889df8d2"
$ApplicationId = "4e43ae4d-ddf3-4140-a844-01f063847f81"
$Thumbprint = "E918662E81C623B9AABBB5C5AEF85B30E8DB65B9"
#$certCredential = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2
#$certCredential.Import("Cert:\CurrentUser\My\$thumbprint")

# Load the certificate from the store using the thumbprint
$certStore = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Thumbprint -eq $thumbprint }
if ($certStore -eq $null) {
    Write-Error "Certificate not found in store"
    exit
}

Connect-AzAccount -CertificateThumbprint $certStore.Thumbprint -ApplicationId $ApplicationId -Tenant $TenantId 
