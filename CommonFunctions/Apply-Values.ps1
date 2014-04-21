function Apply-Values($config, $values) {

    $config_temp = $config.clone()

    $config.keys | %{
        if($config["$_"] -is [HashTable]) {
            $config_temp["$_"] = Apply-Values $config["$_"] $values
        } elseif ($config["$_"] -is [Array]) {
            $key = $_
            $config_temp["$key"] = @()
            $config["$key"] | % {
                $config_temp["$key"] += (Apply-StringValue $_ $values)
            }
        } elseif (($config["$_"] -is [string])) {
            $key = $_;
            $config_temp["$key"] = (Apply-StringValue $config["$key"] $values)
        }
    }
    return $config_temp
}

function Apply-StringValue($thisValue, $values) {
    [regex]::matches($thisValue, "{{.*?}}") | select -expand value |%{
        $origKey = $_
        $valueKey = $_.Trim("{{}}")
        $thisValue = $values["$valueKey"] | %{ $thisValue -replace $origKey, $_ }
    }
    return $thisValue
}
