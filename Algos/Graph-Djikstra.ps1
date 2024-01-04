Using Namespace System.Collections.Generic

Class Neigh {
    [string]$Name
    [int]$Weight
    [bool]$checked = $false
    Neigh ([string]$n, [int]$w) {
        $this.Name = $n
        $this.Weight = $w
    }
}

$graph = [ordered]@{}

#Root, Child, Wight
@'
A C 2
A G 7
A B 4
C F 8
C G 3
C A 2
B A 4
B D 2
D G 5
D B 2
D H 6
F C 8
F J 3
G A 7
G C 3
G D 5
G J 4
H D 6
H J 2
J F 3
J H 2
J G 4
'@ -split '\r?\n' | % {
    $a,$b,$c = $_ -split ' '
    if (-not $graph[$a]) {
        $graph[$a] = [list[neigh]]::new()
    }
        $graph[$a].add([neigh]::new($b,$c))
}

$result = [ordered]@{}
[hashset[string]]$visited = @{}


$graph.Keys | % {
    $result.add($_,@{Parent = '';Cost = [int32]::MaxValue;Checked = $false})
}
$parent = 'A'
$result[$parent].checked = $true
[void]$visited.add($parent)

foreach ($n  in $graph[$parent]) {
    if ($result[$n.Name].Cost -eq [int32]::maxValue -and $result[$parent].Cost -eq [int32]::MaxValue) {
        $result[$n.Name].Parent = $parent
        $result[$n.Name].Cost = $n.Weight
        
    }
}

#find the next smallest none checked in table
function lowest {
$low = [int32]::MaxValue
$lowest = ''
$result.keys | % {
    $key = $_
    $r = $result[$key]
    if ($r.cost -lt $low -and $r.checked -eq $false) {
        $low = $r.cost
        $lowest = $key
    }
}
return $lowest
}


Do {
    $parent = lowest
    if (-not $parent) {break}
    write-host "Working on [${parent}]"
    if ($visited.contains($parent)){continue}

        foreach ($n  in $graph[$parent]) {

            if ($visited.contains($n.name)){continue}

            if ($result[$n.Name].Cost -eq [int32]::maxValue -and $result[$parent].Cost -eq [int32]::MaxValue) {
                $result[$n.Name].Parent = $parent
                $result[$n.Name].Cost = $n.Weight
            }
            else {

                if ($result[$n.Name].cost -gt ($result[$parent].cost + $n.Weight)) {
                    $result[$n.Name].Parent = $parent
                    $result[$n.Name].Cost = $result[$parent].cost + $n.Weight
                }
                
            }
        }
        #Find Parent equals to the Neighbourgh with lowest cost
        $result[$parent].Checked = $true
        [void]$visited.add($parent)
        $result

} while ($true)