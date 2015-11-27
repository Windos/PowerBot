function Stop-PowerBot
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Initialize-PowerBot
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Initialize-PowerBot
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    Param ()

    $Script:mucManager.LeaveRoom($Script:Room, $Script:Config.Username)
    $Script:Client.Close()
}
