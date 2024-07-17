function Get-SwedishTax {
    <#
    .SYNOPSIS
    Calculates the Tax for Swedish taxpayers
    
    .DESCRIPTION
    Sends in value towards skatteverkets open api for tax table.
    https://swagger.entryscape.com/?url=https%3A%2F%2Fskatteverket.entryscape.net%2Frowstore%2Fdataset%2F88320397-5c32-4c16-ae79-d36d95b17b95%2Fswagger#/default/datasetQuery

    .PARAMETER Salary
    Your Salary or Lön
    
    .PARAMETER Table
    The Table of which your tax is beeing calculated
    SkatteTabell
    
    .PARAMETER BenefitValue
    If you have a benefit taxation like a car or a computer etc
    Förmånsvärde
    
    .PARAMETER SalaryDeduction
    Its salaryDeduction pre Tax
    Bruttolöneavdrag
    
    .PARAMETER year
    What year you want to check the tax for.
    Also it defaults to current year 
    
    .EXAMPLE
    Lets Say you have a Car
    Förmånsvärde = 4000
    Bruttolöneavdrag = 1000

    Get-SwedishTax -salary 20000 -Table 33 -BenefitValue 4000 -SalaryDeduction 1000
    
    .NOTES
    
    Tomas Hedin
    #>
    [cmdletbinding()]
    Param(
        [parameter(Mandatory, ValuefromPipeline)]
        [Alias('Lon')]
        [int]$Salary,
        [parameter(Mandatory)]
        [Alias('Tabell')]
        [ValidateRange(29, 42)]
        #ChurchTax for HBG is Onetable number lower for ex with church its 33 and without its 32
        [int]$Table,
        [Alias('Formansvarde')]
        [int]$BenefitValue = 0,
        [Alias('Bruttoloneavdrag')]
        [int]$SalaryDeduction = 0,
        [ValidatePattern('^2\d{3}$')]
        [string]$year = [datetime]::Now.Year
    )
    Begin {
        Function Get-TaxRegex {
            param (
                [Parameter(ValueFromPipeline)]
                [Int32]$Salary
            )
            process {
                $searchSalaryLow = ($Salary - 2).tostring() #To go from 30000 to 29998 for example to search that range this is to fit in with how its aligned in the data.
            switch ($searchSalaryLow.Length) {
                5 { $searchSalaryLow = $searchSalaryLow -replace '\d{3}$', '\d{3,}'; break }
                4 { $searchSalaryLow = $searchSalaryLow -replace '\d{2}$', '\d{2,}'; break }
                3 { $searchSalaryLow = $searchSalaryLow -replace '\d{1}$', '\d{1,}'; break }
                default { $searchSalaryLow = '\d{6,}' }
            }
            return $searchSalaryLow
            }
        }
    }
    Process {
        if ( $year -as [int32] -gt  [datetime]::Now.Year -as [int32]) {
            Throw 'Year is greater then current!'
        }

        $newSalary = $Salary - $SalaryDeduction
        #To be taxed with
        $SalaryWithBenifit = $newSalary + $BenefitValue

        $searchSalaryLow = $SalaryWithBenifit | Get-TaxRegex
        $apiUrl = 'tabellnr={0}&år={2}&inkomst fr.o.m.={1}&_limit=40' -f $Table, $searchSalaryLow, $year
        $searchApiUrl = 'https://skatteverket.entryscape.net/rowstore/dataset/88320397-5c32-4c16-ae79-d36d95b17b95?' + $apiUrl

        if (($newSalary -ne $Salary) -or ($SalaryWithBenifit -ne $Salary)) {
            $searchOriginalSalary = $salary | Get-TaxRegex
            $apiUrlOrg = 'tabellnr={0}&år={2}&inkomst fr.o.m.={1}&_limit=40' -f $Table, $searchOriginalSalary , $year
            $searchApiUrlOrg = 'https://skatteverket.entryscape.net/rowstore/dataset/88320397-5c32-4c16-ae79-d36d95b17b95?' + $apiUrlOrg
        }
    
        #Since it should be easy no failiure handling atm.
        if ($searchApiUrlOrg) {
            $apiResult = @(
                Invoke-RestMethod -Uri $searchApiUrl
                Invoke-RestMethod -Uri $searchApiUrlOrg
            )
        } else {
            $apiResult = Invoke-RestMethod -Uri $searchApiUrl
        }

        $formatTaxTable = $apiresult.results | ForEach-Object {
            if ($_.'inkomst fr.o.m.' -ge '846401') {
                [pscustomobject]@{
                    Tabell = $_.'tabellnr' -as [Int32]
                    LonLag = $_.'inkomst fr.o.m.' -as [Int32]
                    LonHog = [int32]::MaxValue
                    Skatt  = $_.'kolumn 1' -as [Int32]
                }
            }
            else {
                [pscustomobject]@{
                    Tabell = $_.'tabellnr' -as [Int32]
                    LonLag = $_.'inkomst fr.o.m.' -as [Int32]
                    LonHog = $_.'inkomst t.o.m.' -as [Int32]
                    Skatt  = $_.'kolumn 1' -as [Int32]
                }
            }
        }
        $SalaryByTable = $formatTaxTable | Group-Object -AsHashTable -Property Tabell

    
        $tax = ($SalaryByTable[$Table] | Where-Object { $SalaryWithBenifit -ge $_.LonLag -and $SalaryWithBenifit -le $_.LonHog }).Skatt | Select-Object -first 1
        if ($BenefitValue -gt 1 -or $SalaryDeduction -gt 1 ) {
            $baseTax = ($SalaryByTable[$Table] | Where-Object { $Salary -ge $_.LonLag -and $Salary -le $_.LonHog }).Skatt | Select-Object -first 1
        }


        [PSCustomObject]@{
            Salary          = $newSalary
            Tax             = $tax
            SalaryAfterTax  = $(if ($tax -gt 80) { $newSalary - $tax } else { $newSalary * (1 - ($tax / 100)) } )
            BenefitValue    = $BenefitValue
            SalaryDeduction = $SalaryDeduction
            Divisor94       = [Math]::round($salary / 94, 2, 1)
            Divisor72       = [Math]::round($salary / 72, 2, 1)
            SalaryWithoutDeductions = $salary
            SalaryAfterTaxOriginal = $(if ($basetax) {$(if ($basetax -gt 80) { $Salary - $basetax } else { $Salary * (1 - ($basetax / 100)) } )})
            Year = $year
        }

    }

}