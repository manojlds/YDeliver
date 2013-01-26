function Resolve-PathExpanded([string] $path){
    Resolve-Path (Expand-String $path)
}

function Expand-String([string] $s){
    $ExecutionContext.InvokeCommand.ExpandString($s)
}