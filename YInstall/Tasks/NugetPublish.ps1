task NugetPublish {
    $artifactsDir = Get-Conventions artifactsDir
    $config.packages | %{
        $packagePaths = Resolve-Path "$artifactsDir\$_"
    }
    if(Test-Path $config.source){
        $packagePaths | %{
            Write-ColouredOutput "Publishing package $_ to $($config.source)" yellow
            Copy-Item $_ -destination $config.source
        }
    } else {
        $packagePaths | %{ 
            Write-ColouredOutput "Publishing package $_ to $($config.source)" yellow
            exec { nuget push $_ -source "$($config.source)" -noninteractive } "Nuget push failed."
        }
    }
}