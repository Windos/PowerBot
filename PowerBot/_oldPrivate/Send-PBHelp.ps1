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
    Param (
        [switch] $ReturnOnly,
        [switch] $Admin
    )

    $Output = @()

    $AvailableCommands = 'Commands: '

    foreach ($Command in ( $Global:PBCommands | Where-Object -FilterScript {
                $_.Admin -eq $false
    } ))
    {
        $AvailableCommands += "$($Command.Command), "
    }
    $Output += $AvailableCommands.Trim().TrimEnd(',')

    if ($Admin)
    {
        $AvailableAdminCommands = 'Admin Commands: '

        foreach ($Command in ( $Global:PBCommands | Where-Object -FilterScript {
                    $_.Admin -eq $true
        } ))
        {
            $AvailableAdminCommands += "$($Command.Command), "
        }

        $Output += $AvailableAdminCommands.Trim().TrimEnd(',')
    }

    if ($ReturnOnly)
    {
        $Output
    }
    else
    {
        $Output | Out-Stream
    }
}
