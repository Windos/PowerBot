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
        $_.Message -like '!*' -and $_.Name -ne 'PowerBot'
    } | Sort-Object -Property 'Timestamp' -Descending

    $CmdResponses = $FullLog | Where-Object -FilterScript {
        $_.Name -eq 'PowerBot'
    } | Sort-Object -Property 'Timestamp' -Descending
    
    if (!$CmdResponses)
    {
        $Properties = @{
            'Timestamp' = Get-Date -Hour '00' -Minute '01'
            'Name'  = 'PowerBot'
            'Message' = ''
        }
        $CmdResponses += New-Object -TypeName PSCustomObject -Property $Properties
    }

    if ($CmdRelevant)
    {
        if ($CmdResponses[0].Timestamp -lt $CmdRelevant[0].Timestamp)
        {
            $CommandObject = $Global:PBCommands | Where-Object -FilterScript {
                $_.Command -eq $RawCommand
            }

            if  ($CommandObject.Admin -eq $false -or ($CommandObject.Admin -and $CmdRelevant[0].Name -eq 'Windos'))
            {
                if ($CmdRelevant[0].Message -eq '!help')
                {
                    if ($CmdRelevant[0].Name -eq 'Windos')
                    {
                        $CmdOutput = Send-PBHelp -ReturnOnly -Admin
                    }
                    else
                    {
                        $CmdOutput = Send-PBHelp -ReturnOnly
                    }
                }
                else
                {
                    $CmdOutput = $CommandObject.Message
                }

                if ($CmdRelevant[0].Message -like '!add*')
                {
                    Add-PBCommand -InputMessage $CmdRelevant[0].Message
                }
                elseif ($CmdRelevant[0].Message -like '!edit*')
                {
                    Edit-PBCommand -InputMessage $CmdRelevant[0].Message
                }
                elseif ($CmdRelevant[0].Message -like '!remove*')
                {
                    Remove-PBCommand -InputMessage $CmdRelevant[0].Message
                }
                else
                {
                    $CmdOutput | Out-Stream
                }
            }
        }
    }
}
