function Expand-String([string] $s){
    $ExecutionContext.InvokeCommand.ExpandString($s)
}

function Expand-Hash([Hashtable] $hash){
    if($hash -eq $null){
        return $hash
    }

    $output = @{}

    foreach($key in $hash.keys) {
        if($hash["$key"] -is [Hashtable]){
            $output["$key"] = Expand-Hash $hash["$key"]
        } elseif($hash["$key"] -is [string]){
            $output["$key"] = Expand-String $hash["$key"]
        } else {
            $output["$key"] = $hash["$key"]
        }
    }

    return $output
}

function Merge-Hash($base, $new) {
    if ($new -eq $null) { return $base.Clone() }
    if ($base -eq $null) { return $new.Clone() }

    foreach($key in $new.keys) {

        if ($new["$key"] -eq $null) {
            Write-Host "The key of [$key] is null... skipping"
        } elseif ($new["$key"] -is [Hashtable]) {
            if ($base[$key] -eq $null) {
                $base[$key] = $new[$key].Clone()
            } else {
                if ($base[$key] -is [String]){
                    $base[$key] = $new[$key]
                } else {
                    $base[$key] = Merge-Hash $base[$key].Clone() $new[$key].Clone()
                }
            }
        } else {
            $base[$key] = $new[$key]
        }
    }
    return $base
}