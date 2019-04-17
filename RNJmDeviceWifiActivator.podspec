
Pod::Spec.new do |s|
  s.name         = "RNJmDeviceWifiActivator"
  s.version      = "1.0.0"
  s.summary      = "RNJmDeviceWifiActivator"
  s.description  = <<-DESC
                  RNJmDeviceWifiActivator
                   DESC
  s.homepage     = "https://github.com/CLANNADAIR/JMDeviceWifiActivator.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "clannad" => "522674616@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/CLANNADAIR/JMDeviceWifiActivator.git", :tag => "master" }
  s.source_files = "ios/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  