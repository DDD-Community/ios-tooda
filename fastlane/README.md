fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios release

```sh
[bundle exec] fastlane ios release
```

Push a new release build to the App Store

### ios upload_testflight

```sh
[bundle exec] fastlane ios upload_testflight
```

TestFlight에 새로운 테스트 빌드를 업로드합니다.

### ios increase_build_number

```sh
[bundle exec] fastlane ios increase_build_number
```

빌드넘버를 1 증가시킵니다

### ios setup_code_signing

```sh
[bundle exec] fastlane ios setup_code_signing
```

Signing 세팅

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
