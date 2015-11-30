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
}
