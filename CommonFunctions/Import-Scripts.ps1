function Import-Scripts($scripts)
{
    $content = ""

    $scripts | %{

        $currentDir = Split-Path -Parent $_

        gc $_ | % {
            if ($_.startswith(". "))
            {
          
                $content += Import-Scripts (join-path $currentDir $_.substring(2, $_.length - 2))
            }
            else
            {
                $content = $content + [Environment]::NewLine + $_
            }
        }
    }
    
   $content

}