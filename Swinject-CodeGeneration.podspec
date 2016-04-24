#
# Be sure to run `pod lib lint Swinject-CodeGeneration.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Swinject-CodeGeneration"
  s.version          = "0.1.0"
  s.summary          = "Generates extensions on the container class, to make use of swinject less error prone and more typesafe."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       Generates extensions on the container class, to make use of swinject less error prone and more typesafe.
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/Swinject-CodeGeneration"
  s.license          = 'MIT'
  s.author           = { "Wolfgang Lutz" => "wlut@num42.de" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/Swinject-CodeGeneration.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.source_files   = '*.erb', 'swinject_cg'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
