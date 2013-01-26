function Copy-PackageItem {
    param($source, $destination)

    Copy-Item $source -destination $destination -container -recurse
}