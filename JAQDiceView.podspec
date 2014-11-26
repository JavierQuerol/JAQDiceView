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
  s.version          = "2.0.2"
  s.summary          = "A roll-the-dice view with SceneKit"
  s.description      = <<-DESC
                       A roll-the-dice view ready to use, made with SceneKit. >=iOS8
                       DESC
  s.homepage         = "https://github.com/javierquerol/JAQDiceView"
  s.screenshots 	 = "http://s15.postimg.org/4yh8hzbyz/dice.jpg"
  s.license          = 'MIT'
  s.author           = { "Javier Querol" => "querol.javi@gmail.com" }
  s.source           = { :git => "https://github.com/javierquerol/JAQDiceView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/javierquerol'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundle = { "JAQDiceView" => ['Pod/Assets/woodTile.png','Pod/Assets/Dices.dae'] }
  s.frameworks = 'SceneKit'
end
