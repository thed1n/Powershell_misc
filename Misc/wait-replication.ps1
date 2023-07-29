function Wait-Replication {
  [CmdletBinding()]
  Param(
    [Parameter(mandatory = $true)]
    [scriptblock]$ScriptBlock,

    [int]$SuccessCount = 2,

    [int]$DelayInSeconds = 2,

    [int]$MaximumFailureCount = 20
  )

  Begin {
    $successiveSuccessCount = 0
    $failureCount = 0
  }

  Process {
    while ($successiveSuccessCount -lt $SuccessCount) {
      if ($ScriptBlock.Invoke()) {
        $successiveSuccessCount++
      }
      else {
        $successiveSuccessCount = 0
        $failureCount++

        if ($failureCount -eq $MaximumFailureCount) {
          throw "Reached maximum failure count: $MaximumFailureCount."
        }
      }
    }

    Start-Sleep $DelayInSeconds
  }
}

#example
 Wait-Replication {
      $getResult = Invoke-AzRestMethod -Method "GET" -Path $roleAssignmentPath
      Write-Host "$($getResult.StatusCode) GET $roleAssignmentPath"

      $getResult.StatusCode -eq 200
    } -SuccessCount 6 -DelayInSeconds 4