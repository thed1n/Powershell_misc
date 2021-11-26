
#youtube.com/watch?v=oBt53YbR9Kk&t=2451s&ab_channel=freeCodeCamp.org

#region fibonnaci
#Memoization
function fib ($n, $memo = @{}) {

    if ($n -le 2) { return 1 }
    
    if ($memo[$n]) { return $memo[$n] }
    $result = (fib ($n - 1) $memo) + (fib ($n - 2) $memo)
    $memo.add($n, $result)
    #write-debug $result
    write-debug $memo.Keys
    write-debug $memo.Values
    return $result


}
fib 8
fib 50
fib 100

#endregion


#region Gridtraveler
#Recursion
function gridtraveler ([int32]$x, [int32]$y) {

    if ($x -eq 0 -or $y -eq 0) { return 0 }
    elseif ($x -eq 1 -and $y -eq 1) { return 1 }
    #Go right
    return  (gridtraveler -x ($x - 1) -y $y) + (gridtraveler -x $x -y ($y - 1))
  
    

}
$DebugPreference = 2
#Memoization
function gridtravelermemo ([int32]$x, [int32]$y, $memo = @{}) {
    
    $grid = "$x,$y"
    if ($x -eq 0 -or $y -eq 0) { return 0 }
    if ($x -eq 1 -and $y -eq 1) { return 1 }

    if ($memo[$grid]) { return $memo[$grid] }

    $result = (gridtravelermemo -x ($x - 1) -y $y -memo $memo) + (gridtravelermemo -x $x -y ($y - 1) -memo $memo)
    $memo.add($grid, $result)

    return $result

}


gridtraveler 4 8
gridtravelermemo 8 4
gridtravelermemo 120 120
#endregion
#region cansum
#bruteforce
function cansum ($targetsum, [int32[]]$numbers) {
    #Kan numbers blr targetsum?
    $sum = @{}
    foreach ($n in $numbers) {

        foreach ($n1 in $numbers) {

            if ($n -eq $n1) {}
            else { $sum[($n + $n1)]++ }
            if ($sum.ContainsKey($targetsum)) { return $true }
        }
    }
    return $false

}

#recursion bruteforce
function cansumrec ($targetsum, [int32[]]$numbers) {
    #Kan numbers blr targetsum?
    if ($targetsum -eq 0) { return $true }
    if ($targetsum -lt 0) { return $false }
    foreach ($n in $numbers) {
        if ((cansumrec ($targetsum - $n) $numbers) -eq $true) { return $true }
    }
    return $false

}

function cansummemo ($targetsum, [int32[]]$numbers, $memo = @{}) {
    #Kan numbers blr targetsum?
    if ($targetsum -eq 0) { return $true }
    if ($targetsum -lt 0) { return $false }
    if ($memo.ContainsKey($targetsum)) { return $memo[$targetsum] }
    foreach ($n in $numbers) {
        $memo[$targetsum] = cansummemo ($targetsum - $n) $numbers $memo
        if ($memo[$targetsum] -eq $true) { return $true }
    }
    $memo[$targetsum] = $false
    return $false
}

$num = 1..1000000 

measure-command { cansum 354450 $num }
cansummemo 354450 $num
cansumrec  354450 $num
measure-command { cansum 300 @(7, 14) }
measure-command { cansumrec 300 @(7, 14) }
measure-command { cansummemo 300 @(7, 14) }


cansumrec 75445 $num
cansum 75445 $num

cansumrec 300 @(7, 14)
cansumrec 7 @(2, 3)
cansumrec 7 @(5, 3, 4, 7)
cansumrec 7 @(2, 4)
cansumrec 8 @(2, 3, 5)

cansummemo 300 @(7, 14)
cansummemo 7 @(2, 3)
cansummemo 7 @(5, 3, 4, 7)
cansummemo 7 @(2, 4)
cansummemo 8 @(2, 3, 5)

#endregion
#region howsum
#min egna take
function howsum ($targetsum, [int32[]]$numbers) {
    $arrlist = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($num in $numbers) {

        :inner foreach ($n in $numbers) {
            if ($num -gt $targetsum) { return , $arrlist }
            if ($n -gt $targetsum) { break :inner }
            if ($n -gt $num) {
                $low = $num
                $high = $n
            }
            else {
                $low = $n
                $high = $num
            }
            if ($targetsum -eq ($low + $high)) { $arrlist.add("$low,$high") | out-null }
        }
        if ($targetsum -eq $num) { $arrlist.add("$num") | out-null }
    }
    return , $arrlist
}
howsum 7 @(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
howsum 75445 $num
howsum 300 @(7,14)


$DebugPreference = 0

#mekk med returnerna hur det skulle fungera i detta scenariot
function howsumrec ([int32]$targetsum, [int32[]]$numbers) {

    if ($targetsum -eq 0 ) { $emptyarr = @(); return , $emptyarr }
    if ($targetsum -lt 0) { return $null }

    foreach ($num in $numbers) {
        $remainder = $targetsum - $num
        write-debug "remainder $remainder"
        $remainderresult = howsumrec $remainder $numbers
        write-debug "remainderresult $($remainderresult -join ',')"
        
        if ($null -ne $remainderresult) {
            write-debug "$($remainderresult.gettype())"
            $newremainderarr = @($remainderresult[0..$remainderresult.count] + $num)
            return , $newremainderarr
        }
    }
    return $null
}

$array2 = @(2, 3, 4, 5)
#$array3 = $array2[0..$array2.count] + 6

howsumrec 7 @(2, 3)
howsumrec 7 @(5, 3, 4, 7)
howsumrec 7 @(2, 4)
howsumrec 8 @(3, 2, 5)
howsumrec 300 @(7, 14) 



#Powershell hanterar inte att lägga $null i hashtables så var tvungen att bygga runt det med $false och returnera $null
function howsummemo ([int32]$targetsum, [int32[]]$numbers, $memo = @{}) {

    #write-debug "Keys = $($memo.Keys)"
    if ($memo[$targetsum] -eq $false) { return $null }
    if ($memo[$targetsum]) { return , $memo[$targetsum] }
    if ($targetsum -eq 0 ) { $emptyarr = @(); return , $emptyarr }
    if ($targetsum -lt 0) { return $null }
    

    foreach ($num in $numbers) {
        $remainder = $targetsum - $num
        $remainderresult = howsummemo $remainder $numbers $memo
        #write-debug $($remainderresult -join ',')
        if ($null -ne $remainderresult) {
            $newremainderarr = @($remainderresult[0..$remainderresult.count] + $num)
            $memo[$targetsum] = $newremainderarr
            #write-debug "$($memo[$targetsum].gettype())"
            return , $newremainderarr
        }
            
    }
    #Write-Debug $targetsum
    $memo[$targetsum] = $false
    #write-debug $($memo[$targetsum])
    #write-debug "$($memo[$targetsum].gettype())"
    return $null
}

howsummemo 7 @(2, 3)
howsummemo 7 @(5, 3, 4, 7)
howsummemo 7 @(2, 4)
howsummemo 8 @(5, 3, 2)
howsummemo 300 @(7, 14)

#endregion

#region bestsum


$DebugPreference = 2
function bestsum ([double]$startvalue, [double[]]$numarray) {
    #Write-Debug "startvalue = $startvalue"
    if ($startvalue -eq 0) { $arr = @(); return , $arr }
    if ($startvalue -lt 0) { return }

    $shortestcombination = $false
    foreach ($n in $numarray) {
        #write-debug "num $n"
        $remainder = $startvalue - $n
        $remaindercombination = bestsum $remainder $numarray
        
        if ($null -ne $remaindercombination) {
            write-debug $($remaindercombination.gettype())
            $combination = $remaindercombination.clone()
            $combination += $n
            #write-debug ($combination -join ',')
            #Write-Debug $($combination.gettype())
            #write-debug "comb lenght $($combination.Length) short $($shortestcombination.length)"
            if (($shortestcombination -eq $false) -or ($combination.count -lt $shortestcombination.count)) {
                $shortestcombination = $combination.clone()
            }
        }
    }
   
    return ,$shortestcombination

}


bestsum 7 @(7)
bestsum 7 @(5, 3, 4, 7)
bestsum 8 @(2, 3, 5)
bestsum 8 @(1, 4, 5)
bestsum 100 @(1, 2, 5, 25)


function bestsummemo ([int32]$startvalue, [int32[]]$numarray, $memo = @{}) {
        #Write-Debug "startvalue = $startvalue"
        if ($memo.ContainsKey($startvalue)) {return ,$memo[$startvalue]}
        if ($startvalue -eq 0) { $arr = @(); return , $arr }
        if ($startvalue -lt 0) { return }
    
        $shortestcombination = $false
        foreach ($n in $numarray) {
            #write-debug "num $n"
            $remainder = $startvalue - $n
            $remaindercombination = bestsummemo $remainder $numarray $memo
            
            if ($null -ne $remaindercombination) {
                write-debug $($remaindercombination.gettype())

                if ($remaindercombination.count -ge 1) {
                    try {
                    $combination = $remaindercombination.clone()
                    }
                    catch [System.Management.Automation.RuntimeException]{
                        $combination = @($remaindercombination)
                    }
                }
                else {
                    $combination = @($remaindercombination)
                }
                #$combination = $remaindercombination
         
                $combination += $n
                $memo[$startvalue] = $combination
                #write-debug ($combination -join ',')
                #Write-Debug $($combination.gettype())
                #write-debug "comb lenght $($combination.Length) short $($shortestcombination.length)"
                if (($shortestcombination -eq $false) -or ($combination.count -lt $shortestcombination.count)) {
                    #write-host $($combination -join ',')
                    $shortestcombination = $combination.clone()
                    #$shortestcombination = $combination

                }
            }
        }
        #$memo.GetEnumerator()
        return ,$shortestcombination

}

# $error[0].exception.GetType().fullname
bestsummemo 7 @(7)
bestsummemo 7 @(5, 3, 4, 7)
bestsummemo 8 @(2,3,5)

bestsummemo 8 @(1, 4, 5)
bestsummemo 100 @(1, 2, 5, 25)

#endregion

#region canConstruct



#endregion

$binaryarr = 1..10000000

Measure-Command {
    foreach ($b in $binaryarr)
     {if ($b -eq 8900000) {break}} }



     #min variant på binarysearch där jag överänkt och 
function search ($val, $array) {

    $min = 0
    $max = $array.count-1
    $search = [math]::floor($max/2)

    while ($null -eq $kaos) { # här skulle det brytas istället.
        write-debug "1 search = $search"
        write-debug "2 min $min max $max"
        write-debug "max - min = $($max-$min)"
        if ($array[$search] -eq $val) {return $search}
        else {
            if (($max-$min) -eq 2) {
                if ($array[$search+1] -eq $val) {return $search+1}
                if ($array[$search-1] -ne $val -and $array[$search+1] -ne $val) {return $false}
            }
            write-debug "3 array position $($array[$search])"
            if ($array[$search] -gt $val) {$max = ($search+1)} #här ska det vara -1 istället
            elseif ($array[$search] -lt $val ) {$min = ($search-1)} #här ska det vara +1
            $search = [math]::Floor(($min+$max)/2)
        }
        #start-sleep  -Milliseconds 100

    }
}

function search ($val, $array) {
    $left = 0
    $right = $array.count-1
    $mid = [math]::floor($right/2)

    while ($left -le $right) {
        write-debug "1 mid = $mid"
        write-debug "2 left $left right $right"
        #write-debug "right - left = $($right-$left)"
        if ($array[$mid] -eq $val) {return $mid}
            elseif ($array[$mid] -gt $val) {$right = ($mid-1)} #if array pos higher than value chop array Midvalue-1 for the new value
            else{$left = ($mid+1)} #else chop lower part+1
        $mid = [math]::Floor(($left+$right)/2)

    }
    return $false
}

$binaryarr = @(1..70)+@(72..10000000)
$data = 
search 70 $binaryarr
$binaryarr[$data]
search 19 @(2,7,8,9,10,13,17,19,21)

measure-command { search 70 $binaryarr}


#recurse slö som popcorn jämfört med ovan.
function binsearchrec ($val, $array, $left = 0, $right = $array.count) {

    if ($left -gt $right) {return $false}
    $mid = [math]::Floor(($left+$right)/2)
    #write-debug "1 mid = $mid"
    #write-debug "2 left $left right $right"

    if ($array[$mid] -eq $val) {return $mid}

    elseif ($array[$mid] -gt $val) {
        return binsearchrec $val $array $left ($mid-1)
    } 
    else{
        return binsearchrec $val $array ($mid+1) $right
    } 
    
    
}

measure-command {binsearchrec 72 $binaryarr}