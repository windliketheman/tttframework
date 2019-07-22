#
#  Be sure to run `pod spec lint TTTFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

    s.name         = "TTTFramework"
    s.version      = "1.0.1"
    s.summary      = "UI Framework for TTTeam."

	s.description  = <<-DESC
	TTTFramework is a simple framework for building ui interfaces, after you have configured the appropriate interface properties (especially the navigation bar), you don't have to worry about whether other interface modifications will have a negative impact on the interface. In fact, the interface will restore itself to its original appearance.
	DESC

    s.homepage     = "https://github.com/windliketheman/tttframework"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "wind" => "wind.like.the.man@icloud.com" }
    s.source       = { :git => "https://github.com/windliketheman/tttframework.git", :tag => s.version }

    s.platform     = :ios
    s.platform     = :ios, "8.0"
    s.ios.deployment_target = "8.0"
	
    s.requires_arc = true
    
    s.xcconfig     = { "GCC_PREPROCESSOR_DEFINITIONS" => 'TTTFRAMEWORK=1' }

    s.preserve_paths = "#{s.name}/Classes/**/*", "#{s.name}/Assets/**/*", "#{s.name}/Framework/**/*", "#{s.name}/Archive/**/*"

    s.source_files        = "#{s.name}/Classes/**/*.{h,m,mm,c,cpp,cc}"
    s.public_header_files = "#{s.name}/Classes/**/*.h"
    # s.vendored_frameworks = "#{s.name}/Assets/**/*.framework"

    s.resources    = "#{s.name}/Assets/#{s.name}.bundle"

    s.frameworks   =  'SystemConfiguration', 'MobileCoreServices', 'WebKit', 'AVFoundation', 'Photos'

    s.dependency 'MBProgressHUD'
    s.dependency 'Masonry'
    s.dependency 'uchardet'

end
