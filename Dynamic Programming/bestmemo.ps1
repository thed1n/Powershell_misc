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
            $combination = $remaindercombination.clone()
            $combination += $n
            $memo[$startvalue] = $combination
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


bestsummemo 7 @(7)
bestsummemo 7 @(5, 3, 4, 7)
bestsummemo 8 @(2,3,5)

bestsummemo 8 @(1, 4, 5)
bestsummemo 100 @(1, 2, 5, 25)