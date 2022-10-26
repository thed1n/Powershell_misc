function Get-ObjectHelp {
    <#
    .synopsis
        open Powershell docs from a type name
    .example
        get-date | HelpFromType -PassThru
        Get-Culture | HelpFromType -PassThru
        (Get-Culture).Calendar | HelpFromType -PassThru

        https://docs.microsoft.com/en-us/dotnet/api/System.DateTime
        https://docs.microsoft.com/en-us/dotnet/api/System.Globalization.CultureInfo
        https://docs.microsoft.com/en-us/dotnet/api/System.Globalization.GregorianCalendar    
    #>
    [Alias('HelpFromType')]
    param(
        # object or type instance
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [object]$InputObject,

        # Return urls instead of opening browser pages
        [Parameter()][switch]$PassThru
    )

    process {
        if ($InputObject -is [string]) {
            $typeInstance = $InputObject -as [type]
            if ($null -eq $typeInstance) {
                Write-Debug "String, was not a type name: '$InputObject'"
                $typeName = 'System.String'
            } else {
                $typeName = $typeInstance.FullName
            }
        } elseif ( $InputObject -is [type] ) {
            $typeName = $InputObject.FullName
        } else {
            $typeName = $InputObject.GetType().FullName
        }
        $url = 'https://docs.microsoft.com/en-us/dotnet/api/{0}' -f $typeName

        if ($PassThru) {
            $url;  return
        }
        Start-Process $url
    }
}

$sortedlist = [System.Collections.Generic.SortedList[[string],[int]]]::new()
$sortedlist|Get-ObjectHelp