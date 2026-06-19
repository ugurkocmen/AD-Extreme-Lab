Write-Output "[*] Aligning DNS Topography with Domain Controller..."
$NetAdapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
Set-DnsClientServerAddress -InterfaceIndex $NetAdapter.InterfaceIndex -ServerAddresses "192.168.56.10"

Write-Output "[*] Deploying Endpoint Firewalls and Access Control Lists..."
# Kali'nin keşif taramalarını blokla ancak exploitation aşamasındaki servis kapılarını (SMB 445 dahil) açık bırak
New-NetFirewallRule -DisplayName "Block_Kali_Scanning" -Direction Inbound -RemoteAddress 192.168.56.20 -Action Block -Severity Critical
New-NetFirewallRule -DisplayName "Allow_ADCS_Exploitation" -Direction Inbound -RemoteAddress 192.168.56.20 -LocalPort 80,443,88,389,445 -Protocol TCP -Action Allow

Write-Output "[*] Provisioning Data Leak and Honeytoken Environments..."
$TargetDir = "C:\Users\Public\Documents\Shares"
New-Item -ItemType Directory -Force -Path $TargetDir

$ConfigContent = @"
<configuration>
   <appSettings>
      <add key="db_connection" value="Server=192.168.56.11;Database=CustomerData;Uid=MEKKE\ahmet.sizma;Pwd=ZorluSifre123!;" />
   </appSettings>
</configuration>
"@

Out-File -FilePath "$TargetDir\web.config" -InputObject $ConfigContent -Encoding UTF8
Out-File -FilePath "$TargetDir\flag_2.txt" -InputObject "FLAG{gp0_l1nk_0v3rwr1t3_f0und}" -Encoding UTF8

# Honeytoken tuzağını simüle et (Walkthrough içerisinde uyarısı bulunan sahte lsass dökümü)
$HoneyDir = "C:\Backup"
New-Item -ItemType Directory -Force -Path $HoneyDir
Out-File -FilePath "$HoneyDir\lsass.dmp" -InputObject "HONEYTOKEN_ACTIVATED: Defending team has been alerted!" -Encoding UTF8

Write-Output "[*] Performing Domain Join Operations..."
$Password = ConvertTo-SecureString "KankaSifre123!" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential("MEKKE\Administrator", $Password)
Add-Computer -DomainName "mekke.local" -Credential $Credential -Force -Restart
