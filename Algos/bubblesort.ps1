$arr = 1..1000 | get-random -count ([int]::MaxValue)

for ($i=0 ; $i -lt $arr.count; $i++) {
    $swap = $false
    for ($y = 0; $y -lt ($arr.count-1); $y++ ) {
       
        if ($arr[$y] -gt $arr[$y+1]) {

            $temp = $arr[$y]
            $arr[$y] = $arr[$y+1]
            $arr[$y+1] = $temp
            $swap = $true
        }
    }
    if ($swap -eq $false) { break}
}

$arr

[System.Collections.Generic.Comparer]
[System.Collections.Generic.List[]]