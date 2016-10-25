Pod::Spec.new do |s|
  s.name = 'EZClockView'
  s.version = '1.2'
  s.license = 'MIT'
  s.summary = 'iOS framework to display and customize a clock.'
  s.homepage = 'https://github.com/notbenoit/EZClockView'
  s.social_media_url = 'http://twitter.com/notbenoit'
  s.authors = { 'Benoit Layer' => 'benoit.layer@gmail.com' }
  s.source = { :git => 'https://github.com/notbenoit/EZClockView.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end
