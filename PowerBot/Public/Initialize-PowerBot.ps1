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
        [string] $User = '',
        [string] $Pass = ''
    )

    Add-Type -Path (Join-Path -Path $Path -ChildPath '\lib\Selenium\Selenium.WebDriverBackedSelenium.dll')
    Add-Type -Path (Join-Path -Path $Path -ChildPath '\lib\Selenium\ThoughtWorks.Selenium.Core.dll')
    Add-Type -Path (Join-Path -Path $Path -ChildPath '\lib\Selenium\WebDriver.dll')
    Add-Type -Path (Join-Path -Path $Path -ChildPath '\lib\Selenium\WebDriver.Support.dll')


    $PhatomJsService = [OpenQA.Selenium.PhantomJS.PhantomJSDriverService]::CreateDefaultService((Join-Path -Path $Path -ChildPath '\bin\'))
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
