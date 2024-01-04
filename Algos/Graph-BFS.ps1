Using Namespace System.Collections.Generic

$graph = @{}

$graph.add('A', @('C', 'G', 'B'))
$graph.add('B', @('A', 'D'))
$graph.add('C', @('A', 'G', 'F'))
$graph.add('D', @('B', 'G', 'H'))
$graph.add('G',@('C','A','D','J'))
$graph.add('F', @('C', 'J'))
$graph.add('H', @('D', 'J'))
$graph.add('J', @('F', 'G', 'H'))



[HashSet[string]]$visited = @{}
$result = [ordered]@{}
$queue = [queue[hashtable]]::new()

$start = 'A'
$i = 1
$result.add($start,@{
    Parent = $null
    Cost = $null
})

[void]$visited.add($start)
foreach ($v in $graph[$start]) {

    if (-not $visited.Contains($v)) {
        $queue.Enqueue(
            @{
                Parent = $start
                To     = $v
                Cost   = $i
            })
    }
}

Do {
    $dequeue = $queue.Dequeue()
    $start = $dequeue.To
    [void]$visited.add($start)

    If (-not $result[$start]) {
        $result.add($start, @{
                Parent = $dequeue.Parent
                Cost   = $dequeue.Cost
            })
    }
    
    foreach ($v in $graph[$start]) {

        if (-not $visited.Contains($v)) {
            $queue.Enqueue(
                @{
                    Parent = $start
                    To     = $v
                    Cost   = $dequeue.Cost + 1
                })
        }
    }
    

} while ($queue.count -ne 0)


# to find the result
$from = 'H'

[list[string]]$res = @($from)

do {
$res.add($result[$from].parent)
$from = $result[$from].parent
} while ($result[$from].parent)


$res.Reverse()
$res