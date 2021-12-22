[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [String]$ModuleName
)

Set-StrictMode -Version 'Latest'
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

[IO.Directory]::SetCurrentDirectory($PSScriptRoot)

$rootPath = $PSScriptRoot | Resolve-Path -Relative

Write-Information ("Replacing ""MODULE_NAME"" with ""$($ModuleName)"" in file/directory names.")
$getChildItemPath = Join-Path -Path $rootPath -ChildPath '*'
$filesWithModuleName = 
    Get-ChildItem -Path $getChildItemPath -Recurse -Filter "*MODULE_NAME*" |
    Sort-Object -Property { $_.FullName.Length } -Descending
foreach( $file in $filesWithModuleName )
{
    $newName = $file.Name -replace 'MODULE_NAME',$ModuleName
    Write-Verbose -Message ("  $($file.FullName | Resolve-Path -Relative) -> $($newName)")
    Rename-Item -Path $file.FullName -NewName $newName
}

Write-Information ('Putting TODO.md in place.')
$readmePath = Join-Path -Path $rootPath -ChildPath 'README.md'
Rename-Item -Path $readmePath -NewName 'TODO.md'

Write-Information ("Removing ""MODULE_"" prefix in file/directory names.")
$filesWithModulePrefix =
    Get-ChildItem -Path $getChildItemPath -Recurse -Filter "MODULE_*" |
    Sort-Object -Property { $_.FullName.Length } -Descending
foreach( $file in $filesWithModulePrefix )
{
    $newName = $file.Name -replace 'MODULE_', ''
    Write-Verbose -Message ("  $($file.FullName | Resolve-Path -Relative) -> $($newName)")
    Rename-Item -Path $file.FullName -NewName $newName
}

Write-Information ("Replacing ""MODULE_NAME"" -> ""$($ModuleName)"" in file contents.")
$repoFiles = Get-ChildItem -Path $getChildItemPath -Exclude '.git' -Recurse -File
foreach( $repoFile in $repoFiles )
{
    $filePath = $repoFile.FullName | Resolve-Path -Relative
    $text = Get-Content -Path $filePath -Raw
    $newText = $text -replace 'MODULE_NAME',$ModuleName
    if( $text -ne $newText -and $PSCmdlet.ShouldProcess($filePath, "replace MODULE_NAME -> $($ModuleName)") )
    {
        Write-Verbose -Message "  $($filePath)"
        [IO.File]::WriteAllText($filePath, $newText)
    }
}

if( -not (Test-Path -Path (Join-Path -Path $rootPath -ChildPath 'build.ps1')) )
{
    Write-Information "Installing and enabling Whiskey."
    if( $PSCmdlet.ShouldProcess($rootPath, 'installing and enabling Whiskey') )
    {
        $uri = 'https://github.com/webmd-health-services/Whiskey/releases/latest/download/build.ps1' 
        Invoke-WebRequest -Uri $uri -OutFile 'build.ps1'
    }
}

Write-Information ("Removing ""$($PSCommandPath | Resolve-Path -Relative)"".")
Remove-Item -Path $PSCommandPath

if( (Get-Command -Name 'git' -ErrorAction Ignore) )
{
    Write-Information 'Adding new files to Git repository.'
    if( $PSCmdlet.ShouldProcess($rootPath, 'git add *') )
    {
        git add *
    }

    Write-Information 'Committing changes to repository''s initial commit.'
    if( $PSCmdlet.ShouldProcess($rootPath, 'git commit --amend') )
    {
        git commit --amend -m "Initial commit."
    }

    Write-Information 'Pushing changes.'
    if( $PSCmdlet.ShouldProcess($rootPath, 'git push -f') )
    {
        git push -f
    }
}
else
{
    $msg = 'Changes haven''t been committed yet (couldn''t find Git executable). Run `git add *` then ' +
           '`git commit --amend -m "Initial commit."` and finally `git push` to complete the changes.'
    Write-Warning $msg
}

Write-Information ('Repository initialized. Please see the TODO.md file for next steps.')
