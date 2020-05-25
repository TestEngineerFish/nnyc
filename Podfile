
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
workspace 'YX'

project 'YXEDU/YXEDU.project'

#################################
target 'YXEDU' do 
     platform :ios, '10.0'
     pod 'MBProgressHUD'
     pod 'SSKeychain'
     pod 'CocoaLumberjack'
     pod 'CocoaLumberjack/Swift'
     pod 'Bugly'
     pod 'AFNetworking'
     pod 'YYKit'
     pod 'IQKeyboardManager' , '~> 6.2.0'
     pod 'BMKLocationKit'
     pod 'HWWeakTimer'
     pod 'UICollectionViewLeftAlignedLayout'
     pod 'ZipArchive'
     pod 'MJRefresh'
     pod 'WMPageController'
     pod 'TZImagePickerController'
     pod 'FMDB'
     pod 'MagicalRecord'
     pod 'MJExtension'
     pod 'SGQRCode'
     pod 'Masonry'
     pod 'SDWebImage', '~> 4.4.2'
     pod 'LEEAlert', '~> 1.2.8'
     pod 'DACircularProgress', '~> 2.3.1'
     # 布局约束
     pod 'SnapKit', '~> 4.0.0'
     
     # 网络及数据模型转换
     pod 'Alamofire', '~> 4.7.3'
     pod 'ObjectMapper', '~> 3.3.0'
     pod 'AlamofireObjectMapper', '~> 5.0'
     
     # 友盟
     pod 'UMCCommon'
     pod 'UMCPush'
     pod 'UMCSecurityPlugins'
     
     
     pod 'SDCycleScrollView','~> 1.75'
     pod 'GrowingAutoTrackKit'
     pod 'Reachability', '~> 3.2'
     pod 'FSCalendar'
     
     # 闪验
     pod 'CL_ShanYanSDK'

     # 加载、解析动图
     pod 'lottie-ios'
     
     # 解压
     pod 'Zip'
     
     pod 'Kingfisher', '~> 5.9.0'

     # 音视频缓存库
     pod 'KTVHTTPCache'
     
     pod 'Toast-Swift'
     pod 'Toast'
     pod 'DZNEmptyDataSet'
     
end

## transform dynamic to static
post_install do |installer|

  def supported_staticlib_pods
    return ['MBProgressHUD', 'SSKeychain', 'CocoaLumberjack', 'AFNetworking', 'IQKeyboardManager', 'HWWeakTimer', 'UICollectionViewLeftAlignedLayout', 'ZipArchive', 'MJRefresh', 'WMPageController', 'FMDB', 'MagicalRecord', 'MJExtension', 'SGQRCode', 'Masonry', 'SDWebImage', 'LEEAlert', 'DACircularProgress', 'SnapKit', 'Alamofire', 'ObjectMapper', 'AlamofireObjectMapper', 'SDCycleScrollView', 'Reachability', 'FSCalendar', 'lottie-ios', 'Zip', 'Kingfisher', 'KTVHTTPCache', 'Toast-Swift', 'Toast', 'DZNEmptyDataSet']
  end

  def improve_pre_main_time_loading(installer)
  pod_frameworks_path = "Pods/Target Support Files/Pods-YXEDU/Pods-YXEDU-frameworks.sh"
  if(File.exist?(pod_frameworks_path))
    # Get Pods-#{project_name}-frameworks.sh
    pod_frameworks_content = File.read(pod_frameworks_path)
    is_updated_files = false
    installer.pods_project.targets.each do |target|
      if supported_staticlib_pods.include?(target.name)
        # Using 'staticlib' for every configs
        target.build_configurations.each do |config|
          config.build_settings['MACH_O_TYPE'] = 'staticlib'
        end

        # Removing `supported_staticlib_pods` from `Pods-#{project_name}-frameworks.sh`
        lib_path = "\"${BUILT_PRODUCTS_DIR}/#{target.name}/"

        if target.name == "lottie-ios"
          lib_path = "#{lib_path}Lottie.framework\""
          elsif target.name == "Toast-Swift"
          lib_path = "#{lib_path}Toast_Swift.framework\""
          else
          lib_path = "#{lib_path}#{target.name}.framework\""
        end

        pod_frameworks_content = pod_frameworks_content.gsub("install_framework #{lib_path}", "")

        is_updated_files = true
      end
    end

    if is_updated_files
      puts "Improving Pre-main Time"
      pod_frameworks_content = pod_frameworks_content.gsub("  \n", "")
      File.write(pod_frameworks_path, pod_frameworks_content)
    end

    else
    puts pod_frameworks_path + ' not found'
  end

end

improve_pre_main_time_loading(installer)

end


#
#def use_dylibs
#    project_name = "YXEDU"
#    pods_path = "Pods/Pods.xcodeproj/project.pbxproj"
#    pod_frameworks_path = "Pods/Target Support Files/Pods-#{project_name}/Pods-#{project_name}-frameworks.sh"
#
#    if(File.exist?(pods_path)) and (File.exist?(pod_frameworks_path))
#
#        pods_content = File.read(pods_path)
#        pod_frameworks_content = File.read(pod_frameworks_path)
#        is_updated_files = false
#
#        supported_staticlib_pods.each do |pod|
#            pods_mach_o_modulemap = "MODULEMAP_FILE = \"Target Support Files/#{pod}/#{pod}.modulemap\";"
#            pods_mach_o = "MACH_O_TYPE = staticlib;\n        #{pods_mach_o_modulemap}"
#            if pods_content.include? pod
#                # Use dylib
#                pods_content = pods_content.gsub(pods_mach_o, pods_mach_o_modulemap)
#
#                # For Pods script file
#                lib_path = "\"${BUILT_PRODUCTS_DIR}/#{pod}/"
#                if pod == "UINavigationBar+Addition"
#                    lib_path = "#{lib_path}UINavigationBar_Addition.framework\""
#                elsif pod == "GzipSwift"
#                    lib_path = "#{lib_path}Gzip.framework\""
#                else
#                    lib_path = "#{lib_path}#{pod}.framework\""
#                end
#
#                unless pod_frameworks_content.include? lib_path
#                    pod_frameworks_content = pod_frameworks_content.gsub(".framework\"\nfi", ".framework\"\n\tinstall_framework #{lib_path}\nfi")
#                    is_updated_files = true
#                end
#            end
#        end
#
#        File.write(pods_path, pods_content)
#        if is_updated_files
#            File.write(pod_frameworks_path, pod_frameworks_content)
#        end
#
#        puts "Converted white-list libs back to use dylib!"
#    else
#      puts pods_path ' or ' + pod_frameworks_path + ' not found'
#    end
#end
#
#use_dylibs

