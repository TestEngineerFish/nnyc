//
//  YXFileDBManager.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXFileDBManager.h"
#import "ZipArchive.h"
#import "YXUtils.h"
#import "NSString+YX.h"
#define KDefaultFilemanager [NSFileManager defaultManager]
@interface YXFileDBManager ()

@end

@implementation YXFileDBManager

+ (instancetype)shared {
    static YXFileDBManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXFileDBManager new];
        [shared creatResourceDicionary];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)unitFileIsExist:(NSString *)name {
    NSString *path = [[YXUtils resourcePath]DIR:name];
    return [YXUtils fileExist:path];
}


- (void)unzipFile:(NSString *)name {
    NSString *zipfilePath = [[YXUtils resourcePath] DIR:name];
    
    ZipArchive *zip = [[ZipArchive alloc]init];
    if ([zip UnzipOpenFile:zipfilePath]) {
        BOOL result = [zip UnzipFileTo:[zipfilePath stringByDeletingPathExtension] overWrite:YES];
        if (!result) {
            NSLog(@"解压失败!");
        } else {
//            [YXUtils removeFile:zipfilePath];
        }
        [zip UnzipCloseFile];
    }
}


- (BOOL)removeZipFile:(NSString *)name {
    NSString *zipfilePath = [[YXUtils resourcePath] DIR:name];
    return [YXUtils removeFile:zipfilePath];
}

- (BOOL)saveAndUnzip:(NSData *)data andOriFileName:(NSString *)filename {
    NSString *filepath = [[YXUtils resourcePath] DIR:filename];
    NSString *fileDicPath = [filepath stringByDeletingLastPathComponent];
    
    //是否是文件夹
    if (![KDefaultFilemanager fileExistsAtPath:fileDicPath]) {
        BOOL isSuccess = [KDefaultFilemanager createDirectoryAtPath:fileDicPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isSuccess) {
            NSLog(@"创建书本资源文件夹失败");
            return NO;
        }
    }
    
    if (![KDefaultFilemanager createFileAtPath:filepath contents:data attributes:nil]) {
        return NO;
    }
    ZipArchive *zip = [[ZipArchive alloc]init];
    if ([zip UnzipOpenFile:filepath]) {
//        NSString *unzipPath = [filepath stringByDeletingPathExtension];
        BOOL result = [zip UnzipFileTo:fileDicPath overWrite:YES];
        // 成功失败都移除zip
        [YXUtils removeFile:filepath];
        [zip UnzipCloseFile];
        
        if (!result) {
            NSLog(@"解压失败!");
        } else {
        }
        return result;
    }else {
        [YXUtils removeFile:filepath];
        return NO;
    }
    
    
//    if ([self creatResourceDicionary]) {
//        NSString *filepath = [[YXUtils resourcePath] DIR:filename];
//        if (![[NSFileManager defaultManager] createFileAtPath:filepath contents:data attributes:nil]) {
//            return NO;
//        }
//        ZipArchive *zip = [[ZipArchive alloc]init];
//        if ([zip UnzipOpenFile:filepath]) {
//            BOOL result = [zip UnzipFileTo:[filepath stringByDeletingPathExtension] overWrite:YES];
//            if (!result) {
//                NSLog(@"解压失败!");
//            } else {
//            }
//            // 成功失败都移除zip
//            [YXUtils removeFile:filepath];
//            [zip UnzipCloseFile];
//            return result;
//        }else {
//            [YXUtils removeFile:filepath];
//            return NO;
//        }
//    }else { // 创建主资源文件失败
//        return NO;
//    }
}


- (BOOL)saveWordMaterial:(NSData *)data andSupPath:(NSString *)subPath {
    NSString *mainPath = [YXUtils resourcePath];
    NSString *filePath = [mainPath stringByAppendingPathComponent:subPath];
    
    NSString *fileDicPath = [filePath stringByDeletingLastPathComponent];
    //是否是文件夹
    if (![KDefaultFilemanager fileExistsAtPath:fileDicPath]) {
        BOOL isSuccess = [KDefaultFilemanager createDirectoryAtPath:fileDicPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isSuccess) {
            NSLog(@"创建单词资源文件夹失败");
            return NO;
        }
    }
    BOOL isSuccess = [KDefaultFilemanager createFileAtPath:filePath contents:data attributes:nil];
    return isSuccess;
}


- (BOOL)creatResourceDicionary {
    if ([YXUtils createResourceDir:nil]) {
        NSLog(@"创建资源文件成功");
        return YES;
    }else {
        
        NSLog(@"创建资源文件失败");
        return NO;
    }
}


@end
