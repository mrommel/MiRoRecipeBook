source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "9.0"
project 'MiRoRecipeBook/MiRoRecipeBook.xcodeproj'
use_frameworks!

def shared_pods
  pod "GoogleAnalytics"
  pod "HockeySDK", "~> 3.8.6"
  pod "SwiftyJSON", "4.2.0"
  pod "MapleBacon", "5.2"
  pod "SwiftSpinner", "1.6.2"

  pod 'SideMenu'
end

target "MiRoRecipeBook" do
  shared_pods
end

#target "MiRoRecipeBook DebugTests" do
#  shared_pods
#  pod "OCMock", "3.2.2"
#end

