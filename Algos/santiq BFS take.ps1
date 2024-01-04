
using namespace System.Collections.Generic
#Take on Santisq Node
class Neigh {
    [string]$parent
    [string]$nodename
    [string[]]$Neigh

    Neigh ([string]$p, [string]$n, [string[]]$neigh) {
        $this.parent = $p
        $this.nodename = $n
        $this.Neigh = $neigh
    }
}
class Graph {
    [hashtable]$nodes = @{}
    [hashset[string]]$visited = @{}
    [hashtable]$result = @{}
    [queue[hashtable]]$queue = @()

    Graph () {}
    Add ([hashtable]$add) {
        try {
            $this.nodes.add($add.group, [Neigh]::new($add.Parent, $add.Group, $add.Neigh))
        }
        catch {
            Write-Warning "[$($add.group)] Already exist, with parent [$($add.parent)]"
        }
    }

    Traverse ([string]$start) {
        $weight = 0
        $this.queue.Enqueue(@{From = $start; Weight = $weight; To = $this.nodes[$start].neigh })
        $this.result.add($start, '')
        [void]$this.visited.add($start)

        while ($this.queue.count) {
            $node = $this.queue.Dequeue()
            $weight++
            foreach ($n in $node.to) {
                if ($this.visited.Contains($n)) { Write-Warning "[$($n)] connected to Parent [$($node.from)] is a duplicate"; continue }
                $this.result.add($n, @{Parent = $node.from; Cost = $weight })
                [void]$this.visited.add($n)
                $this.queue.Enqueue(@{
                        From   = $n
                        Weight = $weight
                        To     = $this.nodes[$n].neigh
                    })
            }
        }

    }
    [string ]GetPath ([string]$to) {
        [list[string]]$res = @()
        Do {
            $res.add($to)
            $to = $this.result[$to].parent
        } While ($to)
        $res.Reverse()
        return $res -join '->'
    }
}

$nodes = @(
    @{ Parent = $null; Group = 'Group0'; Neigh = @('GroupA', 'GroupB') }
    @{ Parent = 'Group0'; Group = 'GroupA'; Neigh = @('GroupB', 'GroupC') }
    @{ Parent = 'GroupA'; Group = 'GroupC'; Neigh = @('GroupD') }
    @{ Parent = 'GroupC'; Group = 'GroupD'; Neigh = @('GroupA', 'GroupB') }
    @{ Parent = 'GroupD'; Group = 'GroupB'; Neigh = @('Group0') }
)
#        Group0
#        /     \
#     GroupA    GroupB
#     /     \
#  D->GroupB  GroupC
#            /
#          GroupD
#          /    \
#   D->GroupB  GroupA<-D
#D-> or <-D = Duplicate
$graph = [Graph]::new()

$nodes | ForEach-Object {
    $graph.add($_)
}
$graph.Traverse('Group0')
$graph.GetPath('GroupD')