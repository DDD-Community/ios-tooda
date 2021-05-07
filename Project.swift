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
	var organizationName: String { get }
	var targets: [Target] { get }
	var deployment: DeploymentTarget { get }
	var dependency: TargetDependency { get }
	var schemes: [Scheme] { get }
	var setting: Settings { get }
	
	func make() -> Project
}

class BaseProjectFactory: ProjectFactory {
	let projectName: String = "Tooda"
	
	let organizationName: String = "DTS"
	
	var deployment: DeploymentTarget {
		.iOS(targetVersion: "13.0", devices: .iphone)
	}
	
	var dependency: TargetDependency {
		TargetDependency.cocoapods(path: .relativeToRoot("."))
	}
	
	var targets: [Target] {
		[Target.init(name: projectName,
					 platform: .iOS,
					 product: .app,
					 bundleId: "",
					 deploymentTarget: deployment,
					 infoPlist: "\(projectName)/Sources/SupportFiles/Info.plist",
					 sources: ["\(projectName)/Sources/**"],
					 resources: ["\(projectName)/Resources/**"],
					 actions: targetActions,
					 dependencies: [dependency])]
	}
	
	var schemes: [Scheme] { [
		Scheme.init(name: testAppinfo.name,
			shared: true,
			buildAction: BuildAction.init(targets: ["\(projectName)"]),
			testAction: TestAction.init(targets: ["\(projectName)"]),
			runAction: RunAction.init(configurationName: "\(testAppinfo.configValue)",
				arguments: nil)
		),
		Scheme.init(name: releaseAppInfo.name,
			shared: true,
			buildAction: BuildAction.init(targets: ["\(projectName)"]),
			testAction: TestAction.init(targets: ["\(projectName)"]),
			runAction: RunAction.init(configurationName: "\(releaseAppInfo.configValue)",
				arguments: nil))
		]}
	
	var setting: Settings {
		Settings.init(configurations: [
			.debug(name: "Debug",
				   settings: ["Debug": "\(testAppinfo.configValue)"],
				   xcconfig: .relativeToRoot("\(projectName)/Sources/SupportFiles/Configuration/\(testAppinfo.configValue).xcconfig")),
			.release(name: "Release",
					 settings: ["Release": "\(releaseAppInfo.configValue)"],
					 xcconfig: .relativeToRoot("\(projectName)/Sources/SupportFiles/Configuration/\(releaseAppInfo.configValue).xcconfig"))
		])
	}
	
	func make() -> Project {
		Project.init(name: self.projectName,
					 organizationName: self.organizationName,
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
		AppInfomation(name: "Tooda", bundleId: "com.dts.tooda", configuration: .Release)
	}
	
	var testAppinfo: AppInfomation {
		AppInfomation(name: "ToodaTest", bundleId: "com.dts.tooda.test", configuration: .Debug)
	}
}

extension BaseProjectFactory {
	var targetActions: [TargetAction] {
		[
			TargetAction.pre(script: "${PODS_ROOT}/Swiftlint/swiftlint", name: "Swiftlint")
		]
	}
}

// MARK: Test Code
extension BaseProjectFactory {
	func aa() -> CustomConfiguration {
		let configuration: [String: SettingValue] = [
			"APP_NAME": "TodaTest",
			"APP_IDENTIFIER": "com.dts.toda.test",
			"APP_VERSION": "2.0.1",
			"APP_BUILD": "1",
			"MY_VALUE": "Hello"
		]

		// path can nil
		return CustomConfiguration.debug(name: "Debug", settings: configuration, xcconfig: .relativeToRoot("\(projectName)/Sources/SupportFiles/Configuration/Debug.xcconfig"))
	}
}


let project = BaseProjectFactory().make()