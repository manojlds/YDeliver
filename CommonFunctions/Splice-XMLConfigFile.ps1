function Splice-XmlConfigFile($file, $spliceConfig,$ns) {
    if (-not (Test-Path $file)) { return }

    [xml] $xml = gc $file
    Write-Host Splicing $file

    Set-XmlValues $xml $spliceConfig $ns
    $xml.Save($file)
}

function Set-XmlValues($xml, $spliceMap, $ns) {

    if($ns -eq $null){
        $ns = $spliceMap["namespace"];
    }

    $spliceMap.keys | ?{ $_ -ne "namespace" } | % {
        $xpath = $_
        $setSpec = $spliceMap[$_]

        $baseCommand = "`$xml | Select-Xml -XPath `$xpath"

        if ($ns -ne $null) {
            $baseCommand += " -Namespace `$ns"
        }

        $setSpec | % {
            $spec = $_
            $command = $baseCommand

            if ($spec.StartsWith("@") -and ($spec.contains("=")))
            {
                $firstEquals = $spec.indexOf("=")
                $attribute = $spec.substring(1, $firstEquals - 1)
                $value = $spec.substring($firstEquals + 1)
                $attribute
                $value
                $command += " | % { `$_.Node.$attribute = `"$value`" }"
            } elseif ($spec -eq ""){
                $command += " | % { `$_.Node.ParentNode.RemoveChild(`$_.Node)}"
            }
            else
            {
                $command += " | % { `$_.Node.innerText = `"$spec`" }"
            }

            Write-Host "spliceMap: $xpath"
            iex $command
        }
    }
}
