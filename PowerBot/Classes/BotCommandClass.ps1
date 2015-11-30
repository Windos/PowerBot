class BotCommand
{
    [string] $Name
    [string] $Command
    [string] $Keyword
    [int] $Cost
    [string[]] $Group
    [string] $Message
    
    BotCommand ([string] $Name)
    {
        $this.Name = $Name
    }

    BotCommand ([string] $Name, [string] $Command)
    {
        $this.Name = $Name
        $this.Command = $Command
    }

    BotCommand ([string] $Name, [string] $Keyword)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
    }

    BotCommand ([string] $Name, [int] $Cost)
    {
        $this.Name = $Name
        $this.Cost = $Cost
    }

    BotCommand ([string] $Name, [string] $Command, [int] $Cost)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Cost = $Cost
    }

    BotCommand ([string] $Name, [string] $Keyword, [int] $Cost)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
        $this.Cost = $Cost
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword, [int] $Cost)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
    }

    BotCommand ([string] $Name, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [string] $Command, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [string] $Keyword, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [int] $Cost, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [string] $Command, [int] $Cost, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [string] $Keyword, [int] $Cost, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword, [int] $Cost, [string[]] $Group)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Name, [string] $Message)
    {
        $this.Name = $Name
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Keyword, [string] $Message)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [int] $Cost, [string] $Message)
    {
        $this.Name = $Name
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [int] $Cost, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Keyword, [int] $Cost, [string] $Message)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword, [int] $Cost, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Keyword, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Keyword, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Name, [string] $Command, [string] $Keyword, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Name = $Name
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }
}
