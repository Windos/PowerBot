    # $null = Start-Job -Name 'CommandTimout' -ScriptBlock {
    #     try 
    #     {
    #         Initialize-PowerBot
    #         Out-Stream -Message 'PowerBot: CommandTimout Online'
    #         While ($true) 
    #         {
    #             $fullLog = Import-Csv -Path $Global:ChatLog
    #             $delay = (Get-Date).AddMinutes(-60)
    #         
    #             $commandOutput = $Global:PBCommands.'!twitter'
    #             $testString = $commandOutput.Replace(' https://twitter.com/WindosNZ','')
    #         
    #             $commandResponses = $fullLog | Where-Object -FilterScript {
    #                 $_.Message -like "$testString*" -and $_.User -eq 'PowerBot'
    #             }
    #         
    #             foreach ($commandResponse in $commandResponses) 
    #             {
    #                 $responseTime = Get-Date -Date $commandResponse.Time
    #                 if ($responseTime -gt $delay) 
    #                 {
    #                     $timeToGo = [math]::Round((New-TimeSpan -Start $delay -End $responseTime).TotalMinutes)
    #         
    #                     $objProperties = @{
    #                         'auth_token' = 'YOUR_AUTH_TOKEN'
    #                         'value'    = $timeToGo
    #                     }
    #                     $obj = New-Object -TypeName PSCustomObject -Property $objProperties
    #             
    #                     Push-DashingJson -Object $obj -Widget 'twitterTimeOut'
    #                 }
    #             }
    #             Start-Sleep -Seconds 50
    #         }
    #     }
    #     catch 
    #     {
    # 
    #     }
    #     finally 
    #     {
    #         $driver.Quit()
    #     }
    # }
    # 
    # $null = Start-Job -Name 'LiveViewers' -ScriptBlock {
    #     try 
    #     {
    #         Initialize-PowerBot
    #         Out-Stream -Message 'PowerBot: LiveViewers Online'
    #         $start = Get-Date
    #     
    #         $data = @()
    #     
    #         while ($true) 
    #         {
    #             $now = Get-Date
    #             $secondsPassed = (New-TimeSpan -Start $start -End $now).TotalSeconds
    #             $x = $secondsPassed
    #             $y = (Get-StreamViewers |
    #                 Where-Object -FilterScript {
    #                     $_ -ne 'Windos' -and $_ -ne 'PowerBot'
    #                 } |
    #             Measure-Object).Count
    #         
    #             $data += @{
    #                 'x' = $x
    #                 'y' = $y
    #             }
    #         
    #             $displayData = @()
    #             if ($data.Length -gt 240) 
    #             {
    #                 $displayData = $data[-240..-1]
    #             }
    #             else 
    #             {
    #                 $displayData = $data
    #             }
    #     
    #             $objProperties = @{
    #                 'auth_token' = 'YOUR_AUTH_TOKEN'
    #                 'points'   = $displayData
    #             }
    #             $obj = New-Object -TypeName PSCustomObject -Property $objProperties
    #         
    #             Push-DashingJson -Object $obj -Widget 'liveviewers'
    #         
    #             Start-Sleep -Seconds 15
    #         }
    #     }
    #     catch 
    #     {
    # 
    #     }
    #     finally 
    #     {
    #         $driver.Quit()
    #     }
    # }