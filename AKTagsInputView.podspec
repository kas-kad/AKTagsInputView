Pod::Spec.new do |s|
  s.name         = "AKTagsInputView"
  s.version      = "1.0.0"
  s.summary      = "convenient input view for tags strings"
  s.description  = "AKTagsInputView class implements a convenient input view for seek'n'selecting and writing tags data."
  s.homepage     = "https://github.com/purrrminator/AKTagsInputView"
  s.screenshots  = "http://cdn.makeagif.com/media/6-01-2014/anzpi7.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Andrey Kadochnikov" => "kaskaaddnb@gmail.com" }
  s.social_media_url   = "http://twitter.com/purrrminator"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/purrrminator/AKTagsInputView.git", :tag => s.version.to_s }
  s.source_files  = "Classes", "Classes/*.{h,m}"
  s.public_header_files = "Classes/*.h"
  s.resources = "Resources/*.png"
  s.requires_arc = true
end
