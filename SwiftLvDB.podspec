#
#  Be sure to run `pod spec lint UIModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SwiftLvDB"
  s.version      = "1.0.0"
  s.summary      = "A fast key-value storage library , leveldb for swift"
  s.description  = <<-DESC
                   To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/SwiftLvDB
                   DESC
  s.homepage     = "https://github.com/Dcell/SwiftLvDB"
  s.license      = "MIT"
  s.author             = { "Dcell" => "" }
  s.source       = { :git => 'https://github.com/Dcell/SwiftLvDB', :tag => "#{s.version}" }
  s.frameworks = "Foundation"
  s.dependency 'leveldb-library'
  s.ios.deployment_target  = '8.0'
  s.swift_versions = ['4.0', '5.0']
  s.source_files  = "Class/Src/**/*.{h,m,mm,swift}"
  
end
