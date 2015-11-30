function New-BotCommand
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
                   Position = 0)]
        [string] $Name,
        
        [string] $Command,
        
        [string] $Keyword,
        
        [int] $Cost,
        
        [string[]] $Group,
        
        [string] $Message,
        
        [switch] $Default
    )
    
    $cmd = [BotCommand]::new($Name)
}
