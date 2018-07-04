#
# Commandant.podspec
# Commandant
#

#  Be sure to run `pod spec lint Commandant.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Commandant"
  s.version      = "0.14.0"
  s.summary      = "Type-safe command line argument handling"
  s.description  = <<-DESC
Commandant is a Swift framework for parsing command-line arguments, inspired by Argo
(which is, in turn, inspired by the Haskell library Aeson).
                   DESC

  s.homepage     = "https://github.com/Carthage/Commandant"
  s.license      = { type: "MIT", file: "LICENSE.md" }
  s.authors      = { "Carthage contributors" => "https://github.com/Carthage/Commandant/graphs/contributors" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.platform     = :osx, "10.9"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.source       = { git: "https://github.com/Carthage/Commandant.git", tag: s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.source_files  = "Sources/**/*.swift"
#   s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"



  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency "Result", "~> 4.0"

end
