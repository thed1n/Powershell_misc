#here you go, it's apparently dead easy to implement for a class:
class MyValue {
    [int] $Value

    static [MyValue] op_Subtraction(
        [MyValue] $lhs,
        [int] $rhs
    ) {
        $lhs.Value -= $rhs
        return $lhs
    }
}

$object = [MyValue]@{ Value = 10 }
$object - 1
$object
#adding another overload like 
    static [int] op_Subtraction(
        [int] $lhs,
        [MyValue] $rhs
    ) {
        return $lhs - $rhs.Value
    }
#would let it support 
10 - $object
#so it's kind of fun
#amuses me anyway 😉