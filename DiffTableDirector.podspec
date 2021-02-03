#
# Be sure to run `pod lib lint DiffTableDirector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DiffTableDirector'
  s.version          = '1.0.2'
  s.summary          = 'Framework to work with table view safe and easy. Support diff, pagination, placeholder view  '

  s.description      = <<-DESC
'Easy work with table view via view models. Self regestration, pagination, difference between old and new states. Empty state view support.'
                       DESC

  s.homepage         = 'https://github.com/manychat/DiffTableDirector'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE.md' }
  s.author           = { 'aleksiosdev' => 'aleksios@manychat.com' }
  s.source           = { :git => 'https://github.com/manychat/DiffTableDirector.git', :tag => "release/#{s.version.to_s}" }

  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'

  s.source_files = 'DiffTableDirector/Classes/**/*'

  s.dependency 'SwiftLint'
  s.dependency 'DeepDiff', '2.3.1'
end
