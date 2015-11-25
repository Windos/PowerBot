function Get-StreamViewers
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

    $User = $null
    $Users = $Global:PhantomJsDriver.FindElementsByClassName('user')

    foreach ($User in $Users)
    {
        $User.GetAttribute('innerText').trimEnd('▾')
    }
}
