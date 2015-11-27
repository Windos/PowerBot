function Export-Viewer
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

    $Script:Viewers | Export-Clixml -Path $Script:PersistentPath\viewers.xml
}
