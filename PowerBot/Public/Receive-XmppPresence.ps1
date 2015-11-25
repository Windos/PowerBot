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

    if ($Presence.Type -eq 'available')
    {
        $client.Send((New-Object -TypeName agsXMPP.protocol.client.Message -ArgumentList ($room, [agsXMPP.protocol.client.MessageType]::groupchat, "Hi, $($Presence.from.User)")))
    }
    elseif ($Presence.Type -eq 'unavailable')
    {
        $client.Send((New-Object -TypeName agsXMPP.protocol.client.Message -ArgumentList ($room, [agsXMPP.protocol.client.MessageType]::groupchat, "Bye, $($Presence.from.User)")))
    }
}
