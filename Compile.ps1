$OFS = "`r`n"
$scriptname = "winutil.ps1"


if (Test-Path -Path "$($scriptname)")
{
    Remove-Item -Force "$($scriptname)"
}

Write-output '
################################################################################################################
###                                                                                                          ###
### WARNING: This file is automatically generated DO NOT modify this file directly as it will be overwritten ###
###                                                                                                          ###
################################################################################################################
' | Out-File ./$scriptname -Append -Encoding ascii

(Get-Content .\scripts\start.ps1).replace('#{replaceme}',"$(get-date -format yy.MM.dd)") | Out-File ./$scriptname -Append -Encoding ascii

Get-ChildItem .\functions -Recurse -File | ForEach-Object {
    Get-Content $psitem.FullName | Out-File ./$scriptname -Append -Encoding ascii
}

Get-ChildItem .\xaml | ForEach-Object {
    $xaml = (Get-Content $psitem.FullName).replace("'","''")
    $newXaml = $xaml -replace 'CTTVersion', (Get-Date -Format 'yy.MM.dd')

    Write-output "`$$($psitem.BaseName) = '$newXaml'" | Out-File ./$scriptname -Append -Encoding ascii
}

Get-ChildItem .\config | Where-Object {$psitem.extension -eq ".json"} | ForEach-Object {
    $json = (Get-Content $psitem.FullName).replace("'","''")

    Write-output "`$sync.configs.$($psitem.BaseName) = '$json' `| convertfrom-json" | Out-File ./$scriptname -Append -Encoding ascii
}

Get-Content .\scripts\main.ps1 | Out-File ./$scriptname -Append -Encoding ascii
