Write-Output "[*] Installing Active Directory Domain Services Role..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Write-Output "[*] Creating 'mekke.local' Forest Lifecycle..."
$SafeModePassword = ConvertTo-SecureString "KankaSifre123!" -AsPlainText -Force
Install-ADDSForest -DomainName "mekke.local" -SafeModeAdministratorPassword $SafeModePassword -InstallDns:$true -Force:$true

# Orman kurulumu bittikten ve servisler başladıktan sonra AD modüllerini çağır
Import-Module ActiveDirectory

Write-Output "[*] Seeding Domain Users and Security Objects..."
$UserPass = ConvertTo-SecureString "ZorluSifre123!" -AsPlainText -Force
New-ADUser -Name "Ahmet Sizma" -SamAccountName "ahmet.sizma" -UserPrincipalName "ahmet.sizma@mekke.local" -AccountPassword $UserPass -Enabled $true
New-ADUser -Name "Mehmet Servis" -SamAccountName "mehmet.servis" -UserPrincipalName "mehmet.servis@mekke.local" -AccountPassword $UserPass -Enabled $true

Write-Output "[*] Setting up ESC13 ADCS Target Infrastructure..."
# ESC13 zafiyetinin tetiklenebilmesi için Universal kapsamda bir hedef grup oluşturulmalı ve Domain Admins'e bağlanmalı
New-ADGroup -Name "ESC13TargetGroup" -GroupScope Universal -Category Security
Add-ADGroupMember -Identity "Domain Admins" -Members "ESC13TargetGroup"

Write-Output "[*] Configuring Delegated OU Boundaries for Phase 3..."
New-ADOrganizationalUnit -Name "KritikSunucular" -Path "DC=mekke,DC=local"
$OU = [ADSI]"LDAP://OU=KritikSunucular,DC=mekke,DC=local"
$Identity = New-Object System.Security.Principal.NTAccount("MEKKE\ahmet.sizma")

# bloodyAD manipülasyonunun sorunsuz çalışması için hem gPLink hem gPOptions GUID hakları atanmalıdır
$gPLinkGUID = [Guid]"f30e3bc1-4c0e-11d1-b244-0000f875973d"
$gPOptionsGUID = [Guid]"f30e3bc2-4c0e-11d1-b244-0000f875973d"

$ACE1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($Identity, "WriteProperty", "Allow", $gPLinkGUID)
$ACE2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($Identity, "WriteProperty", "Allow", $gPOptionsGUID)

$OU.ObjectSecurity.AddAccessRule($ACE1)
$OU.ObjectSecurity.AddAccessRule($ACE2)
$OU.CommitChanges()

Write-Output "[*] Planting Tier-0 Final Flag..."
$FlagPath = "C:\Users\Administrator\Desktop\FINAL_FLAG.txt"
Out-File -FilePath $FlagPath -InputObject "FLAG{c3rt1py_3sc13_d0m41n_pwn3d}" -Encoding UTF8
