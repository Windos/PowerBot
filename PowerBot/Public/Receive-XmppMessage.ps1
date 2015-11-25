function Receive-XmppMessage
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
        [agsXMPP.protocol.client.Message] $Message
    )

    "New jabber message from $($Message.From.ToString()): $($Message.Body)" | Out-File -FilePath (Join-Path -Path $Script:PersistentPath -ChildPath out.txt) -Append

    $Message | Export-Csv -Path (Join-Path -Path $Script:PersistentPath -ChildPath chat.csv) -Append
}
