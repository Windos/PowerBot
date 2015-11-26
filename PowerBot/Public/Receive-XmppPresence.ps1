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
        $JobName = "Greet-$($Presence.from.User)"
        $RelevantJob = Get-Job -Name $JobName -ErrorAction SilentlyContinue
    
        if ($Presence.Type -eq 'available')
        {
            if ($RelevantJob -eq $null)
            {
                Start-Job -Name $JobName -ScriptBlock {
                    Start-Sleep -Seconds 60
                }
            }
        }
        elseif ($Presence.Type -eq 'unavailable')
        {
            foreach ($Job in $RelevantJob) 
            {
                if ($Job.State -ne 'Completed')
                {
                    $RelevantJob | Stop-Job
                    Start-Sleep -Seconds 1
                    $RelevantJob | Remove-Job    
                }
            }
        }
    }
}
