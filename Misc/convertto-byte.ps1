[convert]::ToBase64String((Get-Content -path "your_file_path" -Encoding byte))
$input1 = ".\desktop\file.png"
$output1 = ".\desktop\file2.png"
#from byte to base64 n back
$png = gc $input1 -Encoding Byte
$pngb64 = [System.Convert]::ToBase64String($png)
$b64_2_string = [System.Convert]::FromBase64String($pngb64)
Add-Content $output1 -Value $b64_2_string -Encoding Byte