function Read-Stream 
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
    Param ()

    $ChatMessages = $Global:PhantomJsDriver.FindElementsByClassName('lctv-premium')

    $Log = @()
    foreach ($ChatMessage in $ChatMessages) 
    {
        $Parts = ($ChatMessage.GetAttribute('innerHTML')).Split('>')
        $Name = $Parts[1].Replace('</a', '')

        $Message = $Parts[2]

        $Properties = @{
            'Name' = $Name
            'Message' = $Message
        }
        $Result = New-Object -TypeName PSCustomObject -Property $Properties
        $Log += $Result
    }

    $Log
}