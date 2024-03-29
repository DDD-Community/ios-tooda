# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
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
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'RxViewController'
  pod 'SwiftLinkPreview', '~> 3.4.0'
  pod 'UITextView+Placeholder', '~> 1.2'
end

target 'Tooda' do
  # Comment the next line if you don't want to use dynamic frameworks
  shared_pods
  pod 'SwiftLint'
  pod 'Mantis', '~> 1.9.0'
  pod 'netfox', configuration: %w(Debug)
end

target 'ToodaTests' do
  # Comment the next line if you don't want to use dynamic frameworks
  shared_pods
  pod 'RxTest'
  pod 'Nimble'
  pod 'Quick'
  pod 'RxExpect'
  pod 'SnapshotTesting'
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
