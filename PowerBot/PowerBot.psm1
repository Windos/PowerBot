$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Classes = @( Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue )
$Libraries = @( Get-ChildItem -Path $PSScriptRoot\lib\*.dll -ErrorAction SilentlyContinue )

Foreach($Import in @($Public + $Private + $Classes))
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

$Script:PersistentPath = Join-Path -Path $PSScriptRoot -ChildPath '\PersistentData\'
$Script:Config = Get-Content -Path $Script:PersistentPath\config.json -ErrorAction SilentlyContinue | ConvertFrom-Json
$Script:isMuted = $false
$Script:ViewersGreeted = @()
$Script:NewViewers = @{}
$Script:PBCommands = @()

Export-ModuleMember -Function $Public.Basename
