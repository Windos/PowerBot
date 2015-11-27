function Receive-XmppPresence
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
        [Parameter(Mandatory = $true)]
        [agsXMPP.protocol.client.Presence] $Presence
    )

    if ($Presence.From.User -ne 'PowerBot' -and $Presence.From.Resource -notlike '*powerbot*')
    {    
        if ($Presence.Type -eq 'available')
        {
            Write-ViewerGreeting -User $Presence.from.User
        }
        elseif ($Presence.Type -eq 'unavailable')
        {
        }
    }
}
