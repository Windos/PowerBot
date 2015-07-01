#requires -Version 2 -Modules PowerBot
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

    if ($CmdRelevant)
    {
        [array]::Reverse($CmdRelevant)

        $CmdIndex = 0
        $CmdFound = $false

        $ExistingCommands = @()
        foreach ($existingCommand in $Global:PBCommands)
        {
            $ExistingCommands += $existingCommand.Command
        }

        While (!$CmdFound -and $CmdIndex -ne ($CmdRelevant | Measure-Object).Count)
        {
            $RawCommand = ($CmdRelevant[$CmdIndex].Message.Split(' '))[0]
            if ($RawCommand -in $ExistingCommands)
            {
                $CmdFound = $true
            }
            else
            {
                $CmdIndex++
            }
        }

        if ($CmdFound)
        {
            $CommandObject = $Global:PBCommands | Where-Object -FilterScript {
                $_.Command -eq $RawCommand
            }
            if  ($CommandObject.Admin -eq $false -or ($CommandObject.Admin -and $CmdRelevant[$CmdIndex].Name -eq 'Windos'))
            {
                $ResponseIndex = $CmdIndex

                if ($CmdRelevant[$CmdIndex].Message -eq '!help')
                {
                    if ($CmdRelevant[$CmdIndex].Name -eq 'Windos')
                    {
                        $CmdOutput = Send-PBHelp -ReturnOnly -Admin
                        $TestOutput = ($CmdOutput[0].Split(':'))[0]
                    }
                    else
                    {
                        $CmdOutput = Send-PBHelp -ReturnOnly
                        $TestOutput = ($CmdOutput.Split(':'))[0]
                    }
                }
                elseif ($CmdRelevant[$CmdIndex].Message -like '!add*')
                {
                    if ($CmdRelevant[$CmdIndex].Name -eq 'Windos')
                    {
                        $TestOutput = 'Added '
                    }
                }
                else
                {
                    $CmdOutput = $CommandObject.Message
                    $TestOutput = $CmdOutput

                    if ($CmdRelevant[$CmdIndex].Message -eq '!twitter')
                    {
                        $TestOutput = ($CmdOutput.Split(':'))[0]
                    }
                }

                $ResponseFound = $false

                Do
                {
                    if ($CmdRelevant[$ResponseIndex].Message -like "$TestOutput*")
                    {
                        $ResponseFound = $true
                    }
                    else
                    {
                        $ResponseIndex--
                    }
                }
                While (!$ResponseFound -and $ResponseIndex -ge 0)

                if (!$ResponseFound)
                {
                    if ($CmdRelevant[$CmdIndex].Message -like '!add*')
                    {
                        Add-PBCommand -InputMessage $CmdRelevant[$CmdIndex].Message
                    }
                    else
                    {
                        $CmdOutput | Out-Stream
                    }
                }
            }
        }
    }
}
