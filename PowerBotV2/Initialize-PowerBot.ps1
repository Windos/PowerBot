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
        [string] $Path = (Split-Path -Path (Get-Module -Name 'PowerBotV2' -ListAvailable).Path),
        [string] $Streamer = 'windos',
        [string] $User = '',
        [string] $Pass = ''
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

        $UserField.SendKeys($Cred.UserName)
        $PassField.SendKeys($Cred.GetNetworkCredential())
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
    $Global:LastCmdResponse = @{}
    $Global:PBCommands = @{
        '!help' = ''
        '!twitter' = 'Follow Windos on Twitter: https://twitter.com/WindosNZ'
        '!microsoft' = 'Windos doesn''t work for Microsoft'
    }
    #endregion
}
