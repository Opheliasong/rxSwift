# Podfile
use_frameworks!

target 'rxSwiftExam' do
    pod 'RxSwift', '6.1.0'
    pod 'RxCocoa', '6.1.0'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
    pod 'Moya/RxSwift', '~> 14.0'
end

# RxTest and RxBlocking make the most sense in the context of unit/integration tests
target 'rxSwiftExamTests' do
    pod 'RxBlocking', '6.1.0'
    pod 'RxTest', '6.1.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
              config.build_settings['ENABLE_TESTABILITY'] = 'YES'
              config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
