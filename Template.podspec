Pod::Spec.new do |s|

    s.name         = "Stuart"
    s.version      = "0.0.1"
    s.summary      = "A Template library."

    s.description  = <<-DESC
    Template is a powerful and pure Swift implemented library.
    DESC

    s.homepage     = "https://github.com/linhay/Stuart"
    s.screenshots  = ""

    s.license      = { :type => "MIT", :file => "LICENSE" }

    s.authors            = { "linhey" => "is.linhey@outlook.com" }
    s.social_media_url   = "https://twitter.com/is.linhey"
    s.source             = { :git => "https://github.com/linhay/Stuart.git", :tag => s.version }

    s.swift_version = "4.2"
    s.swift_versions = ['4.0', '4.2', '5.0']

    s.ios.deployment_target = "11.0"

    s.requires_arc = true

    s.subspec "SectionView" do |sp|
        sp.frameworks = "UIKit"
        sp.source_files  = ["Sources/SectionView/*.swift", "Sources/SectionView/**/*.swift"]
    end

end
