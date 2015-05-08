Pod::Spec.new do |s|
  s.name         = "KLAlertView"
  s.version      = "1.0.0"
  s.summary      = "KLAlertView is used for mutil-TextField input in alertView"
  s.homepage     = "https://github.com/kinglonghuang?tab=repositories"
  s.license      = "MIT"
  s.authors      = { 'kinglonghuang' => 'kingjlhuang@gmail.com'}
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/kinglonghuang/KLAlertView.git", :tag => s.version }
  s.source_files = 'KLAlertView', 'KLAlertView/**/*.{h,m}'
  s.requires_arc = true
end