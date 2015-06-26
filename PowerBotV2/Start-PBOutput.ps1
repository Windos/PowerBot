#requires -Version 2
function Start-PBOutput
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
    
    if ($Global:isMuted)
    {
        $Global:isMuted = $false
        Write-Verbose -Message 'PowerBot has been unmuted'
    }
    else
    {
        Write-Verbose -Message 'PowerBot was not already muted'
    }
}
