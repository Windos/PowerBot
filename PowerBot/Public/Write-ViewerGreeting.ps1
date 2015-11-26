function Write-ViewerGreeting
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

    #TODO: Regreet?

    $Greetings = @('Welcome {0}!',
        'Hey {0}',
        'How''s it going, {0}?',
        'Hey {0}, how''s it going?',
        'Good to see you, {0}',
        'Hi {0}',
        'Howdy {0}'
    )

    $Rand = $null
    $Rand = Get-Random -Minimum 0 -Maximum ($Greetings.Length - 1)
    Out-Stream -Message ($Greetings[$Rand] -f $User)
}
