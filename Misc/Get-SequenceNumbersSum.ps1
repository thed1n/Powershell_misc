function Get-SequenceNumbersSum {
    <#
    .SYNOPSIS
    Calculate sum of a sorted array with fixed intervall
    .DESCRIPTION
    Sn = n/2 [2a + (n – 1)d]
    where,
    Sn = sum of the arithmetic sequence,
    a  = first term of the sequence,
    d = difference between two consecutive terms,
    n = number of terms in the sequence.
    If we write 2a in the formula as (a + a), the formula becomes, Sn = n/2 [a + a + (n – 1)d]  
    We know, a + (n – 1)d is denoted by an. Hence, the formula becomes, Sn = n/2 [a + an]
    
    .PARAMETER numbers
    Array of ints that consists of numbers in order with a fixed interval
    
    .PARAMETER interval
    Intervall distance between the numbers
    
    .EXAMPLE
    $arr = 1..35
    $arr | measure-object -sum | % sum

    Get-SequenceNumbersSum -numbers $arr
    
    .EXAMPLE
    $arr = 1..500 | % {if ($_ %2 -eq 0) {$_}} #only even numbers
    $arr | measure-object -sum | % sum      #62750

    get-SequenceNumbersSum -numbers $arr -intervall 2

    .NOTES
    General notes
    #>
    [cmdletbinding()]
    param(
        [int32[]]$numbers,
        [int32]$interval
    )


    if ($PSBoundParameters.ContainsKey('intervall')) {
        return $numbers.length/2 * ($numbers[0]+$numbers[0] + ($numbers.length-1)*$interval)
    }
    #assume invervall 1

    #https://jarednielsen.com/sum-consecutive-integers/
    return $numbers.Length*($numbers.Length+1)/2

    #return  $numbers.length/2 * ($numbers[0]+$numbers[0] + ($numbers.length-1)*1)

}