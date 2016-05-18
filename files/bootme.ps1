#ps1

# This script installs puppet 3.x and deploy the manifest using puppet apply -e "include profile_base"
# Usage:
# <powershell>
# Set-ExecutionPolicy Unrestricted -Force
# icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/relybv/profile_base/master/files/bootme.ps1')) -ArgumentList ("profile_base")
#</powershell>


  param(
    [string]$role = "profile_base"
  )

  $puppet_source = "https://github.com/relybv/dirict-profile_base.git"
  $MsiUrl = "https://downloads.puppetlabs.com/windows/puppet-agent-x64-latest.msi"

  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "You must run this script as an administrator."
    Exit 1
  }

  # Install Chocolatey - ps1 will download from the url
  Write-Host "Installing Chocolatey"
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
  Write-Host "Chocolatey successfully installed."

  Write-Host "Installing packages using Chocolatey"
  choco install git -y
  choco install puppet-agent -y

  $clone_args = @("clone",$puppet_source,"C:\ProgramData\PuppetLabs\code\modules\profile_base" )
  Write-Host "Cloning $clone_args"
  $process = Start-Process -FilePath "C:\Program Files\Git\bin\git.exe" -ArgumentList $clone_args -Wait -PassThru
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

  CMD.EXE /C "certutil -v -addstore Root" $TempCert

  # install puppet windws modules
  CMD.EXE /C 'C:\Program` Files\Puppet` Labs\Puppet\bin\puppet.bat` module` install` puppetlabs/stdlib'
  CMD.EXE /C 'C:\Program` Files\Puppet` Labs\Puppet\bin\puppet.bat` module` install` chocolatey/chocolatey'
  
  $puppet_args = @("apply","-e","`"include $role`"" )
  Write-Host "Running puppet $puppet_args"
  CMD.EXE /C 'C:\Program` Files\Puppet` Labs\Puppet\bin\puppet.bat' $puppet_args
