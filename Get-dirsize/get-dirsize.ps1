function get-dirsize ($directory) {

    if (test-path $directory) {
    get-childitem -Path $directory -Directory | % {
    [float]$size = 0
    $dir = $_.basename
    $data = get-childitem -Path $_.fullname -Recurse
    foreach ($d in $data)  {
        $size += $d.length
    }

    [pscustomobject]@{
        folder = $dir
        files = $($data | Where-Object attributes -notlike 'Directory').count
        dirs = $($data | Where-Object attributes -like 'Directory').count
        sizeGB = [math]::round($($size / 1GB),2)
    }
}
    }
    else {Write-Host "Not a valid path [$directory]"}

}
