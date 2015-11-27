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
                $Viewer = $Script:Viewers | Where-Object -FilterScript {$_.Username -eq $User}

                if ($Viewer.Greeted[-1].AddSeconds(20) -gt (Get-Date))
                {
                    Out-Stream -Message "$User, you're too quick!"
                }
                else
                {
                    Out-Stream -Message "I know you, $User!"
                    $Viewer.Greet()
                }
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
