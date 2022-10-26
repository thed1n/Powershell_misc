Class Node {
    $id
    $parent
    $parentid
    [string]$child
    [string]$type
    $value

    Node($id, $parentid, [string]$parent, [string]$child) {
        $this.id = $id
        $this.parentid = $parentid
        $this.parent = $parent
        $this.child = $child
    }
    Node($id, $parentid, [string]$parent, [string]$child, [string]$type, $value) {
        $this.id = $id
        $this.parent = $parent
        $this.parentid = $parentid
        $this.child = $child
        $this.type = $type
        $this.value = $value
    }
}
function get-objectToTree {
    [cmdletbinding()]
    param (
        [string]$rootnode,
        [string]$parentName,
        [object]$inputObject,
        [int]$depth = 1000,
        [int]$cd = 0, #current Depth
        [string]$parentid = [System.Guid]::NewGuid().Guid
    )
    if ($cd -ge $depth) {
        return
    }


    if ($PSBoundParameters.ContainsKey('rootnode')) {

        if ($inputObject.psobject.properties.containskey) {
            #Tries to remove the property from the object if it exists
            try {
                $inputObject.psobject.properties.remove($rootnode)
            }
            catch {
                Write-Warning "Doesn't contain a property with the name [$rootnode]"
            }
        }
    }
    else { if (!$PSBoundParameters.ContainsKey('parentName')) { $rootnode = 'Object' } }

    if ($cd -eq 0) {
        foreach ($property in $inputObject.psobject.Properties) {
            $guid = [System.Guid]::NewGuid().Guid
            [node]::new($guid, $parentid, $parentName, $property.name, $property.value.gettype().name, '')
            get-objecttotree -inputobject $property.value -parentName $property.name -depth $depth -parentid $guid -cd ($cd + 1)
        }
    }

    try {
        if ($inputObject.gettype() -in 'String', 'DateTime', 'TimeSpan', 'Version', 'Enum', 'Int', 'Int32') {
            $guid = [System.Guid]::NewGuid().Guid
            [node]::new($guid, $parentid, $parentName, $inputobject, $inputObject.gettype().name, '')
            return
        }
    }
    catch {}

    if ($inputObject -is [array]) {

        foreach ($value in $inputobject) {
            if ($value.gettype() -in 'String', 'DateTime', 'TimeSpan', 'Version', 'Enum', 'Int', 'Int32') {
                $guid = [System.Guid]::NewGuid().Guid
                [node]::new($guid, $parentid, $parentName, $value, $value.gettype().name, '')
            }
            else {
                get-objecttotree -inputobject $value -parentName $value -depth $depth -parentid $guid -cd ($cd + 1)
            }
           
               
        }
    }

    if ($inputobject -is [System.Collections.IDictionary]) {

        foreach ($key in $inputObject.Keys) {

            $keyguid = [System.Guid]::NewGuid().Guid #to enumerate keys
            [node]::new($keyguid, $parentid, $parentName, $key, $inputObject.gettype().name, '')

            foreach ($value in $inputObject.$key) {
                if ($value.gettype() -in 'String', 'DateTime', 'TimeSpan', 'Version', 'Enum', 'Int', 'Int32') {
                    $guid = [System.Guid]::NewGuid().Guid
                    [node]::new($guid, $keyguid, $key, $value, $value.gettype().name, '')
                }
                else {
                    get-objecttotree -inputobject $value -parentName $key -depth $depth -parentid $keyguid -cd ($cd + 1)
                }
            }

        }


    }

    if ($cd -ge 1 -and $inputobject -isnot [array] -and $inputobject -isnot [System.Collections.IDictionary]) {

        foreach ($property in $inputObject.psobject.Properties) {
            $guid = [System.Guid]::NewGuid().Guid
            [node]::new($guid, $parentid, $parentName, $property.name, $property.value.gettype().name, '')
            get-objecttotree -inputobject $property.value -parentName $property.name -depth $depth -parentid $guid -cd ($cd + 1)
        }
       
    }



}

$tst = [pscustomobject]@{
    test      = 'test5'
    test2     = 2
    Array     = @('string', 'string2')
    Hash      = @{
        Name     = @(
            @{Firstname = 'Santiq'; LastName = 'Klingon' }
            @{Firstname = 'Talarion'; LastName = 'Wookie' })
        LastName = @('Kronos', 'Tellus')
    }
    HashArray = @{
        Kalle = @{
            Friend = @('jonte', 'kolla')
        }
    }
}

get-objecttotree -inputobject $tst -rootnode tst -parentName tst -depth 100
$inputobject = $tst

$d = $tst.psobject.Properties | Select-Object -First 1
$d.Value.gettype() -in 'String', 'DateTime', 'TimeSpan', 'Version', 'Enum', 'Int', 'Int32'
$inputobject = $tst

$testing123 | ForEach-Object {
    '{0}[{1}]-->{2}[{3}]' -f $psitem.parentid, $psitem.parent, $psitem.id, $psitem.child
} | Set-Clipboard

$ca | ForEach-Object {
    '{0}[{1}]-->{2}[{3}]' -f $psitem.parentid, $psitem.parent, $psitem.id, $psitem.child
} | Set-Clipboard
$ad = get-aduser pstomhej -properties *