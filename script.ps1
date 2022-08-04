# install IIS server role
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# remove default htm file
remove-item  C:\inetpub\wwwroot\iisstart.htm

# Add a new htm file that displays server name
Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $("MOD06 - Lab02- AZ104 - Terraform " + $env:computername)