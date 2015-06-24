# Get-Job | Stop-Job
# Get-Job | Remove-Job
# 
# $phantomJsDriver.Quit()

$modulePath = (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path)
$githubPath = 'C:\github\PowerBot\PowerBot.psm1'

Remove-Module -Name 'PowerBot' -ErrorAction SilentlyContinue
Copy-Item -Path $githubPath -Destination $modulePath -Force

Initialize-PowerBot