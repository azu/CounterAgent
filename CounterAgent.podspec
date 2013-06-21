#
# Be sure to run `pod spec lint CounterAgent.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "CounterAgent"
  s.version      = "0.0.1"
  s.summary      = "Simple Count Manager(App's version)"
  s.homepage     = "https://github.com/azu/CounterAgent"
  s.license      = 'MIT'
  s.author       = { "azu" => "azuciao@gmail.com" }
  s.source       = { :git => "https://github.com/azu/CounterAgent.git", :tag => "0.0.1" }
  s.source_files = 'Classes', 'Lib/**/*.{h,m}'
  s.requires_arc = true
end
