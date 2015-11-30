class Viewer
{
    [string] $Username
    [int] $Points
    [datetime[]] $Greeted
    
    Viewer ([string] $Username)
    {
        $this.Username = $Username
    }

    [void] Greet ()
    {
        $this.Greeted += Get-Date
        Write-ViewerGreeting -User $this.Username
    }

    [void] AddGreetTime ([string] $DateTime)
    {
        $this.Greeted += Get-Date $DateTime
    }
}
