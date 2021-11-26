    #Fräckt sätt att bygga variabler ifrån en xml fil. (finns ju dock massor med andra sätt)    
    # Import variables
    
    Function New-XMLVariables {
    
        # Create a variable reference to the XML file

        $cfg.Settings.Variables.Variable | ForEach-Object {

                    # Set Variables contained in XML file

                    $VarValue = $_.Value

                    $CreateVariable = $True # Default value to create XML content as Variable

                    switch ($_.Type) {

                                # Format data types for each variable

                                '[string]' { $VarValue = [string]$VarValue } # Fixed-length string of Unicode characters

                                '[char]' { $VarValue = [char]$VarValue } # A Unicode 16-bit character

                                '[byte]' { $VarValue = [byte]$VarValue } # An 8-bit unsigned character

        '[bool]' { If ($VarValue.ToLower() -eq 'false'){$VarValue = [bool]$False} ElseIf ($VarValue.ToLower() -eq 'true'){$VarValue = [bool]$True} } # An boolean True/False value

                                '[int]' { $VarValue = [int]$VarValue } # 32-bit signed integer

                                '[long]' { $VarValue = [long]$VarValue } # 64-bit signed integer

                                '[decimal]' { $VarValue = [decimal]$VarValue } # A 128-bit decimal value

                                '[single]' { $VarValue = [single]$VarValue } # Single-precision 32-bit floating point number

                                '[double]' { $VarValue = [double]$VarValue } # Double-precision 64-bit floating point number

                                '[DateTime]' { $VarValue = [DateTime]$VarValue } # Date and Time

                                '[Array]' { $VarValue = [Array]$VarValue.Split(',') } # Array

                                '[Command]' { $VarValue = Invoke-Expression $VarValue; $CreateVariable = $False } # Command

                    }

                    If ($CreateVariable) { New-Variable -Name $_.Name -Value $VarValue -Scope $_.Scope -Force -Verbose}

        }

}



New-XMLVariables