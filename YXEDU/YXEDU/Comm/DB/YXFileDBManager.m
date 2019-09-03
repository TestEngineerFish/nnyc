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

@interface YXFileDBManager ()

@end

@implementation YXFileDBManager

+ (instancetype)shared {
    static YXFileDBManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXFileDBManager new];
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
    NSString *zipfilePath = [[YXUtils resourcePath]DIR:name];
    
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
    NSString *zipfilePath = [[YXUtils resourcePath]DIR:name];
    return [YXUtils removeFile:zipfilePath];
}

@end
