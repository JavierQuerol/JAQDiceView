#
# Be sure to run `pod lib lint JAQDiceView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JAQDiceView"
  s.version          = "0.1.0"
  s.summary          = "A short description of JAQDiceView."
  s.description      = <<-DESC
                       An optional longer description of JAQDiceView

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/javierquerol/JAQDiceView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Javier Querol" => "querol.javi@gmail.com" }
  s.source           = { :git => "https://github.com/javierquerol/JAQDiceView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/javierquerol'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
	'JAQDiceView' => ['Pod/Assets/*.{png,dae}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'SceneKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
