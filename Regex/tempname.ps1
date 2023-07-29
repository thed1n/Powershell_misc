$pattern = @'
(?x)
(?<header>\#{3}.+)
\n?
(?<links>(\*.*)\n?){1,}
'@
#https://regex101.com/r/HzXs05/1
<#
(?x)
(?<header>\#{3}.+)
\n?
(?<links>(\*.*)\n?){1,}

/
gm
(?x) match the remainder of the pattern with the following effective flags: gmx
x modifier: extended. Spaces and text after a # in the pattern are ignored
Named Capture Group header (?<header>\#{3}.+)
\# matches the character # with index 3510 (2316 or 438) literally (case sensitive)
{3} matches the previous token exactly 3 times
. matches any character (except for line terminators)
+ matches the previous token between one and unlimited times, as many times as possible, giving back as needed (greedy)
\n matches a line-feed (newline) character (ASCII 10)
? matches the previous token between zero and one times, as many times as possible, giving back as needed (greedy)
Named Capture Group links (?<links>(\*.*)\n?){1,}
{1,} matches the previous token between one and unlimited times, as many times as possible, giving back as needed (greedy)
A repeated capturing group will only capture the last iteration. Put a capturing group around the repeated group to capture all iterations or use a non-capturing group instead if you're not interested in the data
3rd Capturing Group (\*.*)
\* matches the character * with index 4210 (2A16 or 528) literally (case sensitive)
. matches any character (except for line terminators)
* matches the previous token between zero and unlimited times, as many times as possible, giving back as needed (greedy)
\n matches a line-feed (newline) character (ASCII 10)
? matches the previous token between zero and one times, as many times as possible, giving back as needed (greedy)
Global pattern flags 
g modifier: global. All matches (don't return after first match)
m modifier: multi line. Causes ^ and $ to match the begin/end of each line (not only begin/end of string)
#>



$ApiVersions = (Invoke-WebRequest -Uri 'https://github.com/Azure/bicep-types-az/raw/main/generated/index.md').Content

$result = $ApiVersions |sls -pattern $pattern -AllMatches

$result.Matches[1]