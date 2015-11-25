function Out-Stream
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
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 0)]
        [string[]] $Message
    )

    Begin {}

    Process
    {
        foreach ($Output in $Message)
        {
            $XmppMessage = New-Object -TypeName agsXMPP.protocol.client.Message -ArgumentList ($Script:Room, [agsXMPP.protocol.client.MessageType]::groupchat, $Output)
            
            if (!$Script:isMuted)
            {
                $Script:Client.Send($XmppMessage)
            }
        }
    }

    End {}
}
