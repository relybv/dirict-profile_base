#ps1

# This script installs puppet 4.x and deploy the manifest using puppet apply -e "include profile_base"
# Usage:
# <powershell>
# Set-ExecutionPolicy Unrestricted -Force
# icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/relybv/dirict-profile_base/master/files/bootme.ps1')) -ArgumentList ("profile_base")
#</powershell>


  param(
    [string]$role = "profile_base"
  )

  $puppet_source = "https://github.com/relybv/dirict-profile_base.git"

  # check admin rights
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "You must run this script as an administrator."
    Exit 1
  }

  # Install Chocolatey - ps1 will download from the url
  Write-Host "Installing Chocolatey"
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

  Write-Host "Installing packages using Chocolatey"
  choco install git -y --allow-empty-checksums --force
  choco install puppet-agent -y --allow-empty-checksums --force

  # cloning or pull repo
  if(!(Test-Path -Path "C:\ProgramData\PuppetLabs\code\modules\profile_base" )){
    $clone_args = @("clone",$puppet_source,"C:\ProgramData\PuppetLabs\code\modules\profile_base" )
  } else {
    $clone_args = @("pull")
    Set-Location -Path "C:\ProgramData\PuppetLabs\code\modules\profile_base"
  }
 
  Write-Host "git $clone_args"
  $process = Start-Process -FilePath "C:\Program Files\Git\bin\git.exe" -ArgumentList $clone_args -Wait -PassThru -NoNewWindow
  if ($process.ExitCode -ne 0) {
    Write-Host "Git clone failed."
    Exit 1
  }
  Write-Host "Repo successfully cloned."

  # import certificate
  $CertUrl = "https://www.geotrust.com/resources/root_certificates/certificates/GeoTrust_Global_CA.pem"
  $TempDir = [System.IO.Path]::GetTempPath()
  $TempCert = $TempDir + "/GeoTrust_Global_CA.pem"
  Write-Host "Downloading Certificate to $TempCert"
  $client = new-object System.Net.WebClient
  $client.DownloadFile( $CertUrl, $TempCert )
  certutil -v -addstore Root $TempCert

  # install puppet windws modules
  $puppet_path = "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat"
  $puppet_modinst = "module install "

  $puppet_module = "puppetlabs/windows"
  $puppet_arg = $puppet_modinst + $puppet_module
  $process = Start-Process -FilePath $puppet_path -ArgumentList $puppet_arg -Wait -PassThru -NoNewWindow
  if ($process.ExitCode -ne 0) {
    Write-Host "Install of $puppet_module failed."
    Exit 1
  }
  Write-Host "$puppet_module successfully installed."

  $puppet_module = "puppet/msoffice"
  $puppet_arg = $puppet_modinst + $puppet_module
  $process = Start-Process -FilePath $puppet_path -ArgumentList $puppet_arg -Wait -PassThru -NoNewWindow
  if ($process.ExitCode -ne 0) {
    Write-Host "Install of $puppet_module failed."
    Exit 1
  }
  Write-Host "$puppet_module successfully installed."

  $puppet_module = "puppetlabs/mount_iso"
  $puppet_arg = $puppet_modinst + $puppet_module
  $process = Start-Process -FilePath $puppet_path -ArgumentList $puppet_arg -Wait -PassThru -NoNewWindow
  if ($process.ExitCode -ne 0) {
    Write-Host "Install of $puppet_module failed."
    Exit 1
  }
  Write-Host "$puppet_module successfully installed."

  $puppet_module = "dschaaff/nxlog"
  $puppet_arg = $puppet_modinst + $puppet_module
  $process = Start-Process -FilePath $puppet_path -ArgumentList $puppet_arg -Wait -PassThru -NoNewWindow
  if ($process.ExitCode -ne 0) {
    Write-Host "Install of $puppet_module failed."
    Exit 1
  }
  Write-Host "$puppet_module successfully installed."

  $puppet_module = "puppetlabs/motd"
  $puppet_arg = $puppet_modinst + $puppet_module
  $process = Start-Process -FilePath $puppet_path -ArgumentList $puppet_arg -Wait -PassThru -NoNewWindow
  if ($process.ExitCode -ne 0) {
    Write-Host "Install of $puppet_module failed."
    Exit 1
  }
  Write-Host "$puppet_module successfully installed."

  # running puppet apply  
  $puppet_arg = @("apply","-e","`"include $role`"" )
  Write-Host "Running puppet $puppet_arg"
  $process = Start-Process -FilePath $puppet_path -ArgumentList $puppet_arg -Wait -PassThru -NoNewWindow
  if ($process.ExitCode -ne 0) {
    Write-Host "puppet apply failed."
    Exit 1
  }
  Write-Host "puppet apply OK"
