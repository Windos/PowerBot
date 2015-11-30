class BotCommand
{
    [string] $Name
    [string] $Command
    [string] $Keyword
    [int] $Cost
    [string[]] $Group
    [string] $Message
    [bool] $Default
    
    BotCommand ([string] $Name)
    {
        $this.Name = $Name
    }

    [void] SetCommand ([string] $Command)
    {
        $this.Command = $Command
    }

    [void] SetKeyword ([string] $Keyword)
    {
        $this.Keyword = $Keyword
    }

    [void] SetMessage ([string] $Message)
    {
        $this.Message = $Message
    }

    [void] SetCost ([int] $Cost)
    {
        $this.Cost = $Cost
    }
    
    [void] SetDefault ()
    {
        $this.Default = $true
    }

    [void] AddGroup ([string[]] $Group)
    {
        $this.Group += $Group
    }

    [void] RemoveGroup ([string[]] $Group)
    {
        $this.Group.Remove($Group)
    }
}
