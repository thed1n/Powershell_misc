using namespace System.Collections.Generic
Function Get-PermutationsRecursion {
    <#
.SYNOPSIS
Short description

.DESCRIPTION
list [1,2,3]
list [2,3]
list [3]
result [3]
RE is [3 2]
result [3,2]
RE is [3 2 1]

3
2
1

.PARAMETER list
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
    [OutputType([list[int]])]
    param(
        [Parameter()]
        [List[int]]$list
    )
    write-verbose "List [$($list -join ',')]"
    if ($list.count -eq 1) { write-verbose "Return Single [$($list -join ',')]";return $list}

    else {
        for ($i = 0 ; $i -lt $list.count; $i++) {
            $currentitem = $list[$i]
            $newlist = [list[int]]::new($list)
            $newlist.RemoveAt($i)
            #write-verbose "newlist [$($newlist -join ',')]"
            #[list[int]]
            $result = ke -list $newlist
            write-verbose "result [$($result -join ',')] $($result.count)"
            foreach ($r in $result) {
                [list[int]]$re = $r
                $re.add($currentitem)
                ,[list[int]]$re
            }
        }
    }
    
}

function Get-PermutationsStack {
    param (
        [List[int]] $items
    )

    $result = [list[array]]::new()

    # A stack to store intermediate results
    [System.Collections.Stack]$stack = @(@{
        'Permutation' = [List[int]]::new()
        'Remaining'   = [List[int]]::new($items)
    })

    while ($stack.Count -gt 0) {
        $current = $stack.Pop()

        # If we have a complete permutation
        if ($current.Remaining.Count -eq 0) {
            $result.add($current.Permutation)
        } else {
            # For each remaining item, create a new permutation and push it to the stack
            for ($i = 0; $i -lt $current.Remaining.Count; $i++) {
                $newPermutation = [List[int]]::new($current.Permutation)
                $newPermutation.Add($current.Remaining[$i])

                $newRemaining = [List[int]]::new($current.Remaining)
                $newRemaining.RemoveAt($i)

                $stack.Push(@{
                    'Permutation' = $newPermutation
                    'Remaining'   = $newRemaining
                })
            }
        }
    }

    return $result
}

# Usage
[List[int]]$items =@(1,2,3)
$k = Get-Permutations -item @(1,2,3,4) | ForEach-Object { $_ -join ' ' }

$permutationsArray = Get-Permutations -items $items
$permutationsArray | ForEach-Object { $_ -join ' ' }