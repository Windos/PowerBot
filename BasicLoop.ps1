$Counter = 10
while ($true)
{
    Write-ViewerGreeting
    Receive-PBCommand

    switch ($Counter)
    {
        0 { New-FollowerToast; $Counter++ }
        15 { $Counter = 0 }
        default { $Counter++ }
    }

    Start-Sleep -Seconds 2
}
