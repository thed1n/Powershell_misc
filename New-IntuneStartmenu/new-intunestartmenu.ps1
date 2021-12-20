function New-IntuneStartmenu {
    <#
    .SYNOPSIS
    Creates startmenu customization for intune
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ScriptName
    Name of script?
    
    .PARAMETER XML
    XML data as a string
    
    .PARAMETER base64
    Startmenu configuration UTF-8 
    Preconverted with [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content -Path .\startmenu.xml -Raw -Encoding UTF8)))
    
    .PARAMETER path
    Path to xml file
    
    .PARAMETER Description
    Description of the policy
    
    .PARAMETER Displayname
    Displayname of the policy
    
    .EXAMPLE
    New-IntuneStartmenu -path .\README.md -Description 'Best shit in the world' -ScriptName 'Yolo swaggins' -Displayname 'Min fetast startmeny'

    .EXAMPLE
    New-IntuneStartmenu -xml $xmlstring -Description 'Best shit in the world' -ScriptName 'Yolo swaggins' -Displayname 'Min fetast startmeny'

    .EXAMPLE
    New-IntuneStartmenu -base64 $([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content -Path .\startmenu.xml -Raw -Encoding UTF8)))) -Description 'Best shit in the world' -ScriptName 'Yolo swaggins' -Displayname 'Min fetast startmeny'
    
    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'RAW'
        )]
        [Parameter(ParameterSetName = 'Base64')]
        [Parameter(ParameterSetName = 'Path')]
        [Alias('Name')]
        [string]$ScriptName,

        [ValidateNotNullOrEmpty()]
        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'RAW')]
        [string]$XML,

        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName = 'Base64')]
        [string]$base64,

        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName = 'Path')]
        [string]$path,
        [ValidateNotNullOrEmpty()]
        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'RAW'
        )]
        [Parameter(ParameterSetName = 'Base64')]
        [Parameter(ParameterSetName = 'Path')]
        [string]$Description,
        [ValidateNotNullOrEmpty()]
        [Parameter(ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'RAW'
        )]
        [Parameter(ParameterSetName = 'Base64')]
        [Parameter(ParameterSetName = 'Path')]
        [string]$Displayname
    )

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'RAW') {
            $base64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($XML))
        }

        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            if (-not (Test-Path $path)) {
                Write-Error "ERROR: Path not valid [$path] not found" -ErrorAction Stop
            }
            $base64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content -Path $path -Raw -Encoding UTF8)))
        }
        #Validate base64 string
        if ($PSCmdlet.ParameterSetName -eq 'Base64') {
        try {[void][convert]::FromBase64String($base64)}
        catch {Write-Error "ERROR: not a valid base64" -ErrorAction Stop}
        }
    }
    process {

        $content = [ordered]@{
            '@odata.type' = '#microsoft.graph.windows10GeneralConfiguration'
            displayName = $Displayname
            description = $Description
            startMenuLayoutXml = $base64
            fileName = $ScriptName
        }
        write-verbose $($content|convertto-json)


        $URI = "deviceManagement/deviceConfigurations"
        try {$Response = Invoke-MSGraphRequest -HttpMethod POST -Url $URI -Content ($content|convertto-json) -erroraction -stop -whatif:$WhatIfPreference -debug:$DebugPreference}
        catch {Write-Error 'ERROR: Failed to set startmenu' -ErrorAction Stop}

    }

    end {
        #ingen aning om det är detta.
        if ($response.responsecode -eq 200) {
            Write-output 'Command executed successfully'
        }
    }
}
