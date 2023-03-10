# Template-PSModule-OSS-Apache2.0 Changelog

## 2.2.0

### Changes

* `ReleaseNotes` module manifest private metadata now defaults to the URL of the module's CHANGELOG.md file in GitHub.

### Fixes

* Fixed: Initialize-Repository.ps1 doesn't replace `MODULE_NAME` placeholder in files.
* Fixed: Publishing a module to the PowerShell Gallery fails because its `Guid` metadata is missing.


## 2.1.0

* Fixed: initial tests still in Pester 4 syntax, but tests get run by Pester 5.
* Fixed: missed a token in one of the test files.
* Fixed: initial whiskey.yml set AppVeyor build number incorrectly.
* Fixed: builds fail on Windows PowerShell 5.1/.NET 4.6.2 because PackageManagement and PowerShellGet modules are too
old.
* Added empty prism.json files.

## 2.0.0

### Added

* Added an empty `CHANGELOG.md` file for the module's changelog.

### Changed

* Updated default `appveyor.yml` to runs builds on all operating system/PowerShell combinations available in AppVeyor:
  * Windows PowerShell 5.1/.NET 4.6.2
  * Windows PowerShell 5.1/.NET 4.8
  * PowerShell 6.2 on Windows
  * PowerShell 7.1 on Windows
  * PowerShell 7.2 on Windows
  * PowerShell 7.1 on macOS
  * PowerShell 7.2 on Ubuntu
* Updated the whiskey.yml file to use AppVeyor's deployments by default, instead of publishing with Whiskey:
  * All `*.*` branches now create builds with an `alpha` prerelease id.
  * The `develop` branch creates builds with an `rc` prerelease id.
  * Update the AppVeyor build with the version number created by Whiskey.
  * Module ZIP file now has the version number in its file name.
  * Module is now published to the .output directory by default (instead of to a gallery). This package can be published to the PowerShell Gallery with NuGet.
  * The ZIP and .nupkg files are uploaded as artificats to AppVeyor so they can be deployed with AppVeyor. It is assumed you have a GitHub deployment named `GitHub` and a PowerShell Gallery deployment named `PowerShellGallery`.
  * CHANGELOG.md, README.md, LICENSE, and NOTICE files are now included in the module when packaging.

### Removed

* Removed all publishing tasks and logic from the default `whiskey.yml`. Publishing is now recommended to be done by AppVeyor.

## 1.0.0

* Initial Version
