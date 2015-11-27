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

    $User = $Presence.From.User

    if ($User -ne 'PowerBot' -and $Presence.From.Resource -notlike '*powerbot*')
    {    
        if ($Presence.Type -eq 'available')
        {
            if ($User -in $Script:Viewers.Username)
            {
                Out-Stream -Message "I know you, $User!"
            }
            else
            {
                $NewViewer = [Viewer]::new($User)
                $NewViewer.Greet()
                $Script:Viewers += $NewViewer
            }
        }
        elseif ($Presence.Type -eq 'unavailable')
        {
        }
    }
}
