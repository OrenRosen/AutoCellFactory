#
# Be sure to run `pod lib lint AutoCellFactory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AutoCellFactory'
  s.version          = '0.1.1'
  s.summary          = 'Auto Create Cells.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "AutoCellFactory is simple to use, all it does it auto deques the cell and configure it, using the MVVM architacture."

  s.homepage         = 'https://github.com/OrenRosen/AutoCellFactory'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oren Rosenblum' => 'oren363@gmail.com' }
  s.source           = { :git => 'https://github.com/OrenRosen/AutoCellFactory.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AutoCellFactory/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AutoCellFactory' => ['AutoCellFactory/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
