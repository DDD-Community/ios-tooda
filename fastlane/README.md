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

### ios setup_code_signing

```sh
[bundle exec] fastlane ios setup_code_signing
```

Coding Signing을 위한 cert, profile을 세팅합니다

### ios increase_build_number

```sh
[bundle exec] fastlane ios increase_build_number
```

빌드넘버를 1 증가시킵니다

### ios upload_testflight

```sh
[bundle exec] fastlane ios upload_testflight
```

TestFlight에 새로운 테스트 빌드를 업로드합니다.

### ios get_app_name

```sh
[bundle exec] fastlane ios get_app_name
```

앱 이름 가져오기

### ios increase_buildNumber_xcconfig

```sh
[bundle exec] fastlane ios increase_buildNumber_xcconfig
```

xcconfig 빌드 업데이트

### ios update_buildNumber_xcconfig

```sh
[bundle exec] fastlane ios update_buildNumber_xcconfig
```

xcconfig 특정 빌드 버전으로 업데이트

### ios increase_versionNumber_xcconfig

```sh
[bundle exec] fastlane ios increase_versionNumber_xcconfig
```

xcconfig 버전 업데이트

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
