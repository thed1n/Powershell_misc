function get-tree1 {
    <#
    .SYNOPSIS
        Generate Tree like view
    .DESCRIPTION
        Generate a view like example
        misc
        ├────1.backup
        |    ├────canondrivers
        |        ├────Disk0
        |    ├────Desktop
        |        ├71910775144db60fa73aa9.gif
        |        ├B4a00MUX.exe
        |        ├BDBinDoc.pdf
    .EXAMPLE
        get-tree d:\misc -depth 2

    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    param (
        [string]$path = '.\',
        [switch]$recurse,
        [int32]$depth = 0,
        [int32]$d = 0
    )
    
    if ($d -gt $depth) { return }
    [int32]$intendation = 4 * $d
    if ($d -eq 0) {
        write-host "$(split-path $path -Leaf)" 
    }
    $d++
    get-childitem $path | % {
     
        $name = $_.name
        $fullpath = $_.FullName
        write-debug "[$fullpath]"
        write-debug "[$($_.Attributes)]"
        switch -Regex ($_.Attributes) {
            'Directory' {
                #$d++
                if ($d -gt 1) {
                    $tempstring = " |" + " " * $intendation + "├" + "─" * 4 + $name
                }
                else { $tempstring = " " + " " * $intendation + "├" + "─" * 4 + $name }
                #$tempstring = "|" + " "*$intendation + "├" + "─"*4 + $name
                write-host $tempstring
                write-debug "[$depth] [$d]"
                get-tree1 -path $fullpath -depth $depth -d $d
            }
            #Default { $tempstring = "|" + " "*($intendation) +"├" + $name
            Default { 
                $tempstring = " |" + " " * ($intendation) + "├" + $name
                    
                write-host $tempstring
            }
        }
        
    }

}  