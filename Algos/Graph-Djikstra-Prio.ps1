Using Namespace System.Collections.Generic

Class Neigh {
    [string]$parent
    [string]$Name
    [int]$Weight
    [bool]$checked = $false
    Neigh ([string]$p,[string]$n, [int]$w) {
        $this.parent = $p
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
        $graph[$a].add([neigh]::new($a,$b,$c))
}

$result = [ordered]@{}

[hashset[string]]$visited = @{}
$prioqueue = [PriorityQueue[Neigh,int32]]::new()

$parent = 'A'

$graph[$parent] | % {
    $prioqueue.Enqueue($_,$_.weight) #weigths are the same since its the starting node.
}

$result.add($parent,@{Parent = $null; Cost = $null})
[void]$visited.add($parent)

Do {
    
    $node = $prioqueue.Dequeue()
    $parent = $node.parent
    write-host "Working on [$($node.name)]"
    if ($visited.contains($node.Name)){continue}

            $result[$node.Name] = @{
                Parent = $parent
                Cost = $result[$parent].cost + $node.Weight
            }

        [void]$visited.add($node.name)

        $graph[$node.name] | % {
            $prioqueue.Enqueue($_,($result[$node.name].cost + $_.weight)) # Add weights from its parent and sub to get the right cost in the queue.
        }

} while ($prioqueue.count -gt 0)


#from F to A
function backtrack {
    param([string]$from)

    begin {
    [list[string]]$res = @($from)
    }
    process {
    do {
    $res.add($result[$from].parent)
    $from = $result[$from].parent
    } while ($result[$from].parent)
    
    }
    end {
        $res.Reverse()
        return ,$res
    }
}
$result['F']