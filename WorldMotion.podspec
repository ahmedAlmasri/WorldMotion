Pod::Spec.new do |s|
  s.name             = 'WorldMotion'
  s.version          = '0.0.1'
  s.summary          = 'Coordinate system that represents device motion or position relative to the Earth'

  s.description      = "Use a CoreMotion sensor to use a coordinate system that represents device motion or position relative to the Earth."

  s.homepage         = 'https://github.com/ahmedAlmasri/WorldMotion'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ahmad Almasri' => 'ahmed.almasri@ymail.com' }
  s.source           = { :git => 'https://github.com/ahmedAlmasri/WorldMotion.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/almasri_ahmed'

  s.ios.deployment_target = '11.0'
  s.swift_version    = ['4.2', '5.0', '5.1', '5.2', '5.3']
  s.source_files = 'WorldMotion/Classes/**/*'
 
end
