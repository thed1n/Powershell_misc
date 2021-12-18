Löste det såhär via att constructa json själv.. fattar inte varför det inte fungerar med det som vi testade igår... men fuck it 🙂

function New-IntuneStartmenu {
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

        $Params = @{
            ScriptName  = $ScriptName
            XML         = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content -Path "C:\users\nicahl\desktop\StartMenuLayout - Copy.xml" -Raw -Encoding UTF8)))
            DisplayName = "TEN - Test Startmenu919"
            Description = "Detta är min description"
        }
        $Json = @"
{
    "@odata.type": "#microsoft.graph.windows10GeneralConfiguration",
    "displayName": "$($params.DisplayName)",
    "description": "$($Params.Description)",
    "startMenuLayoutXml": "$($Params.XML)",
    "fileName": "$($Params.ScriptName)",
}
"@
        $URI = "deviceManagement/deviceConfigurations"
        $Response = Invoke-MSGraphRequest -HttpMethod POST -Url $URI -Content $Json

    }

    end {}
}


New-IntuneStartmenu -path .\README1.md