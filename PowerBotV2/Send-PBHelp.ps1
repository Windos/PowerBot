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
    $Commands = $Global:PBCommands.GetEnumerator()


    foreach ($Command in $Commands) 
    {
        $Output += "$($Command.Name), "
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