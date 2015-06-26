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
    $Delay = (Get-Date).AddMinutes(-15)
    $HelpDelay = (Get-Date).AddMinutes(-1)
    $CmdActive = (Get-Date).AddSeconds(-15)

    $CmdRelevant = $FullLog | Where-Object -FilterScript {
        $_.Message -like '!*' -or $_.Name -eq 'PowerBot'
    }

    [array]::Reverse($CmdRelevant)

    $CmdIndex = 0
    $CmdFound = $false

    Do
    {
        if ($CmdRelevant[$CmdIndex].Message -in $Global:PBCommands.Keys) 
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
            $Delay = $HelpDelay
        }
        else
        {
            $CmdOutput = $Global:PBCommands.($CmdRelevant[$CmdIndex].Message)
        }
        $CmdOutput
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
        } While (!$ResponseFound -and $ResponseIndex -ge 0)
    }

    if (!$ResponseFound)
    {
        $LastResponseTime = $Global:LastCmdResponse.($CmdRelevant[$CmdIndex].Message)

        if ($LastResponseTime -eq $null -or $LastResponseTime -lt $Delay)
        {
            $CmdOutput | Out-Stream

            if ($LastResponseTime -eq $null)
            {
                $Global:LastCmdResponse.Add(($CmdRelevant[$CmdIndex].Message), (Get-Date))
            }
            else
            {
                $Global:LastCmdResponse.($CmdRelevant[$CmdIndex].Message) = Get-Date
            }
        }
    }

    




    #foreach ($commandRequest in $CmdRelevant) 
    #{
    #    if ($commandRequest.Message -in $Global:PBCommands.Keys) 
    #    {
    #        if ((Get-Date -Date $commandRequest.Time) -gt $CmdActive) 
    #        {
    #            $recentResponse = $false
    #            if ($commandRequest.Message -eq '!help') 
    #            {
    #                $commandResponses = $FullLog | Where-Object -FilterScript {
    #                    $_.Message -like 'Available Commands: *' -and $_.User -eq 'PowerBot'
    #                }
    #                foreach ($commandResponse in $commandResponses) 
    #                {
    #                    $responseTime = Get-Date -Date $commandResponse.Time
    #                    if ($responseTime -gt $HelpDelay) 
    #                    {
    #                        $recentResponse = $true
    #                    }
    #                }
    #                if (!$recentResponse) 
    #                {
    #                    Send-PBHelp
    #                    Start-Sleep -Seconds 0.5
    #                }
    #            }
    #            else 
    #            {
    #                $commandOutput = $Global:PBCommands.($commandRequest.Message)
    #                $testString = $commandOutput
    #                if ($commandOutput -like '*twitter*') 
    #                {
    #                    $testString = $testString.Replace(' https://twitter.com/WindosNZ','')
    #                }
    #                $commandResponses = $FullLog | Where-Object -FilterScript {
    #                    $_.Message -like "$testString*" -and $_.User -eq 'PowerBot'
    #                }
    #
    #                foreach ($commandResponse in $commandResponses) 
    #                {
    #                    $responseTime = Get-Date -Date $commandResponse.Time
    #                    if ($responseTime -gt $Delay) 
    #                    {
    #                        $recentResponse = $true
    #                    }
    #                }
    #                if (!$recentResponse) 
    #                {
    #                    Out-Stream -Message $commandOutput
    #                    Start-Sleep -Seconds 0.5
    #                }
    #            }
    #        }
    #    }
    #}
}