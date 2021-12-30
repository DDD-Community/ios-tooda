# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Tooda' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'ReactorKit'
  pod 'SnapKit'
  pod 'RxDataSources'
  pod 'SectionReactor'
  pod 'Moya/RxSwift'
  pod 'CocoaLumberjack/Swift'
  pod 'Then'
  pod 'Swinject'
	pod 'RxViewController'
	pod 'SwiftLint'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'SwiftLinkPreview', '~> 3.4.0'
	pod 'netfox', configuration: %w(Debug)

  # Pods for TodaTest

end

post_install do |pi|
  # https://github.com/CocoaPods/CocoaPods/issues/7314
  fix_deployment_target(pi)
end

def fix_deployment_target(pod_installer)
  if !pod_installer
      return
  end
  puts "Make the pods deployment target version the same as our target"
  
  project = pod_installer.pods_project
  deploymentMap = {}
  project.build_configurations.each do |config|
      deploymentMap[config.name] = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
  end
  # p deploymentMap
  
  project.targets.each do |t|
      puts "  #{t.name}"
      t.build_configurations.each do |config|
          oldTarget = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
          newTarget = deploymentMap[config.name]
          if oldTarget == newTarget
              next
          end
          puts "    #{config.name} deployment target: #{oldTarget} => #{newTarget}"
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = newTarget
      end
  end
end
