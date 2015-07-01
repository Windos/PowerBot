#requires -Version 3 -Modules PowerBot
function Initialize-PowerBot
{
    <#
            .SYNOPSIS
            Short Description
            .DESCRIPTION
            Detailed Description
            .EXAMPLE
            Initialize-PowerBot
            explains how to use the command
            can be multiple lines
            .EXAMPLE
            Initialize-PowerBot
            another example
            can have as many examples as you like
    #>
    [CmdletBinding()]
    Param (
        [string] $Path = (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path),
        [string] $Streamer = 'windos',
        [string] $User = '-----BEGIN CMS-----
MIIBtwYJKoZIhvcNAQcDoIIBqDCCAaQCAQAxggFPMIIBSwIBADAzMB8xHTAbBgNVBAMMFGFkbWlu
amtAa2luZy5nZWVrLm56AhBVcxScnOIMqESt8yVblEh2MA0GCSqGSIb3DQEBBzAABIIBAB0vcb/y
rAeaQE+R7HLmTrliRB2YRPjtE8yFpuSi3I4pukILbIXm9VSsfgWHwX8F+gfWywIWhjDgkUOFiBIx
ANyJ9Y2z5mjHDj31PfB4m+2eCDJKNfSbpbhDJtb0NSYYPZeQEn7QTOi6699Y++DZjbnKI/gSheu+
OgpCGT+gud1j4ceS9OnTeCpOYqRsX2eyGCV+4zevhM2Li14VMX4ov/MXrRI5A0K4cnO0ZK6aab6E
mY6TYFdtOcbJZ0XRL/Arqq5EHTIAprWvGXA+nwvAEMRbrRAu0SY5bBACZZOb/mIAv93qjv5JVIbo
+oBF9baCkxZY1ESN+iF6JZ4+wrZ7LUUwTAYJKoZIhvcNAQcBMB0GCWCGSAFlAwQBKgQQnvBTeGa4
JbsL2ATWVOWH6YAg23j6ZPF+poLAwxYxwv2aYGQMg+9gn6QsVwFD31DE8fA=
-----END CMS-----',
        [string] $Pass = '-----BEGIN CMS-----
MIIB5wYJKoZIhvcNAQcDoIIB2DCCAdQCAQAxggFPMIIBSwIBADAzMB8xHTAbBgNVBAMMFGFkbWlu
amtAa2luZy5nZWVrLm56AhBVcxScnOIMqESt8yVblEh2MA0GCSqGSIb3DQEBBzAABIIBAIsBm3TP
xFYp/EpC+bFGjOngshX7amJBzFZm9BcJEtdgrV05HQfvSLQ8ohGQHX/msTW9NYu0YWX/2qOHdY2o
jDLl6wBAYHskIh4d65MPSDGBQz375WSSMYg9Q406uznJj4TRL58vGZSrrIm4vFMDsuTdd46HuTle
D301nYjaLSpu4nV53niIkWMhU5higgyf+bOsAP/NU4Z0ywvtwi9G6/RiOEfgIZWpQt4Bayt9eMTT
y2o7EtX2CZ4n74TUkfbuxELcfAHZryRsb1+9OireAFILoK0BrSvzpyJkKhqSLzPAwn9mFa0603gr
zXMhSLN8/1ffLv2wCAngIB/p3x6P8OgwfAYJKoZIhvcNAQcBMB0GCWCGSAFlAwQBKgQQb0sGVD3b
jZVbsuML9sxfaIBQqhpkkfpcgP597c1Wz6+RrktXgRGm8JaE0hNEaxsF5Gf21vh0StxMIGjQsJfe
6G6mxm/kqjjgcFBfemfRGrxQdrnCvpnHIqMdY2CFxfN7Zt0=
-----END CMS-----'
    )

    $null = Start-Job -Name 'SeleniumInstall' -ScriptBlock {
        Install-ReqSoftware -Product 'Selenium' -Uri 'http://selenium-release.storage.googleapis.com/2.45/selenium-dotnet-2.45.0.zip'
    }

    $null = Start-Job -Name 'PhantomJsInstall' -ScriptBlock {
        Install-ReqSoftware -Product 'PhantomJs' -Uri 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-windows.zip'
    }

    $null = Wait-Job -Name 'SeleniumInstall'
    Get-Job -Name 'SeleniumInstall'  | Remove-Job

    Add-Type -Path (Join-Path -Path $Path -ChildPath '\Selenium\net40\Selenium.WebDriverBackedSelenium.dll')
    Add-Type -Path (Join-Path -Path $Path -ChildPath '\Selenium\net40\ThoughtWorks.Selenium.Core.dll')
    Add-Type -Path (Join-Path -Path $Path -ChildPath '\Selenium\net40\WebDriver.dll')
    Add-Type -Path (Join-Path -Path $Path -ChildPath '\Selenium\net40\WebDriver.Support.dll')

    $null = Wait-Job -Name 'PhantomJsInstall'
    Get-Job -Name 'PhantomJsInstall' | Remove-Job

    $PhatomJsService = [OpenQA.Selenium.PhantomJS.PhantomJSDriverService]::CreateDefaultService((Join-Path -Path $Path -ChildPath '\PhantomJS\phantomjs-2.0.0-windows\bin\'))
    $PhatomJsService.HideCommandPromptWindow = $true

    $Global:PhantomJsDriver = New-Object -TypeName OpenQA.Selenium.PhantomJS.PhantomJSDriver -ArgumentList @(,$PhatomJsService)
    $Global:PhantomJsDriver.Navigate().GoToUrl('https://www.livecoding.tv/accounts/login/')

    $UserField = $Global:PhantomJsDriver.FindElementById('id_login')
    $PassField = $Global:PhantomJsDriver.FindElementById('id_password')
    $Buttons = $Global:PhantomJsDriver.FindElementsByTagName('button')

    foreach ($Button in $Buttons)
    {
        if ($Button.Text -eq 'Login')
        {
            $LoginButton = $Button
        }
    }

    if ($User -notlike '*-BEGIN CMS-*')
    {
        $Cred = Get-Credential

        $UserField.SendKeys($Cred.Username)
        $PassField.SendKeys($Cred.GetNetworkCredential().Password)
    }
    else
    {
        $UserField.SendKeys(($User | Unprotect-CmsMessage))
        $PassField.SendKeys(($Pass | Unprotect-CmsMessage))
    }

    $LoginButton.Click()

    $Global:PhantomJsDriver.Navigate().GoToUrl("https://www.livecoding.tv/chat/$Streamer/")

    $StopLoop = $false
    [int]$Retrycount = 0

    do
    {
        try
        {
            $Global:messageTextArea = $Global:PhantomJsDriver.FindElementById('message-textarea')
            $Global:chatSendButton = $Global:PhantomJsDriver.FindElementByClassName('submit')
            $StopLoop = $true
        }
        catch
        {
            if ($Retrycount -gt 5)
            {
                $StopLoop = $true
            }
            else
            {
                Start-Sleep -Seconds 10
                $Retrycount = $Retrycount + 1
            }
        }
    }
    While ($StopLoop -eq $false)

    #region GlobalVariable
    $Global:isMuted = $false
    $Global:ViewersGreeted = @()
    $Global:NewViewers = @{}
    $Global:PBCommands = @()
    #endregion

    #region LoadPersistentData
    $PersistentPath = Join-Path -Path $Path -ChildPath '\PersistentData\'

    if (Test-Path -Path (Join-Path -Path $PersistentPath -ChildPath 'commands.csv'))
    {
        $Global:PBCommands = Import-Csv -Path (Join-Path -Path $PersistentPath -ChildPath 'commands.csv')
    }
    else
    {
        New-PBCommand -Command '!help' -Message ''
        New-PBCommand -Command '!add' -Message '' -Admin
        New-PBCommand -Command '!edit' -Message '' -Admin
        New-PBCommand -Command '!remove' -Message '' -Admin
    }

    if (Test-Path -Path (Join-Path -Path $PersistentPath -ChildPath 'viewersGreeted.csv'))
    {
        $Global:ViewersGreeted = Import-Csv -Path (Join-Path -Path $PersistentPath -ChildPath 'viewersGreeted.csv')
    }
    else
    {
        $Properties = @{
            'Name' = $Streamer
            'LastGreeted' = (Get-Date)
        }
        New-Object -TypeName PSCustomObject -Property $Properties | Export-Csv -Path (Join-Path -Path $PersistentPath -ChildPath 'viewersGreeted.csv')
    }
    #endregion
}
