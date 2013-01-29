# YDeliver

YDeliver is a (opinionated) build and deployment framework aimed at .NET projects.

YDeliver is based on Powershell and the amazing psake framework. It borrows the best practices ( Ydeliver strongly belived in convention over configuration) and tricks from across the industry, with the aim of quickly bootstrapping the build and release process of typical .NET projects. 

## Getting Started

You can include YDeliver as submodule within your project (recommended), or just have it as a Powershell module in your machine to invoke builds off.

```powershell
Import-Module path\to\YDeliver
```

## YBuild

YBuild is the build component of YDeliver. Typically, this component is for compiling, unit testing and packaging your artifacts. YBuild comes with prebuilt tasks to clean and compile your solution, run NUnit tests and package ( zip / nuget) up your artifacts.

For example, you can run the clean, compile and package tasks by doing 

```powershell
Invoke-YBuild Clean,Compile,Project
```
To get a list of available tasks, you can do:

```powershell
Invoke-YBuild -listAvailable
```

## Conventions

YDeliver follows certain conventions, like where to pick up the solution file, how to recognize unit test dlls, etc. These conventions are specified under `Conventions\Defaults.ps1`

## Configuration

You can specify configurations like which folders to package into artifacts, which projects to make nuget packages out off etc.

### build.yml

Specifies the configurations for YBuild

`copyContents` : For specifying files and folders to be copied from one place to another
`packageContents` : For specifying file and folders to be packages into zip files
`nugetSpecs` : For specifying the .nuspec files to be used to build nuget packages

Sample build.yml:

```yml
copyContents:
    "$buildPath/cmd.dll":   "$buildPath/Cmd"
    "$buildPath/cmd.pdb":   "$buildPath/Cmd"
    "$buildPath/test":      "$buildPath/Cmd"

packageContents:
    "$buildPath/Cmd":  "Cmd.zip"

nugetSpecs:   [cmd.nuspec]
```

## What's ahead?

Lots more documentation.
Bringing in the deploy component.