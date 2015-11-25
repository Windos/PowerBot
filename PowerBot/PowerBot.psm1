﻿$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Libraries = @( Get-ChildItem -Path $PSScriptRoot\lib\*.dll -ErrorAction SilentlyContinue )

Foreach($Import in @($Public + $Private))
{
    Try
    {
        . $Import.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

Foreach($Load in $Libraries)
{
    Try
    {
        Add-Type -Path $Load.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to load library $($Load.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.Basename

$Script:Config = Get-Content -Path $PSScriptRoot\PersistentData\config.json -ErrorAction SilentlyContinue | ConvertFrom-Json
