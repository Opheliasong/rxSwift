# Podfile
use_frameworks!

target 'rxSwiftExam' do
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Moya/RxSwift'
    pod 'Moya-ModelMapper/RxSwift', '~> 10.0'
    pod 'RxOptional'
end

# RxTest and RxBlocking make the most sense in the context of unit/integration tests
target 'rxSwiftExamTests' do
    pod 'RxBlocking'
    pod 'RxTest'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
              config.build_settings['ENABLE_TESTABILITY'] = 'YES'
              config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
