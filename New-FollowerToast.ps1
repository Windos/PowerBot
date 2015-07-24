function New-FollowerToast
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
    Param (
        [string] $RSS = 'https://www.livecoding.tv/rss/windos/followers/?key=6nl6ahQmRmQRjBkq',
        [string] $SavePath = ( Join-Path -Path (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path) -ChildPath '\PersistentData\followers.txt' )
    )

}

while ($true)
{
    $XML = New-Object XML
    $XML.Load($RSS)
    $Followers = $XML.rss.channel.ChildNodes | Select-Object title | Where-Object {$_.title -ne $null}
    
    $Current = @()
    foreach ($Follower in $Followers)
    {
        $Current += $Follower.title
    } 
    
    
    if (Test-Path -Path $SavePath) 
    {
        $Loaded = Get-Content -Path $SavePath
    }
    else
    {
        $Loaded = @()
    }
    
    $NewFollowers = (Compare-Object $current $loaded | Where-Object {$_.SideIndicator -eq '<='}).InputObject
    
    foreach ($NewFollower in $NewFollowers)
    {
        New-BurntToastNotification -FirstLine 'New Follower!' -SecondLine "$NewFollower just followed!" -Sound Reminder
        $NewFollower | Out-File -FilePath $SavePath -Append
    }
}
