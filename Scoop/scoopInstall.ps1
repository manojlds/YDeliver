$script:scriptDir = split-path $MyInvocation.MyCommand.Path -parent

write-host -fore green "YDeliver installed. Import the module by running:"
write-host -fore yellow "Import-Module $scriptDir\Ydeliver.psm1"