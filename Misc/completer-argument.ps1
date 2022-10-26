using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Collections
using namespace System.Collections.Generic
class DateTimeCompleter : IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[CompletionResult]] 
    CompleteArgument(
        [string]$CommandName, [string]$ParameterName, [string]$WordToComplete,
        [Language.CommandAst]$CommandAst, [System.Collections.IDictionary] $FakeBoundParameters
    ) {
        $result = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
        $start = [datetime]::now
        $timeSpan = for ($i = 0; $i -gt -24; $i--) { $start.AddHours($i).ToString() }
        $timeSpan -match ('^{0}' -f $WordToComplete) | ForEach-Object { $result.Add([System.Management.Automation.CompletionResult]::new("'$_'", $_, ([CompletionResultType]::ParameterValue) , $_) ) }

        return $result
    }
}

function Get-argument {

    [CmdletBinding()]
    param (

        [Parameter(Position = 0)]
        [ArgumentCompleter([DateTimeCompleter])]
        $Date
    )
    }
