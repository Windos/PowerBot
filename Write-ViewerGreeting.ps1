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

    $Users = Get-StreamViewers
    $TestTime = (Get-Date).AddSeconds(-20)
    $RegreetTime = (Get-Date).AddHours(-12)

    $Greetings = @('Welcome {0}!',
        'Hey {0}',
        'How''s it going, {0}?',
        'Hey {0}, how''s it going?',
        'Good to see you, {0}',
        'Hi {0}',
        'Howdy {0}'
    )

    foreach ($User in $Users)
    {
        if ($User -ne 'Windos' -and $User -ne 'PowerBot')
        {
            $Greeted = $false

            foreach ($Viewer in $Global:viewersGreeted)
            {
                if ($User -eq $Viewer.Name)
                {
                    if ($Viewer.LastGreeted -ge $RegreetTime)
                    {
                        $Greeted = $true
                    }
                }
            }

            if (!$Greeted)
            {
                if ($Global:NewViewers.ContainsKey($User))
                {
                    $UserTime = $Global:NewViewers.$User
                    if ($UserTime -le $TestTime)
                    {
                        $Rand = $null
                        $Rand = Get-Random -Minimum 0 -Maximum ($Greetings.Length - 1)
                        Out-Stream -Message ($Greetings[$Rand] -f $User)

                        $Properties = @{
                            'Name'      = $User
                            'LastGreeted' = (Get-Date)
                        }
                        $Result = New-Object -TypeName PSCustomObject -Property $Properties
                        $Global:viewersGreeted += $Result
                        $Global:NewViewers.Remove($User)

                        $PersistentPath = Join-Path -Path (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path) -ChildPath '\PersistentData\'
                        $Global:viewersGreeted | Export-Csv -Path (Join-Path -Path $PersistentPath -ChildPath 'viewersGreeted.csv')
                    }
                }
                else
                {
                    $Global:NewViewers.Add($User,(Get-Date))
                }
            }
        }
    }

    foreach ($NewViewer in $Global:NewViewers)
    {
        if ($NewViewer.Keys -notin $Users)
        {
            $Global:NewViewers.Remove($NewViewer.Keys)
        }
    }
}
