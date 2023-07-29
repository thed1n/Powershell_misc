$notification = $false

do {
    $d4patch = Invoke-WebRequest 'https://news.blizzard.com/en-us/diablo4/23964909/diablo-iv-patch-notes'

    [System.IFormatProvider]$provider = [System.Globalization.CultureInfo]::CurrentCulture

    $versions = $d4patch.content -split '\n?\r' | Select-String -SimpleMatch '(All Platforms)' | ForEach-Object {

        $_.tostring() | Select-String -Pattern '(\d\.\d\.\d.*?)<.+?> - (.+?)<' -AllMatches 
        | ForEach-Object {
            [pscustomobject]@{
                Version = $_.matches[0].groups[1].value
                # Date = [datetime]"$($_.matches[0].groups[2].value)"
                Date    = [datetime]::parseexact($_.matches[0].groups[2].value, ('MMMM', 'd,', 'yyyy'), $provider)
            }
        }
    }

    if (([datetime]::Today) -in $versions.date) {
        $msg = $versions | Where-Object Date -EQ ([datetime]::Today)
        $content = New-BTContentBuilder
        [void]$content.AddHeader('1', $msg.Date.ToShortDateString(), [Microsoft.Toolkit.Uwp.Notifications.ToastArguments]::new())
        [void]$content.addtext($msg.Version)
        [void]$content.AddButton('Open', [Microsoft.Toolkit.Uwp.Notifications.ToastActivationType]::Protocol, 'https://news.blizzard.com/en-us/diablo4')
        $content.show()
        $notification = $true
    }
    Start-Sleep -Seconds 600
}
while (
    $notification -eq $false
)

