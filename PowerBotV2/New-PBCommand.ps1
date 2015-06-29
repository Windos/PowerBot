#requires -Version 2
function New-PBCommand 
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
        # Param1 help description
        [Parameter(Mandatory = $true,
            Position = 0)]
        [string] $Command,
        
        # Param2 help description
        [Parameter(Mandatory = $false,
            Position = 1)]
        [string] $Message,
        
        # Param3 help description
        [Parameter(Mandatory = $false)]
        [switch] $Admin
    )

    if ($Command -notlike '!*')
    {
        $Command = "!$Command"
    }

    $existingCommands = @()
    foreach ($existingCommand in $Global:PBCommands)
    {
        $existingCommands += $existingCommand.Command
    }

    if ($Command -notin $existingCommands)
    {
        $Properties = @{
            'Command' = $Command
            'Message' = $Message
            'Admin' = $Admin
        }

        $Result = New-Object -TypeName PSCustomObject -Property $Properties
        $Global:PBCommands += $Result
    }
}
