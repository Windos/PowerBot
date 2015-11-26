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
    Param (
        [switch] $Silent
    )

    if ($Script:Config.Password -like '*-BEGIN CMS-*')
    {
        $Pass = $Script:Config.Password | Unprotect-CmsMessage
    }
    else
    {
        $Pass = $Script:Config.Password
    }
    
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
    $Script:MucManager.JoinRoom($Script:Room, $Script:Config.Username, $true);
    
    Write-Verbose -Message 'Logged in'

    if (!$Silent)
    {
        Out-Stream -Message 'PowerBot: Online'
        Out-Stream -Message 'Use !help to see what I can do.'
    }

    $Script:ConnectionTime = Get-Date

    Register-ObjectEvent -InputObject $Script:Client -EventName OnMessage -Action {Receive-XmppMessage -Message $args[1]}
    Register-ObjectEvent -InputObject $Script:Client -EventName OnPresence -Action {Receive-XmppPresence -Presence $args[1]}
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
