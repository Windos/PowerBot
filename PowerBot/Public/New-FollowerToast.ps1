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
        [string] $SavePath = ( Join-Path -Path $Script:PersistentPath -ChildPath '\followers.txt' )
    )

    $RssUri = "https://www.livecoding.tv/rss/$($Script:Streamer)/followers/?key=$($Script:RssKey)"

    $Followers = Invoke-RestMethod -Uri $RssUri
    
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
        New-BurntToastNotification -FirstLine 'New Follower!' -SecondLine "Thanks for the follow, $NewFollower!" -Sound Reminder
        $NewFollower | Out-File -FilePath $SavePath -Append
        Start-Sleep -Milliseconds 500
    }
}
