function Get-Conventions($requested) {
    $requested | % { $conventions.$_ } 
}