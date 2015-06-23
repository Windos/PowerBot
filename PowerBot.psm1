﻿#requires -Version 5

function Push-DashingJson
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param (
        # Parameter help
        [Parameter(Mandatory = $true,
                Position = 0,
        ValueFromPipeline = $true)]
        [PSCustomObject[]] $Object,

        # Parameter help
        [Parameter(Mandatory = $true,
        Position = 1)]
        [string] $Widget,

        # Specifies the Uniform Resource Identifier (URI) of the Dashing installation.
        [Parameter(Mandatory = $false)]
        [string] $Uri = 'http://dash1:3030'
    )
    
    process
    {
        foreach ($obj in $Object)
        {
            $json = $obj | ConvertTo-Json
            $null = Invoke-RestMethod -Method Post -Body $json -Uri "$Uri/widgets/$Widget"
        }
    }
}

function Export-PBCommands
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param (
        # Parameter help
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [hashtable] $Collection = $Global:PBCommands,

        # Parameter help
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [string] $Path = $Global:CommandsCsv
    )
    
    $object = $Collection.GetEnumerator() | foreach {
    New-Object -TypeName PSObject -Property @{'Command' = $_.Name;
                                              'Message' = $_.Value}
    }
    
    $object | Export-Csv $Path -NoTypeInformation
}

function Import-PBCommands
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param (
        # Parameter help
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [string] $Path = $Global:CommandsCsv
    )
    
    $global:PBCommands = @{}
    $object = Import-Csv $Path | foreach {
        $global:PBCommands.Add($_.Command, $_.Message)
    }
}

function Initialize-PowerBot 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param (
        [string] $powerBotPath = (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path)
    )
    
    $null = Start-Job -Name 'SeleniumInstall' -ScriptBlock {
        $powerBotPath = $args[0]
        if (!(Test-Path -Path (Join-Path -Path $powerBotPath -ChildPath 'selenium\Selenium.WebDriverBackedSelenium.dll'))) 
        {
            Write-Verbose -Message "Selenium not present in $powerBotPath, downloading latest version."

            $seleniumSource = 'http://selenium-release.storage.googleapis.com/2.45/selenium-dotnet-2.45.0.zip'
            $seleniumArchive = Join-Path -Path $powerBotPath -ChildPath 'selenium.zip'
 
            Invoke-WebRequest -Uri $seleniumSource -OutFile $seleniumArchive

            Write-Verbose -Message 'Expanding Selenium archive.'

            Expand-Archive -Path $seleniumArchive -DestinationPath (Join-Path -Path $powerBotPath -ChildPath '\temp-selenium')

            Write-Verbose -Message 'Copying component files to permenant location.'
            $seleniumPath = Join-Path -Path $powerBotPath -ChildPath 'Selenium\'

            if (!(Test-Path -Path $seleniumPath)) 
            {
                $null = New-Item -ItemType Directory -Path $seleniumPath
            }
            Copy-Item -Path (Join-Path -Path $powerBotPath -ChildPath '\temp-selenium\net40\*') -Destination $seleniumPath

            Remove-Item -Path $seleniumArchive
            Remove-Item -Path (Join-Path -Path $powerBotPath -ChildPath '\temp-selenium') -Recurse -Force
        }
    } -ArgumentList @(,$powerBotPath)

    $null = Start-Job -Name 'PhantomJsInstall' -ScriptBlock {
        $powerBotPath = $args[0]
        if (!(Test-Path -Path (Join-Path -Path $powerBotPath -ChildPath '\PhantomJS\PhantomJS.exe'))) 
        {
            Write-Verbose -Message "PhantomJS not present in $powerBotPath, downloading latest version."

            $phantomJsSource = 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.0.0-windows.zip'
            $phantomJsArchive = Join-Path -Path $powerBotPath -ChildPath 'phantomjs.zip'
 
            Invoke-WebRequest -Uri $phantomJsSource -OutFile $phantomJsArchive

            Write-Verbose -Message 'Expanding PhantomJS archive.'

            Expand-Archive -Path $phantomJsArchive -DestinationPath (Join-Path -Path $powerBotPath -ChildPath '\temp-phantomjs')

            Write-Verbose -Message 'Copying component files to permenant location.'
            $phantomJSPath = Join-Path -Path $powerBotPath -ChildPath 'PhantomJS\'

            if (!(Test-Path -Path $phantomJSPath)) 
            {
                $null = New-Item -ItemType Directory -Path $phantomJSPath
            }
            Copy-Item -Path (Join-Path -Path $powerBotPath -ChildPath '\temp-phantomjs\phantomjs-2.0.0-windows\bin\*') -Destination $phantomJSPath

            Remove-Item -Path $phantomJsArchive
            Remove-Item -Path (Join-Path -Path $powerBotPath -ChildPath '\temp-phantomjs') -Recurse -Force
        }
    } -ArgumentList @(,$powerBotPath)

    $null = Wait-Job -Name 'SeleniumInstall' -Timeout 180
    Get-Job -Name 'SeleniumInstall'  | Remove-Job

    Add-Type -Path (Join-Path -Path $powerBotPath -ChildPath '\Selenium\Selenium.WebDriverBackedSelenium.dll')
    Add-Type -Path (Join-Path -Path $powerBotPath -ChildPath '\Selenium\ThoughtWorks.Selenium.Core.dll')
    Add-Type -Path (Join-Path -Path $powerBotPath -ChildPath '\Selenium\WebDriver.dll')
    Add-Type -Path (Join-Path -Path $powerBotPath -ChildPath '\Selenium\WebDriver.Support.dll')
    
    $null = Wait-Job -Name 'PhantomJsInstall' -Timeout 180
    Get-Job -Name 'PhantomJsInstall' | Remove-Job

    $phatomJsService = [OpenQA.Selenium.PhantomJS.PhantomJSDriverService]::CreateDefaultService((Join-Path -Path $powerBotPath -ChildPath '\PhantomJS\'))
    $phatomJsService.HideCommandPromptWindow = $true
    
    $Global:phantomJsDriver = New-Object -TypeName OpenQA.Selenium.PhantomJS.PhantomJSDriver -ArgumentList @(,$phatomJsService)

    $email = ''
    
    $pass = ''
    
    $Global:phantomJsDriver.Navigate().GoToUrl('https://www.livecoding.tv/accounts/login/')
    
    $userNameField = $Global:phantomJsDriver.FindElementById('id_login')
    $passwordField = $Global:phantomJsDriver.FindElementById('id_password')
    $buttons = $Global:phantomJsDriver.FindElementsByTagName('button')
    
    foreach ($button in $buttons) 
    {
        if ($button.Text -eq 'Login') 
        {
            $loginButton = $button
        }
    }
    
    $userNameField.SendKeys(($email | Unprotect-CmsMessage))
    $passwordField.SendKeys(($pass | Unprotect-CmsMessage))
    $loginButton.Click()
    
    $Global:phantomJsDriver.Navigate().GoToUrl('https://www.livecoding.tv/chat/windos/')
    
    $Global:viewersGreeted = @()
    $Global:viewersGreetedCsv = Join-Path -Path $powerBotPath -ChildPath 'greeted.csv'
    
    if (!(Test-Path -Path $Global:viewersGreetedCsv))
    {
        $null = New-Item -Path $Global:viewersGreetedCsv -ItemType File
    }
    
    $importedGreeted = Import-Csv -Path $Global:viewersGreetedCsv
    
    foreach ($previousGreet in $importedGreeted)
    {
        $properties = @{
            'Name'      = $previousGreet.Name
            'whenGreeted' = (Get-Date -Date $previousGreet.whenGreeted)
        }
        $Result = New-Object -TypeName psobject -Property $properties
        $Global:viewersGreeted += $Result
    }
    
    $Global:newViewers = @{}
    $Global:ChatLog = Join-Path -Path $powerBotPath -ChildPath 'chatlog.csv'
    $Global:CommandsCsv = Join-Path -Path $powerBotPath -ChildPath 'commands.csv'
    $Global:MemLog = @()

    if (!(Test-Path -Path $Global:CommandsCsv))
    {
        $null = New-Item -Path $Global:CommandsCsv -ItemType File
    }
    
    if (!(Test-Path -Path $Global:ChatLog))
    {
        $null = New-Item -Path $Global:ChatLog -ItemType File
    }
    
    $existingChat = Import-Csv -Path $Global:ChatLog
    foreach ($msg in $existingChat) 
    {
        $properties = @{
            'UserName' = $msg.User
            'Message' = $msg.Message
        }
        $Result = New-Object -TypeName psobject -Property $properties
        $Global:MemLog += $Result
    }

    Import-PBCommands
    
    $StopLoop = $false
    [int]$Retrycount = 0
     
    do 
    {
        try 
        {
            $Global:messageTextArea = $Global:phantomJsDriver.FindElementById('message-textarea')
            $Global:chatSendButton = $Global:phantomJsDriver.FindElementByClassName('submit')
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
}

function Out-Stream 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param (
        # Param1 help description
        [Parameter(Mandatory = $true,
                ValueFromPipeline = $true,
                ValueFromPipelineByPropertyName = $true,
        Position = 0)]
        [string[]] $Message
    )

    Begin {}

    Process {
        foreach ($output in $Message) 
        {
            $Global:messageTextArea.SendKeys($output)
            $Global:chatSendButton.Click()
        }
    }

    End {}
}

function Read-Stream 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param (
        [switch] $all
    )

    $chatMessages = $Global:phantomJsDriver.FindElementsByClassName('lctv-premium')

    $log = @()
    foreach ($chatMessage in $chatMessages) 
    {
        $parts = ($chatMessage.GetAttribute('innerHTML')).Split('>')
        $username = $parts[1].Replace('</a', '')

        $messageText = $parts[2]

        $properties = @{
            'UserName' = $username
            'Message' = $messageText
        }
        $Result = New-Object -TypeName psobject -Property $properties
        $log += $Result
    }

    if ($all) 
    {
        $log
    }
    else 
    {
        $difference = Compare-Object -ReferenceObject $Global:MemLog -DifferenceObject $log -Property 'UserName', 'Message' | Where-Object -Property sideindicator -EQ -Value '=>'
        foreach ($newMessage in $difference) 
        {
            Log-Chat -ChatMessage $newMessage
        }
        $Global:MemLog = @()

        $existingChat = Import-Csv -Path $Global:ChatLog
        foreach ($msg in $existingChat) 
        {
            $properties = @{
                'UserName' = $msg.User
                'Message' = $msg.Message
            }
            $Result = New-Object -TypeName psobject -Property $properties
            $Global:MemLog += $Result
        }
    }
}

function Log-Chat 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param (
        [psobject] $chatMessage
    )

    $Result = New-Object -TypeName PSCustomObject -Property @{
        'Time'  = Get-Date
        'User'  = $chatMessage.Username
        'Message' = $chatMessage.Message
    }

    $Result | Export-Csv -Path $Global:ChatLog -Append
}

function Get-StreamViewers 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $user = $null
    $users = $Global:phantomJsDriver.FindElementsByClassName('user')

    foreach ($user in $users) 
    {
        $user.GetAttribute('innerText').trimEnd('▾') #This may change with future lc.tv updates
    }
}

function Greet-StreamViewers 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $user = $null
    $users = Get-StreamViewers
    $testTime = (Get-Date).AddSeconds(-30)
    $regreetTime = (Get-Date).AddHours(-13)

    $Greetings = @('Welcome {0}!', 
        'Hey {0}', 
        'How''s it going, {0}?', 
        'Hey {0}, how''s it going?', 
        'Good to see you, {0}', 
        'Hi {0}', 
        'Howdy {0}'
    )

    foreach ($user in $users) 
    {
        Write-Verbose -Message $user
        if ($user -ne 'Windos' -and $user -ne 'PowerBot') 
        {
            $greeted = $false
        
            foreach ($viewer in $Global:viewersGreeted)
            {
                Write-Verbose -Message $viewer.Name
                if ($user -eq $viewer.Name) 
                {
                    if ($viewer.whenGreeted -ge $regreetTime)
                    {
                        Write-Verbose -Message 'Already greeted'
                        $greeted = $true
                    }
                }
                else 
                {
                    Write-Verbose -Message 'Not greeted'
                }
            }
        
            if (!$greeted) 
            {
                if ($Global:newViewers.ContainsKey($user)) 
                {
                    $userTime = $Global:newViewers.$user
                    if ($userTime -le $testTime) 
                    {
                        $rand = $null
                        $rand = Get-Random -Minimum 0 -Maximum ($Greetings.Length - 1)
                        Out-Stream -Message ($Greetings[$rand] -f $user)

                        $properties = @{
                            'Name'      = $user
                            'whenGreeted' = (Get-Date)
                        }
                        $Result = New-Object -TypeName psobject -Property $properties
                        $Global:viewersGreeted += $Result
                        $Global:viewersGreeted | Export-Csv -Path $Global:viewersGreetedCsv
                        $Global:newViewers.Remove($user)
                    }
                }
                else
                {
                    $Global:newViewers.Add($user,(Get-Date))
                }
            }
        }
    }

    foreach ($newViewer in $Global:newViewers) 
    {
        if ($newViewer.Keys -notin $users) 
        {
            $Global:newViewers.Remove($newViewer.Keys)
        }
    }
}

function Start-Raffle 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $userMessages = Read-Stream
    $uniqueUsers = ($userMessages | Group-Object -Property UserName).Name
    $uniqueUsers
}

function Send-PBHelp 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $userMessages = Read-Stream -all
    $outHelp = 'Available Commands: '
    $commands = $Global:PBCommands.GetEnumerator()
    foreach ($command in $commands) 
    {
        $outHelp += "$($command.Name), "
    }
    $outHelp = $outHelp.Trim().TrimEnd(',')
    $outHelp | Out-Stream
}

function Add-PBCommand 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $fullLog = Import-Csv -Path $Global:ChatLog
    $active = (Get-Date).AddSeconds(-15)

    $commandAdditions = $fullLog | Where-Object -FilterScript {
        $_.Message -like 'Add-PBCommand*' -and $_.User -eq 'Windos'
    }
    foreach ($commandEdit in $commandAdditions) 
    {
        if ((Get-Date -Date $commandEdit.Time) -gt $active)
        {
            $parts = $commandEdit.Message.Split('-')
            $key = ($parts[2].Substring(8)).Trim().Trim("'")

            $recentResponse = $false
            $commandResponses = $fullLog | Where-Object -FilterScript {
                $_.Message -like "Command '$key'*" -and $_.User -eq 'PowerBot'
            }
            foreach ($commandResponse in $commandResponses) 
            {
                $responseTime = Get-Date -Date $commandResponse.Time
                if ($responseTime -gt ($active.AddMinutes(-1))) 
                {
                    $recentResponse = $true
                }
            }
            if (!$recentResponse) 
            {
                if (!($Global:PBCommands.ContainsKey($key))) 
                {
                    $value = ($parts[3].Substring(8)).Trim().Trim("'")
                    $Global:PBCommands.Add($key, $value)
                    Export-PBCommands
                    Out-Stream -Message "Command '$key' has been added."
                } else {
                    Out-Stream -Message "Command '$key' already exists, consider editing it."
                }
            }
        }
    }
}

function Edit-PBCommand 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $fullLog = Import-Csv -Path $Global:ChatLog
    $active = (Get-Date).AddSeconds(-15)

    $commandEdits = $fullLog | Where-Object -FilterScript {
        $_.Message -like 'Edit-PBCommand*' -and $_.User -eq 'Windos'
    }
    foreach ($commandEdit in $commandEdits) 
    {
        if ((Get-Date -Date $commandEdit.Time) -gt $active)
        {
            $parts = $commandEdit.Message.Split('-')
            $key = ($parts[2].Substring(8)).Trim().Trim("'")

            $recentResponse = $false
            $commandResponses = $fullLog | Where-Object -FilterScript {
                $_.Message -like "Command '$key'*" -and $_.User -eq 'PowerBot'
            }
            foreach ($commandResponse in $commandResponses) 
            {
                $responseTime = Get-Date -Date $commandResponse.Time
                if ($responseTime -gt ($active.AddMinutes(-1))) 
                {
                    $recentResponse = $true
                }
            }
            if (!$recentResponse) 
            {
                if (($Global:PBCommands.ContainsKey($key))) 
                {
                    $oldMessage = $Global:PBCommands[$key]
                    $value = ($parts[3].Substring(8)).Trim().Trim("'")
                    $Global:PBCommands[$key] = $value
                    Export-PBCommands
                    Out-Stream -Message "Command '$key' has been changed from '$oldMessage' to '$value'"
                } else {
                    Out-Stream -Message "Command '$key' does not exist, consider adding it."
                }
            }
        }
    }
}

function Remove-PBCommand 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $fullLog = Import-Csv -Path $Global:ChatLog
    $active = (Get-Date).AddSeconds(-15)

    $commandEdits = $fullLog | Where-Object -FilterScript {
        $_.Message -like 'Remove-PBCommand*' -and $_.User -eq 'Windos'
    }
    foreach ($commandEdit in $commandEdits) 
    {
        if ((Get-Date -Date $commandEdit.Time) -gt $active)
        {
            $parts = $commandEdit.Message.Split('-')
            $key = ($parts[2].Substring(8)).Trim().Trim("'")

            $recentResponse = $false
            $commandResponses = $fullLog | Where-Object -FilterScript {
                $_.Message -like "Command '$key'*" -and $_.User -eq 'PowerBot'
            }
            foreach ($commandResponse in $commandResponses) 
            {
                $responseTime = Get-Date -Date $commandResponse.Time
                if ($responseTime -gt ($active.AddMinutes(-1))) 
                {
                    $recentResponse = $true
                }
            }
            if (!$recentResponse) 
            {
                if (($Global:PBCommands.ContainsKey($key))) 
                {
                    $Global:PBCommands.Remove($key)
                    Export-PBCommands
                    Out-Stream -Message "Command '$key' has been removed."
                } else {
                    Out-Stream -Message "Command '$key' does not exist."
                }
            }
        }
    }
}

function Check-PBCommand 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    [Alias()]
    Param ()

    $fullLog = Import-Csv -Path $Global:ChatLog
    $delay = (Get-Date).AddMinutes(-60)
    $helpDelay = (Get-Date).AddMinutes(-30)
    $active = (Get-Date).AddSeconds(-15)

    Import-PBCommands
    $cmds = $Global:PBCommands.GetEnumerator()

    $commandRequests = $fullLog | Where-Object -FilterScript {
        $_.Message -like '!*'
    }
    foreach ($commandRequest in $commandRequests) 
    {
        if ($commandRequest.Message -in $Global:PBCommands.Keys) 
        {
            if ((Get-Date -Date $commandRequest.Time) -gt $active) 
            {
                $recentResponse = $false
                if ($commandRequest.Message -eq '!help') 
                {
                    $commandResponses = $fullLog | Where-Object -FilterScript {
                        $_.Message -like 'Available Commands: *' -and $_.User -eq 'PowerBot'
                    }
                    foreach ($commandResponse in $commandResponses) 
                    {
                        $responseTime = Get-Date -Date $commandResponse.Time
                        if ($responseTime -gt $helpDelay) 
                        {
                            $recentResponse = $true
                        }
                    }
                    if (!$recentResponse) 
                    {
                        Send-PBHelp
                        Start-Sleep -Seconds 0.5
                    }
                }
                else 
                {
                    $commandOutput = $Global:PBCommands.($commandRequest.Message)
                    $testString = $commandOutput
                    if ($commandOutput -like '*twitter*') 
                    {
                        $testString = $testString.Replace(' https://twitter.com/WindosNZ','')
                    }
                    $commandResponses = $fullLog | Where-Object -FilterScript {
                        $_.Message -like "$testString*" -and $_.User -eq 'PowerBot'
                    }

                    foreach ($commandResponse in $commandResponses) 
                    {
                        $responseTime = Get-Date -Date $commandResponse.Time
                        if ($responseTime -gt $delay) 
                        {
                            $recentResponse = $true
                        }
                    }
                    if (!$recentResponse) 
                    {
                        Out-Stream -Message $commandOutput
                        Start-Sleep -Seconds 0.5
                    }
                }
            }
        }
    }
}

function Start-PBLoop 
{
    $null = Start-Job -Name 'Greeter' -ScriptBlock {
        try 
        {
            Initialize-PowerBot
            Out-Stream -Message 'PowerBot: Greeter Online'
            While ($true) 
            {
                Greet-StreamViewers
                Read-Stream
                Add-PBCommand
                Edit-PBCommand
                Remove-PBCommand
                Check-PBCommand
                Start-Sleep -Seconds 1
            }
        }
        catch 
        {

        }
        finally 
        {
            $driver.Quit()
        }
    }

    # $null = Start-Job -Name 'CommandTimout' -ScriptBlock {
    #     try 
    #     {
    #         Initialize-PowerBot
    #         Out-Stream -Message 'PowerBot: CommandTimout Online'
    #         While ($true) 
    #         {
    #             $fullLog = Import-Csv -Path $Global:ChatLog
    #             $delay = (Get-Date).AddMinutes(-60)
    #         
    #             $commandOutput = $Global:PBCommands.'!twitter'
    #             $testString = $commandOutput.Replace(' https://twitter.com/WindosNZ','')
    #         
    #             $commandResponses = $fullLog | Where-Object -FilterScript {
    #                 $_.Message -like "$testString*" -and $_.User -eq 'PowerBot'
    #             }
    #         
    #             foreach ($commandResponse in $commandResponses) 
    #             {
    #                 $responseTime = Get-Date -Date $commandResponse.Time
    #                 if ($responseTime -gt $delay) 
    #                 {
    #                     $timeToGo = [math]::Round((New-TimeSpan -Start $delay -End $responseTime).TotalMinutes)
    #         
    #                     $objProperties = @{
    #                         'auth_token' = 'YOUR_AUTH_TOKEN'
    #                         'value'    = $timeToGo
    #                     }
    #                     $obj = New-Object -TypeName PSCustomObject -Property $objProperties
    #             
    #                     Push-DashingJson -Object $obj -Widget 'twitterTimeOut'
    #                 }
    #             }
    #             Start-Sleep -Seconds 50
    #         }
    #     }
    #     catch 
    #     {
    # 
    #     }
    #     finally 
    #     {
    #         $driver.Quit()
    #     }
    # }
    # 
    # $null = Start-Job -Name 'LiveViewers' -ScriptBlock {
    #     try 
    #     {
    #         Initialize-PowerBot
    #         Out-Stream -Message 'PowerBot: LiveViewers Online'
    #         $start = Get-Date
    #     
    #         $data = @()
    #     
    #         while ($true) 
    #         {
    #             $now = Get-Date
    #             $secondsPassed = (New-TimeSpan -Start $start -End $now).TotalSeconds
    #             $x = $secondsPassed
    #             $y = (Get-StreamViewers |
    #                 Where-Object -FilterScript {
    #                     $_ -ne 'Windos' -and $_ -ne 'PowerBot'
    #                 } |
    #             Measure-Object).Count
    #         
    #             $data += @{
    #                 'x' = $x
    #                 'y' = $y
    #             }
    #         
    #             $displayData = @()
    #             if ($data.Length -gt 240) 
    #             {
    #                 $displayData = $data[-240..-1]
    #             }
    #             else 
    #             {
    #                 $displayData = $data
    #             }
    #     
    #             $objProperties = @{
    #                 'auth_token' = 'YOUR_AUTH_TOKEN'
    #                 'points'   = $displayData
    #             }
    #             $obj = New-Object -TypeName PSCustomObject -Property $objProperties
    #         
    #             Push-DashingJson -Object $obj -Widget 'liveviewers'
    #         
    #             Start-Sleep -Seconds 15
    #         }
    #     }
    #     catch 
    #     {
    # 
    #     }
    #     finally 
    #     {
    #         $driver.Quit()
    #     }
    # }
}
