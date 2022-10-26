$l="{0} {3} {5}, {1} {3} of beer.
{6}, {2} {4} {5}.
"
$b,$c,$d,$e,$g,$h='bottles','of beer on the wall','Take one down and pass it around','Go to the store and buy some more','no more','bottle'
99..3|%{$l-f$_,$_,($_-1),$b,$b,$c,$d};$l-f2,2,1,$b,$h,$c,$d;$l-f1,1,$g,$h,$b,$c,$d;$l-f'No more',$g,99,$b,$b,$c,$e