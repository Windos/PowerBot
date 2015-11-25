function Initialize-PowerBot
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

    if ($Script:Config.Password -like '*-BEGIN CMS-*')
    {
        $Pass = $Script:Config.Password | Unprotect-CmsMessage
    }
    else
    {
        $Pass = $Script:Config.Password
    }
    
    #region Script Variables
    $Script:isMuted = $false
    $Script:ViewersGreeted = @()
    $Script:NewViewers = @{}
    $Script:PBCommands = @()
    $Script:PersistentPath = Join-Path -Path (Split-Path -Path (Get-Module -Name 'PowerBot' -ListAvailable).Path) -ChildPath '\PersistentData\'
    #endregion

    #region XMPP
    $UserJid = New-Object -TypeName agsXMPP.Jid -ArgumentList "$($Script:Config.Username)@$($Script:Config.Server)"
    $RoomJid = New-Object -TypeName agsXMPP.Jid -ArgumentList "$($Script:Config.Streamer)@$($Script:Config.ChatServer)"
    
    $Script:Room = New-Object -TypeName agsXMPP.Jid -ArgumentList $RoomJid
    $Script:Client =  New-Object -TypeName agsXMPP.XmppClientConnection  -ArgumentList $Script:Config.Server
    $Script:Client.Open($UserJid.User, $Pass)
    
    while (!$Script:Client.Authenticated) {
        Write-Verbose -Message $Script:Client.XmppConnectionState
        Start-Sleep -Seconds 1
    }

    $Script:Client.SendMyPresence()

    $Script:MucManager = New-Object -TypeName agsXMPP.protocol.x.muc.MucManager -ArgumentList $Script:Client
    $Script:MucManager.AcceptDefaultConfiguration($Script:Room);
    $Script:MucManager.JoinRoom($Script:Room, $Script:Config.Username);
    
    Write-Verbose -Message 'Logged in'

    Out-Stream -Message 'PowerBot: Online'
    Out-Stream -Message 'Use !help to see what I can do.'

    Register-ObjectEvent -InputObject $Script:Client -EventName OnMessage -Action {Save-XmppMessage -Message $args[1]}
    #endregion

    #region LoadPersistentData
    if (Test-Path -Path (Join-Path -Path $Script:PersistentPath -ChildPath 'commands.csv'))
    {
        $Script:PBCommands = Import-Csv -Path (Join-Path -Path $Script:PersistentPath -ChildPath 'commands.csv')
    }
    else
    {
        New-PBCommand -Command '!help' -Message ''
        New-PBCommand -Command '!add' -Message '' -Admin
        New-PBCommand -Command '!edit' -Message '' -Admin
        New-PBCommand -Command '!remove' -Message '' -Admin
    }

    if (Test-Path -Path (Join-Path -Path $Script:PersistentPath -ChildPath 'viewersGreeted.csv'))
    {
        $Script:ViewersGreeted = Import-Csv -Path (Join-Path -Path $Script:PersistentPath -ChildPath 'viewersGreeted.csv')
    }
    else
    {
        $Properties = @{
            'Name' = $Script:Config.Username
            'LastGreeted' = (Get-Date)
        }
        New-Object -TypeName PSCustomObject -Property $Properties | Export-Csv -Path (Join-Path -Path $Script:PersistentPath -ChildPath 'viewersGreeted.csv')
    }
    #endregion
}
