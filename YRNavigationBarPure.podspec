Pod::Spec.new do |spec|

  spec.platform = :ios
  spec.ios.deployment_target = '9.0'
  
  spec.name         = "YRNavigationBarPure"
  spec.version      = "0.0.1"
  spec.summary      = "Global navigation bar pure transition"
  spec.homepage     = "https://github.com/zongmumask/YRNavigationBarPure.git"
  spec.author       = { "Daniel Hu" => "zongmumask@gmail.com" }
  spec.license = { :type => "MIT" }

  spec.requires_arc = true
  spec.source       = { :git => "https://github.com/zongmumask/YRNavigationBarPure.git", :tag => "#{spec.version}" }
  spec.source_files = "YRNavigationBarPure/*.{h,m}"
  spec.framework    = "UIKit"

end
