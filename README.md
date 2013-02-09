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
##YFlow

YFlow is the developer workflow component. During the course of development, the developers would be running specific task at specific times. For example, you may want to run the `dbdeploy` task after updating some migrations. You may want to index solr after updating the config etc. Probably, when you run `dbdeploy`, you *also* want to reindex solr. Sometimes, these tasks may also cut across components ( YBuild, YInstall).

If you are not using workflows, you may have to do:

```powershell
Invoke-YBuild dbdeploy
Invoke-YInstall solr
```

With `YFlow`, you can define these as your `workflows`. Scaffold the component to get `workflow.ps1` and `workflows.yml`.

```powershell
Invoke-YScaffold YFlow
```

`workflow.yml` for the above scenario will look like this:

```yml
workflow:
    dbsolr:
        ybuild: [dbdeploy]
        yinstall: [solr]
```

Now, you can do:

```powershell
Invoke-YFlow dbsolr #or
.\workflow.ps1 dbsolr
```

You can merge the functionalities of `build.ps1` and `workflow.ps1` as appropriate.

Note that `YDeliver` doesn't encourage dependencies between task as specified using psake syntax. We believe it is better being explicit. `YFlow` may be the replacement for this.

## YScaffold

This component helps you to quickly bootstrap a project's build and deploy. You can scaffold the files and scripts that are used by the different YDeliver component.

Currently, you can scaffold YBuild and YFlow.

```powershell
Invoke-YScaffold -Component YBuild
```
YScaffold will not replace files that already exist unless called with the `-Force` switch.

## What's ahead?

Lots more documentation.
Bringing in the deploy component.