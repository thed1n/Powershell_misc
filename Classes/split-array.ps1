function Split-Array {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        [object] $InputObject,

        [Parameter()]
        $ChunkSize = 5
    )

    begin {
        $bag = [System.Collections.Generic.List[object]]::new()
    }
    process {
        $bag.Add($InputObject)
        if($bag.Count -eq $ChunkSize) {
            $PSCmdlet.WriteObject($bag.ToArray())
            $bag.Clear()
        }
    }
    end {
        if($bag.Count) {
            $PSCmdlet.WriteObject($bag.ToArray())
            $bag.Clear()
        }
    }
}

$bigarray | Split-Array -ChunkSize 100 | ForEach-Object -Parallel {
  foreach($chunk in $_) {
    # do stuff
  }
} -ThrottleLimit 10