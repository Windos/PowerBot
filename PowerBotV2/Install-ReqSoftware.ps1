#requires -Version 5
function Install-ReqSoftware
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Install-ReqSoftware
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Install-ReqSoftware
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    Param (
        [string] $Path = (Split-Path -Path (Get-Module -Name 'PowerBotV2' -ListAvailable).Path),
        [string] $Uri,
        [string] $Product
    )

    if (!(Test-Path -Path (Join-Path -Path $Path -ChildPath "$Product\"))) 
    {
        Write-Verbose -Message "Selenium not present in $Path, downloading latest version."
        
        $LocalArchive = Join-Path -Path $Path -ChildPath "$Product.zip"
        
        Invoke-WebRequest -Uri $Uri -OutFile $LocalArchive
        
        Expand-Archive -Path $LocalArchive -DestinationPath (Join-Path -Path $Path -ChildPath "\$Product")
        
        Remove-Item -Path $LocalArchive
    }
}
