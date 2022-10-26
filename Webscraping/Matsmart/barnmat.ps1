$data = [system.Text.Encoding]::UTF8.GetString((Invoke-WebRequest -Uri https://www.matsmart.se/barnmat-0).rawcontentstream.toarray())#  -ContentType 'application/json; charset=utf-8'
#[system.Text.Encoding]::Unicode.GetString((Invoke-WebRequest $uri).RawContentStream.ToArray()
#$data2 = Invoke-WebRequest -uri https://www.matsmart.se/nestle-barngrot-apple-kanel

$pattern = '[\D\d]+(?<=Bäst före: )(?<lastdate>[0-9\-]+)[\D\d]+(?<="product-item-multi-price-label">)(?<amount>\d+)[\D\d]+(?<=class="product-price-title">)(?<price>\d+)[\D\d]+(?<=<span class="label">)(?<name>[a-öA-Ö -0-9;]+)[\D\d]+(?<=<span class="brand-and-weight">)(?<brand>[a-öA-Öéü]+)'
$pattern2 = '[\D\d]+(?<=Bäst före: )(?<lastdate>[0-9\-]+)[\D\d]+(?<=class="product-price-title">)(?<price>\d+)[\D\d]+(?<=<span class="label">)(?<name>[a-öA-Ö 0-9-;]+)[\D\d]+(?<=<span class="brand-and-weight">)(?<brand>[a-öA-Öéü]+)' # Utan amount

$food = $data -split '<li class' | % {

if ($_ -match 'Bäst före:') { 

$_|  sls -Pattern $pattern,$pattern2 -AllMatches | %{
$name,$amount,$lastdate,$price,$brand = $_.Matches[0].Groups['name','amount','lastdate','price','brand'].value

if ([string]::IsNullOrWhiteSpace($amount)) {$amount = 1}
[pscustomobject]@{
    Namn = $name -replace '&amp;','&'
    Antal = $amount
    Utgångsdatum = $lastdate
    Pris = '{0} kr' -f $price
    'Pris/st' = [math]::round(($price/$amount),2)
    Märke = $brand
}
}
}
}

$food | ft -autosize

