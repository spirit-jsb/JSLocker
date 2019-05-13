Pod :: Spec.new do |s|

    s.name    = 'JSLocker'
    s.version = '1.0.0'
    s.summary = '一个简便易用的垂直滑动抽屉框架。'

    s.description = <<-DESC 
    一个简便易用的垂直滑动抽屉框架，无需太多复杂设置。
                    DESC

    s.homepage = 'https://github.com/spirit-jsb/JSLocker.git'
    
    s.license  = { :type => 'MIT', :file => 'LICENSE' }

    s.author   = { 'spirit-jsb' => 'sibo_jian_29903549@163.com' }

    s.swift_version = '5.0'

    s.ios.deployment_target = '9.0'

    s.source = { :git => 'https://github.com/spirit-jsb/JSDrawer.git', :tag => s.version.to_s }

    s.source_files = 'Sources/**/*.swift'
    
    s.requires_arc = true
    s.frameworks   = 'UIKit', 'Foundation'

end