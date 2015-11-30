class BotCommand
{
    [string] $Command
    [string] $DisplayName
    [string] $Keyword
    [int] $Cost
    [string[]] $Group
    [string] $Message
    
    BotCommand ([string] $Command)
    {
        $this.Command = $Command
    }

    BotCommand ([string] $Command, [string] $DisplayName)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
    }

    BotCommand ([string] $Command, [string] $Keyword)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
    }

    BotCommand ([string] $Command, [int] $Cost)
    {
        $this.Command = $Command
        $this.Cost = $Cost
    }

    BotCommand ([string] $Command, [string] $DisplayName, [int] $Cost)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Cost = $Cost
    }

    BotCommand ([string] $Command, [string] $Keyword, [int] $Cost)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword, [int] $Cost)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
        $this.Cost = $Cost
    }

    BotCommand ([string] $Command, [string[]] $Group)
    {
        $this.Command = $Command
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string[]] $Group)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [string] $Keyword, [string[]] $Group)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword, [string[]] $Group)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [int] $Cost, [string[]] $Group)
    {
        $this.Command = $Command
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [string] $DisplayName, [int] $Cost, [string[]] $Group)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [string] $Keyword, [int] $Cost, [string[]] $Group)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword, [int] $Cost, [string[]] $Group)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
    }

    BotCommand ([string] $Command, [string] $Message)
    {
        $this.Command = $Command
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $Keyword, [string] $Message)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [int] $Cost, [string] $Message)
    {
        $this.Command = $Command
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [int] $Cost, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $Keyword, [int] $Cost, [string] $Message)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword, [int] $Cost, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $Keyword, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $Keyword, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }

    BotCommand ([string] $Command, [string] $DisplayName, [string] $Keyword, [int] $Cost, [string[]] $Group, [string] $Message)
    {
        $this.Command = $Command
        $this.DisplayName = $DisplayName
        $this.Keyword = $Keyword
        $this.Cost = $Cost
        $this.Group = $Group
        $this.Message = $Message
    }
}
