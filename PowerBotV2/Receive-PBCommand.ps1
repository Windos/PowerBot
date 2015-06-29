function Receive-PBCommand 
{
    <#
            .Synopsis
            Short description
            .DESCRIPTION
            Long description
            .EXAMPLE
            Example of how to use this cmdlet
            .EXAMPLE
            Another example of how to use this cmdlet
    #>
    [CmdletBinding()]
    Param ()

    $FullLog = Read-Stream

    $CmdRelevant = $FullLog | Where-Object -FilterScript {
        $_.Message -like '!*' -or $_.Name -eq 'PowerBot'
    }

    [array]::Reverse($CmdRelevant)

    $CmdIndex = 0
    $CmdFound = $false

    $ExistingCommands = @()
    foreach ($existingCommand in $Global:PBCommands)
    {
        $ExistingCommands += $existingCommand.Command
    }

    Do
    {
        if ($CmdRelevant[$CmdIndex].Message -in $ExistingCommands) 
        {
            $CmdFound = $true
        }
        else
        {
            $CmdIndex++
        }
    } While (!$CmdFound -and $CmdIndex -ne ($CmdRelevant | Measure-Object).Count)

    if ($CmdFound)
    {
        $ResponseIndex = $CmdIndex

        if ($CmdRelevant[$CmdIndex].Message -eq '!help')
        {
            $CmdOutput = Send-PBHelp -ReturnOnly
        }
        else
        {
            $Output = $Global:PBCommands | Where-Object -FilterScript {
                $_.Command -eq $($CmdRelevant[$CmdIndex].Message)
            }
            $CmdOutput = $Output.Message
        }

        $ResponseFound = $false

        Do
        {
            if ($CmdRelevant[$ResponseIndex].Message -eq $CmdOutput)
            {
                $ResponseFound = $true
            }
            else
            {
                $ResponseIndex--
            }
        }
        While (!$ResponseFound -and $ResponseIndex -ge 0)
    }

    if (!$ResponseFound)
    {
        $CmdOutput | Out-Stream
    }
}
