//
//  YRCommon.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>



//屏幕尺寸判断
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6P_MIN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


//=========================================
// 国际化
#define LS(s) NSLocalizedString(s, nil)


// 是否iPhone5
#define IS_iPhone5_Device       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)


//////////////////////////
/// system properties
//////////////////////////
/**
 *  判断设备是否为IPhoneX
 */
#define IS_IPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  状态栏高度
 */
#define STATUSBAR_HEIGHT                                     [UIApplication  sharedApplication].statusBarFrame.size.height
/**
 *  导航栏高度
 */
#define NAVIGATIONBAR_HEIGHT                                 44

/**
 *  Tab栏高度
 */
#define TABBAR_HEIGHT                                        44

/**
 *  为适配iPHONE X
 *  底部安全区域
 */
#define kBOTTOM_HOME_SAFE_AREA_HEIGHT                            (IS_IPhoneX ? 34 : 0)

/**
 *  屏幕高度
 */
#define SCREEN_HEIGHT                                       [UIScreen mainScreen].bounds.size.height
/**
 *  屏幕宽度
 */
#define SCREEN_WIDTH                                        [UIScreen mainScreen].bounds.size.width

/**
 *  显示器缩放比例
 */
#define SCREEN_SCALE                                        [[UIScreen mainScreen] scale]

/**
 *  操作系统版本号
 */
#define IOSVersion                                           [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 全局AppDelegate实例
 */
#define YRSharedAppDelegate                                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])

/**
 默认前景色
 */
#define YRDefaultButtonTintColor                            [UIColor whiteColor]


#pragma mark - 系统属性判断

/**
 *  是否iPhone
 */
#define IS_IPHONE                                           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

/**
 *  url参数是否utf-16编码
 */
#define IS_UTF16ENCODE                                      NO

#define AVAILABLE_11                                        (@available(iOS 11.0, *))


/* YRSDFolder_h */
//////////////////////////
/// sandbox directory
//////////////////////////
/**
 *  Doucment 路径
 */
#define SDDocumentDirectory                                 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
/**
 *  Cache 路径
 */
#define SDCacheDirectory                                    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,   YES) objectAtIndex:0]

/**
 *  Library 路径
 */
#define SDLibraryDirectory                                  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,   YES) objectAtIndex:0]

/**
 *  Temporary 路径
 */
#define SDTemporaryDirectory                                NSTemporaryDirectory()
/**
 *  Document 路径 folderName 文件夹
 */
#define SDDocumentFile(folderName)                          [SDDocumentDirectory stringByAppendingPathComponent:folderName]
/**
 *  Cache 路径 folderName 文件夹
 */
#define SDCacheFolder(folderName)                           [SDCacheDirectory stringByAppendingPathComponent:folderName]

/**
 *  Temporary 路径 folderName 文件夹
 */
#define SDTemporaryFolder(folderName)                       [SDTemporaryDirectory stringByAppendingPathComponent:folderName]

/**
 *  Library 路径 folderName 文件夹
 */
#define SDLibraryFolder(folderName)                         [SDLibraryDirectory stringByAppendingPathComponent:folderName]

/**
 *  Library/Config 路径 folderName 文件夹
 */
#define SDConfigFolder(folderName)                          [SDConfigDirectory stringByAppendingPathComponent:folderName]

/**
 *  Library/Config/Archiver 路径 folderName 文件夹
 */
#define SDArchiverFolder(folderName)                        [SDArchiverDirectory stringByAppendingPathComponent:folderName]

/**
 *  网络数据缓存文件夹名
 */
#define SDWebCacheFolderName                                @"WebCache"

/**
 *  图片数据缓存文件夹名
 */
#define SDImageCacheFolderName                              @"ImageCache"

/**
 *  配置文件存储文件夹名
 */
#define SDConfigFolderName                                  @"Config"

/**
 *  归档文件存储文件夹名
 */
#define SDArchiverFolderName                                @"Archiver"

/**
 *  网络数据缓存文件夹路径
 */
#define SDWebCacheDirectory                                 SDCacheFolder(SDWebCacheFolderName)
/**
 *  网络数据临时缓存文件夹路径
 */
#define SDWebTemporaryCacheDirectory                        SDTemporaryFolder(SDWebCacheFolderName)
/**
 *  图片数据缓存文件夹路径
 */
#define SDImageCacheDirectory                               SDCacheFolder(SDImageCacheFolderName)
/**
 *  图片数据临时缓存文件夹路径
 */
#define SDImageTemporaryCacheDirectory                      SDTemporaryFolder(ImageCacheFolderName)
/**
 *  配置文件存储文件夹路径
 */
#define SDConfigDirectory                                   SDLibraryFolder(SDConfigFolderName)

/**
 *  归档文件存储文件夹路径
 */
#define SDArchiverDirectory                                 SDConfigFolder(SDArchiverFolderName)
