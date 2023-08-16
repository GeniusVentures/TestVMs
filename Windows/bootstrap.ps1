
# Install git
write-host -fore Green "Installing git 2.33.1 64 bit"
if (-not(Test-Path -Path 'C:\vagrant\Git-2.33.1-64-bit.exe' -PathType Leaf)) {
    Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.33.1.windows.1/Git-2.33.1-64-bit.exe' -OutFile C:\vagrant\Git-2.33.1-64-bit.exe
}

Start-Process c:\vagrant\Git-2.33.1-64-bit.exe -ArgumentList "/SILENT /NORESTART" -Wait

# download visual Studio community
if (-not(Test-Path -Path 'C:\vagrant\Git-2.33.1-64-bit.exe' -PathType Leaf)) {
    write-host -fore Green "Downloading Visual Studio 2019 Community c++ web installer"
    Invoke-WebRequest -Uri 'https://aka.ms/vs/16\/release/vs_community.exe' -OutFile C:\vagrant\vs_community.exe
}
write-host -fore Green "Installing Visual Studio 2019 Community c++"
Start-Process c:\vagrant\vs_community.exe -ArgumentList "--norestart --passive --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.VC.CMake.Project --add Microsoft.VisualStudio.Component.Windows10SDK.19041" -Wait

# setup NuGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# setup posh-vs Power Shell vs paths, etc.
write-host -fore Green "Setting up Visual Studio Powershell environment/paths"
Install-Module -Name posh-vs -Force
Install-PoshVs >$null

# download and install python 3
if (-not(Test-Path -Path 'C:\vagrant\python-3.10.0-amd64.exe' -PathType Leaf)) {
    write-host -fore Green "Downloading Python 3.10.0 installer"
    Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe' -OutFile C:\vagrant\python-3.10.0-amd64.exe
}
write-host -fore Green "Installing Python 3"
c:\vagrant\python-3.10.0-amd64.exe /passive InstallAllUsers=1 PrependPath=1 Include_test=0

#download and install perl
if (-not(Test-Path -Path 'C:\vagrant\strawberry-perl-5.32.1.1-64bit.msi' -PathType Leaf)) {
    write-host -fore Green "Downloading Perl 5.32.1.1 installer"
    Invoke-WebRequest -Uri 'https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit.msi' -OutFile C:\vagrant\strawberry-perl-5.32.1.1-64bit.msi
}
write-host -fore Green "Installing Perl 5.32.1.1"
Start-Process c:\vagrant\strawberry-perl-5.32.1.1-64bit.msi -ArgumentList "/passive /norestart" -Wait
$userPath = [System.Environment]::GetEnvironmentVariable("Path",[System.EnvironmentVariableTarget]::User)
$userPath += ";C:\Strawberry\perl\bin"
[System.Environment]::SetEnvironmentVariable("Path",$userPath, [System.EnvironmentVariableTarget]::User)


# download and install cmake
if (-not(Test-Path -Path 'C:\vagrant\cmake-3.21.4-windows-x86_64.msi' -PathType Leaf)) {
    write-host -fore Green "Downloading CMake 3.21.4 installer"
    Invoke-WebRequest -Uri 'https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4-windows-x86_64.msi' -OutFile C:\vagrant\cmake-3.21.4-windows-x86_64.msi
}
write-host -fore Green "Installing CMake 3.21.4"
Start-Process c:\vagrant\cmake-3.21.4-windows-x86_64.msi -ArgumentList "/passive /norestart" -Wait
$userPath = [System.Environment]::GetEnvironmentVariable("Path",[System.EnvironmentVariableTarget]::User)
$userPath += ";C:\Program Files\CMake\bin"
[System.Environment]::SetEnvironmentVariable("Path",$userPath, [System.EnvironmentVariableTarget]::User)

# generate and install new ssh key
write-host -fore Green "Installing new ssh key for vagrant"

if (-not(Test-Path -Path 'C:\Users\vagrant/.ssh/vagrant' -PathType Leaf)) {
    ssh-keygen -t rsa -b 4096 -f C:\Users\vagrant/.ssh/vagrant -q -P """"
}
copy C:\Users\vagrant\.ssh\vagrant C:\vagrant\.vagrant\machines\default\virtualbox\private_key
type C:\Users\vagrant\.ssh\vagrant.pub >> "C:\ProgramData\ssh\administrators_authorized_keys"
icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"

write-host -fore Green "Installing ssh server"
# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
# Start the sshd service
Start-Service sshd

Set-Service -StartupType Automatic -Name ssh-agent 
Start-Service ssh-agent 

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}


New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# update any paths added to by installs to current environment path
[System.Environment]::SetEnvironmentVariable("Path", $curMachinePath, [System.EnvironmentVariableTarget]::Machine) 
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
