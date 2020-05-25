inhibit_all_warnings!
# Uncomment this line to define a global platform for your project

platform :ios, '11.0'

target 'NagarajanImgur' do
    pod 'ShimmerSwift'
    pod 'lottie-ios'
    pod 'SwiftKeychainWrapper'
    pod 'UIImageColors'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end

