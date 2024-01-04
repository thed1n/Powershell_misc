#Ladda ner csv ifrån banken med ica lids linas och spara dem 
$mat = ls -Filter *.csv | ? name -match 'ica|lidl|linas' |import-csv -Delimiter ';' |select @{n='dag';e={[datetime]$_.'bokföringsdag'}},@{n='kostnad';e={[math]::Abs(($_.belopp -replace ',','.'))}}

$mathash = $mat |group {"$($_.dag.year)-$($_.dag.month.tostring('d2'))"}  -AsHashTable -AsString
$matyearhash = $mat |group {"$($_.dag.year)"}  -AsHashTable -AsString

$mathash.keys | % {
    [pscustomobject]@{
        ÅrMånad = $_
        SummaKostnad = $mathash[$_].kostnad | Measure-Object -Sum | % sum
    }} | sort årmånad

$matyearhash.keys | % {
    [pscustomobject]@{
        År = $_
        SummaKostnad = $matyearhash[$_].kostnad | Measure-Object -Sum | % sum
}} | sort år