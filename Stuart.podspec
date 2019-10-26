
Pod::Spec.new do |s|
    s.name             = 'Stuart'
    s.version          = '0.1.0'
    s.summary          = 'A short description of Stuart.'

    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC

    s.homepage         = 'https://github.com/linhey/Stuart'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'linhey' => '158179948@qq.com' }
    s.source           = { :git => 'https://github.com/linhey/Stuart.git', :tag => s.version.to_s }

    s.ios.deployment_target = '8.0'

    s.swift_version = ['4.2','5.0','5.1']


    s.subspec 'SectionView' do |ss|
        ss.source_files = ['Sources/SectionView/**']
    end

    s.subspec 'Input' do |ss|
        ss.source_files = ['Sources/Input/*/**']
    end

end
