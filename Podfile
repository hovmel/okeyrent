# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

use_frameworks!
target 'VMIGrent' do
  # Comment the next line if you don't want to use dynamic frameworks
  project 'VMIGrent.xcodeproj'
  use_frameworks!

  # Pods for VMIGrent
  
  #Networking
#  pod 'Moya', '12.0.1'
  pod 'Moya', '~> 15.0'
#  pod 'Moya/RxSwift', '12.0.1'
  pod 'Moya/RxSwift', '~> 15.0'
  
  #RX
#  pod 'RxSwift'
#  pod 'RxCocoa'
  pod 'RxSwift', '~> 6.6'
  pod 'RxCocoa', '~> 6.6'
  
  #UI
  pod 'MultiSlider'
  pod 'HorizonCalendar'
  pod 'SHSPhoneComponent'
  pod 'SnapKit'
  pod 'Kingfisher', '5.13.3'
  
  #Map
  pod 'YandexMapsMobile', '4.1.0-full'
  
  #Firebase
  pod 'Firebase/Messaging'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Поднимаем минимальный target для всех зависимостей
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end

end
