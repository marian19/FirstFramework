
Pod::Spec.new do |s|

s.name = "FirstFramework"
s.version = "0.0.6"
s.platform     = :ios, "9.0"
s.summary = "FirstFramework for HTTPConection."
s.homepage = "https://github.com/marian19/FirstFramework"
s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Marian" => "mariansamy17@gmail.com" }

s.source = { :git => "https://github.com/marian19/FirstFramework.git", :tag => "#{s.version}" }

s.source_files  = "FirstFramework", "FirstFramework/**/*.{h,m}"

s.public_header_files = "FirstFramework/**/*.h"

#s.frameworks  = 'UIKit' , 'SystemConfiguration'

s.requires_arc = true

end
