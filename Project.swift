import ProjectDescription
import ProjectDescriptionHelpers

/*
                +-------------+
                |             |
                |     App     | Contains TuistSample App target and TuistSample unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers

enum AppConfiguration: String {
  case Debug
  case Release
}

struct AppInfomation {
  var name: String
  var bundleId: String
  var configuration: AppConfiguration
}

extension AppInfomation {
  var configValue: String {
    return configuration.rawValue
  }
}

protocol ProjectFactory {
  var projectName: String { get }
  var targets: [Target] { get }
  var deployment: DeploymentTarget { get }
  var schemes: [Scheme] { get }
  var setting: Settings { get }
  
  func make() -> Project
}

class BaseProjectFactory: ProjectFactory {
  let projectName: String = "Tooda"
  
  var deployment: DeploymentTarget {
    .iOS(targetVersion: "13.0", devices: .iphone)
  }
  
  var targets: [Target] {
    [
      Target(
        name: projectName,
        platform: .iOS,
        product: .app,
        bundleId: "com.tooda",
        deploymentTarget: deployment,
        infoPlist: "\(projectName)/Sources/SupportFiles/Info.plist",
        sources: ["\(projectName)/Sources/**"],
        resources: ["\(projectName)/Resources/**"],
        entitlements: "\(projectName)/Sources/SupportFiles/Tooda.entitlements",
        scripts: targetScripts,
        dependencies: []
      ),
      Target(
        name: "\(projectName)Tests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "com.tooda.\(projectName)Tests",
        deploymentTarget: deployment,
        infoPlist: "\(projectName)Tests/Info.plist",
        sources: ["\(projectName)Tests/**"],
        resources: [],
        dependencies: []
      )
    ]
  }
  
  var schemes: [Scheme] { [
    Scheme.init(
      name: testAppinfo.name,
      shared: true,
      buildAction: .buildAction(targets: ["\(projectName)"]),
      testAction: .targets(["\(projectName)"]),
      runAction: .runAction(
        configuration: .configuration("\(testAppinfo.configValue)"),
        arguments: nil
      )
    ),
    Scheme.init(
      name: releaseAppInfo.name,
      shared: true,
      buildAction: .buildAction(targets: ["\(projectName)"]),
      testAction: .targets(["\(projectName)"]),
      runAction: .runAction(
        configuration: .configuration("\(releaseAppInfo.configValue)"),
        arguments: nil
      )
    )
  ]}
  
  var setting: Settings {
    .settings(configurations: [
      .debug(name: .configuration("Debug"),
              settings: [
               "Debug": "\(testAppinfo.configValue)",
               "CODE_SIGN_STYLE": "Manual",
               "CODE_SIGN_IDENTITY": "Apple Development",
               "PROVISIONING_PROFILE_SPECIFIER": "match Development com.tooda",
               "DEVELOPMENT_TEAM": "67SBNF2QS6"
              ],
             xcconfig: .relativeToRoot("\(projectName)/Sources/SupportFiles/Configuration/\(testAppinfo.configValue).xcconfig")),
      .release(name: .configuration("Release"),
               settings: [
                "Release": "\(releaseAppInfo.configValue)",
                "CODE_SIGN_IDENTITY": "Apple Distribution",
                "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.tooda",
                "CODE_SIGN_STYLE": "Manual",
                "DEVELOPMENT_TEAM": "67SBNF2QS6"
               ],
               xcconfig: .relativeToRoot("\(projectName)/Sources/SupportFiles/Configuration/\(releaseAppInfo.configValue).xcconfig"))
    ])
  }
  
  func make() -> Project {
    Project.init(name: self.projectName,
                 settings: self.setting,
                 targets: self.targets,
                 schemes: self.schemes,
                 fileHeaderTemplate: nil,
                 additionalFiles: [])
  }
}

// MARK: App Schemes

extension BaseProjectFactory {
  var releaseAppInfo: AppInfomation {
    AppInfomation(name: "Tooda", bundleId: "com.tooda", configuration: .Release)
  }
  
  var testAppinfo: AppInfomation {
    AppInfomation(name: "ToodaTest", bundleId: "com.tooda.test", configuration: .Debug)
  }
}

extension BaseProjectFactory {
  var targetScripts: [TargetScript] {
    [
      TargetScript.pre(script: "${PODS_ROOT}/Swiftlint/swiftlint", name: "Swiftlint")
    ]
  }
}

// MARK: Test Code
extension BaseProjectFactory {
  func aa() -> Configuration {
    let configuration: [String: SettingValue] = [
      "APP_NAME": "TodaTest",
      "APP_IDENTIFIER": "com.tooda.test",
      "APP_VERSION": "2.0.1",
      "APP_BUILD": "1",
      "MY_VALUE": "Hello"
    ]
    
    // path can nil
    return Configuration.debug(name: "Debug", settings: configuration, xcconfig: .relativeToRoot("\(projectName)/Sources/SupportFiles/Configuration/Debug.xcconfig"))
  }
}


let project = BaseProjectFactory().make()
