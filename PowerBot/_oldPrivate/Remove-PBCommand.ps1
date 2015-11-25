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
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true,
        Position = 0)]
        [string] $InputMessage
    )

    $Command = ''

    $InputParts = $InputMessage.Split('-')

    foreach ($Part in $InputParts)
    {
        if ($Part -like 'Command*')
        {
            $Command = ($Part.Substring(8)).Trim().Trim("'")
            if ($Command -notlike '!*')
            {
                $Command = "!$Command"
            }
        }
    }

    $CmdIndex = 0
    $CmdFound = $false

    While (!$CmdFound -and $CmdIndex -ne ($Global:PBCommands | Measure-Object).Count)
    {
        if ($Command -eq $Global:PBCommands[$CmdIndex].Command)
        {
            $CmdFound = $true
            
            $UpdatedPBCommands = @()
            
            foreach ($ExistingCommand in $Global:PBCommands)
            {
                if ($ExistingCommand.Command -ne $Command)
                {
                    $UpdatedPBCommands += $ExistingCommand
                }
            }

            $Global:PBCommands = $UpdatedPBCommands

            $PersistentPath = Join-Path -Path (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path) -ChildPath '\PersistentData\'
            $Global:PBCommands | Export-Csv -Path (Join-Path -Path $PersistentPath -ChildPath 'commands.csv')

            Out-Stream -Message "Removed $Command"
        }
        else
        {
            $CmdIndex++
        }
    }

    if (!$CmdFound)
    {
        Out-Stream -Message "Couldn't remove $Command, it doesn't exist."
    }
}
