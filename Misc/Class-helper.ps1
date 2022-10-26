using namespace System.Collections

class helper {
    helper([IDictionary] $values) {
        foreach ($key in $values.Keys) {
            if ($this.PSObject.Properties.Item($key)) {
                $this.$key = $values[$key]
            }
        }
    }
}

class middle : helper {
    [string] $Name
    
    middle([IDictionary] $values) : base($values) { }
}
class surname : helper {
    [string]$name
    [string]$dad
    surname([Idictionary] $values) :base($values) { }
}

class top : helper {
    [string] $Name
    [middle] $Middle
    [surname] $surname

    top([IDictionary] $values) : base($values) { }
}


$keso = [top]:
$top = [top]@{
    Name = 'Dave'
    RandomOther = 'Other'
    surname = @{
        Name = 'Mommy'
        Dad = 'Swizer'
    }
    Middle = @{
        Name = 'Rupert'
    }
}

[surname]@{
    Name='mommy'
}

$top|convertto-json
$top.gettype()
$top.surname.gettype()