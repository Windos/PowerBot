#requires -Version 5

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
    Param ()

    $userMessages = Read-Stream
    $uniqueUsers = ($userMessages | Group-Object -Property UserName).Name
    $uniqueUsers
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
                } else 
                {
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
                    Out-Stream -Message "Command '$key' has been removed."
                    Export-PBCommands
                } else 
                {
                    Out-Stream -Message "Command '$key' does not exist."
                }
            }
        }
    }
}

function Get-RemainingLockoutTime
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
    Param (
        # Parameter help
        [Parameter(Mandatory = $true,
        Position = 0)]
        [string] $command
    )
    
    if ($command -like '!*') 
    {
        $command = $command.Replace('!', '')
    }

    if ($command -ne 'help' -and $Global:PBCommands.ContainsKey("!$command"))
    {
        $timeToGo = 0
        $fullLog = Import-Csv -Path $Global:ChatLog
        $delay = (Get-Date).AddMinutes(-30)
        
        $commandOutput = $Global:PBCommands."!$command"
        $testString = $commandOutput.Replace(' https://twitter.com/WindosNZ','')
        
        $commandResponses = $fullLog | Where-Object -FilterScript {
            $_.Message -like "$testString*" -and $_.User -eq 'PowerBot'
        }
        
        foreach ($commandResponse in $commandResponses) 
        {
            $responseTime = Get-Date -Date $commandResponse.Time
            if ($responseTime -gt $delay) 
            {
                $timeToGo = [math]::Round((New-TimeSpan -Start $delay -End $responseTime).TotalMinutes)
            }
        }
        $timeToGo
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
                # Add-PBCommand
                # Edit-PBCommand
                # Remove-PBCommand
                Check-PBCommand
                Start-Sleep -Seconds 1
            }
        }
        catch 
        {

        }
        finally 
        {
            $Global:PhantomJsDriver.Quit()
        }
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