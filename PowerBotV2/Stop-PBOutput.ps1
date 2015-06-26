#requires -Version 2
function Stop-PBOutput
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
    
    if (!$Global:isMuted)
    {
        $Global:isMuted = $true
        Write-Verbose -Message 'PowerBot has been muted'
    }
    else
    {
        Write-Verbose -Message 'PowerBot was already muted'
    }
}
