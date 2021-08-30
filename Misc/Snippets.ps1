function convert-TextToHex ($string,[switch]$convert) {
if ($convert -eq $true) {
$str = $string -split '0x'| select -skip 1 | % { $v = '0x'+$_; [char]::ConvertFromUtf32($v) }
return ($str -join '')
}
else {
$str = $string.tochararray()|% { ('0x'+[system.convert]::tostring(([Int16][char]$_),16)) }
return ($str -join '') 
}
}

convert-TextToHex 'urkburk'
convert-TextToHex -convert -string 


class matte {

    matte() {}

    static [int32]gcd ($int1, $int2) {

        $x = 99
        if ($int1 -lt $int2) {
            $x = $int2
            $int2 = $int1
            $int1 = $x
            write-host "[$int1] [$int2]"
        }

        while ($x -ne 0) {
        $x = $int1 % $int2 
        $int1 = $int2 
        $int2 = $x

        if ($x -eq 0) {
            return $int1
        }
        }
        return $null
    }

    static [int32]lcm ($int1, $int2) {
        #[int32]$x = 0
        return ($int1*$int2)/[matte]::gcd($int1,$int2)
        #för att räkna flera lcm integers ex lcm(10,12,15,75)
        #[matte]::lcm(10,[matte]::lcm(12,[matte]::lcm(15,75)))
    }

}

#Multidimension array
$array2 = New-Object 'object[,]' 10,20
#init array with fixed size
$array3 = [object[,]]::new(100,100)
$array3 = [object[,,]]::new(100,100,100)
$array3 = [object[]]::new(100)
$array3.Count
$array2.count
$array2.gettype()
$array2[0,0] = 'zxc'
$array2[0,1] = 'asd'
$array2[0,0]
