function Resolve-PathExpanded([string] $path){
    Resolve-Path (Expand-String $path)
}