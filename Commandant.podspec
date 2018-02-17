Pod::Spec.new do |s|
  s.name             = 'Commandant'
  s.version          = '0.13.0'
  s.summary          = 'Type-safe command line argument handling.'
  s.homepage         = 'https://github.com/Carthage/Commandant'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Carthage Project' => 'https://github.com/Carthage' }
  s.source           = { :git => 'https://github.com/Carthage/Commandant.git', :tag => s.version.to_s }
  s.macos.deployment_target = '10.13'
  s.source_files = 'Sources/Commandant/**/*'
  s.dependency 'Result', '~> 3.0'
end
