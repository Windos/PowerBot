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
        [switch] $ReturnOnly
    )

    $Output = 'Available Commands: '

    foreach ($Command in $Global:PBCommands) 
    {
        $Output += "$($Command.Command), "
    }
    $Output = $Output.Trim().TrimEnd(',')
    
    if ($ReturnOnly)
    {
        $Output
    }
    else
    {
        $Output | Out-Stream
    }
}