while ($true)
{
    Write-ViewerGreeting
    Receive-PBCommand
    Start-Sleep -Seconds 2
}