# YDeliver

YDeliver is a (opinionated) build and deployment framework aimed at .NET projects.

YDeliver is based on Powershell and the amazing psake framework. It borrows the best practices ( for example, Ydeliver strongly believes in convention over configuration) and tricks from across the industry, with the aim of quickly bootstrapping the build and release process of typical .NET projects. 

## Getting Started

You can include YDeliver as submodule within your project (recommended), or just have it as a Powershell module in your machine to invoke builds off.

```powershell
Import-Module path\to\YDeliver
```

You can also install YDeliver as a solution-level package using Nuget / Package manager:

```powershell
Install-Package ydeliver
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

You can override the `build.yml` settings by adding a `-config` parameter to `Invoke-YBuild`. See scaffolded `build.ps1` for example.

## YInstall

YInstall component takes care of "installing" the build artifacts - be it zip files, installers, nuget packages etc.

You can install "applications". These can be certain modules within your project - like a service, web app etc or the entire project itself. Each applications is defined to be of certain tasks and the configurations needed to install them. For example:

```yml
conventions:
    artifactsDir: "$rootDir/build"

install:
    ydeliver: 
        tasks:
            NugetPublish:
                config:
                    packages: ["ydeliver.*.nupkg"]
                    source: "NuGet official package source"
```

The above configuration in a `install.yml` defines an application `ydeliver`. When you install this application, the task `NugetPublish` is run. The `config` section defines the configuration needed to run the tasks. Here the nuget packages and the nuget feed source are specified.

You can override the `install.yml` settings by adding a `-config` parameter to `Invoke-YInstall`. See scaffolded `install.ps1` for example.

## YDeploy

Coming soon.

## Conventions

YDeliver follows certain conventions, like where to pick up the solution file, how to recognize unit test dlls, etc. These conventions are specified under `Conventions\Defaults.ps1`

You can specify your own, or modify the ones provided by the framework by adding the conventions key in the component config ( like build.yml):

```yml
conventions:
    framework:  "3.5x86"
    solutionFile:   "$rootDir/name.sln"
```

## Custom Tasks

If you cannot add your own task directly into the component's task folder ( either because you are using YDeliver as a Nuget package and don't want to touch the installed files, or if your are using YDeliver as a submodule), you can add a file in your project root named `<action>.custom.tasks.ps1` and the tasks from it will be picked up as well.

For example, if you want to add custom tasks for YBuild, create a file named `build.custom.tasks.ps1` and place it in the root of your project. These task will now be available from `Invoke-YBuild`.

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
##YFlow (work in progress)

YFlow is the developer workflow component. During the course of development, the developers would be running specific tasks at specific times. For example, you may want to run the `dbdeploy` task after updating some migrations. You may want to index solr after updating the config etc. Probably, when you run `dbdeploy`, you *also* want to reindex solr. Sometimes, these tasks may also cut across components ( YBuild, YInstall).

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

```powershell
Invoke-YScaffold -Component YBuild
```
YScaffold will not replace files that already exist unless called with the `-Force` switch.

## What's ahead?

Lots more documentation.
Bringing in the deploy component.
