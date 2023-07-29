1..15|%{(,'Fizz')[$_%3]+(,'Buzz')[$_%5]??$_}
$a,$b='Fizz','Buzz'

1..15|%{$_%3?$_%5?$_ :'Buzz':'Fizz'}

1..100|%{$_%3?$_%5?$_ :'Buzz':'Fizz'}

1..100|%{$_%3?$_%5?$_ :'Buzz':'Fizz'}
1..100|%{$_%15?$_%3?$_%5?$_ :'Buzz':'Fizz':'FizzBuzz'|Write-Host}
3%3?3%5?3 :'Buzz':'Fizz'
[System.Convert]::ToString(100,16)

1 ?'true':'false'
[int]$true
15|select @{n='s';e={$_%3}}
{IF($_%3-eq0){'Fizz'} }
1..100 | % {$_}
$i%3 & '':'Fizz'
$i%3 
$i%5
@(('Fizz','Buzz'))[0,0]


$arr2 = @((,'Fizz'),(,'Buzz'))
('Fizz','Buzz')|ConvertTo-Json -Depth 2
$arr2[0]



Print the numbers from 1 to 1,000 inclusive, each on their own line.

If, however, the number is a multiple of two then print Foo instead, if the number is a multiple of three then print Fizz, if the number is a multiple of five then print Buzz, and if the number is a multiple of seven then print Bar.

1..1000|%{(,'Foo')[$_%2]+(,'Fizz')[$_%3]+(,'Buzz')[$_%5]+(,'Bar')[$_%7]??$_}

$l="{0} {2} of beer on the wall, {0} {2} of beer.`n{4}, {1} {3} of beer on the wall.`n"
$b,$c,$d = 'bottles','Go to the store and buy some more','Take one down and pass it around'
99..2|%{$l-f$_,($_-1),$b,$b,$d};$l-f1,'No more',-join$b[0..5],$b,$d;$l-f'no more',99,$b,$b,$c

99 bottles of beer on the wall, 99 bottles of beer.
Take one down and pass it around, 98 bottles of beer on the wall.
{0} {3} {5}, {1} {3} of beer.`n{6}, {2} {4} {5}.
$l="{0} {2} {3}, {0} {2}.`n{4}, {1} {3} .`n"


$l="{0} {3} {5}, {1} {3} of beer.`n{6}, {2} {4} {5}.`n"
$b,$c,$d,$e='bottles','of beer on the wall','Take one down and pass it around','Go to the store and buy some more'
99..3|%{$l-f$_,$_,($_-1),$b,$b,$c,$d};$l-f2,2,1,$b,$b.trim('s'),$c,$d;$l-f1,1,'no more',$b.trim('s'),$b,$c,$d;$l-f'No more','no more',99,$b,$b,$c,$e