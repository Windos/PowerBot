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
    
    $Object = $Collection.GetEnumerator() | ForEach-Object -Process {
        New-Object -TypeName PSObject -Property @{
            'Command' = $_.Name
            'Message' = $_.Value
        }
    }
    
    $Object | Export-Csv $Path -NoTypeInformation
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
    Param (
        # Parameter help
        [Parameter(Mandatory = $false,
        Position = 0)]
        [string] $Path = $Global:CommandsCsv
    )
    
    $Global:PBCommands = @{}
    $Object = Import-Csv $Path | ForEach-Object -Process {
        $Global:PBCommands.Add($_.Command, $_.Message)
    }
}

function Initialize-PowerBot 
{
    Param (
        [string] $powerBotPath = (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path)
    )

    
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
                } else 
                {
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
