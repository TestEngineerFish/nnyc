//
//  YXModelArchiverManager.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXModelArchiverManager.h"
#import "YXUtils.h"
#import <UIKit/UIKit.h>

@interface YXModelArchiverManager ()
@property (nonatomic, strong) NSCache                   *modelCache;
@end

@implementation YXModelArchiverManager

+ (instancetype)shared {
    static YXModelArchiverManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXModelArchiverManager new];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDir];
        self.modelCache = [[NSCache alloc]init];
        self.modelCache.name = @"com.archive.model";
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearMemoryCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)clearMemoryCache {
    [self.modelCache removeAllObjects];
}

- (NSString *)fileDir {
    return [[YXUtils docPath] stringByAppendingPathComponent:@"Cache/Model"];
}

- (void)createDir {
    NSString *path = [self fileDir];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error]) {
        return;
    }
}

- (BOOL)writeObject:(id)model file:(NSString *)fileName{
    NSString *path = [[self fileDir]stringByAppendingPathComponent:fileName];
    [self.modelCache setObject:model forKey:fileName]; // 存缓冲
    return [NSKeyedArchiver archiveRootObject:model toFile:path];
}

- (id)readObject:(NSString *)fileName {
    NSString *path = [[self fileDir]stringByAppendingPathComponent:fileName];
    id data = [self.modelCache objectForKey:fileName];
    if (data == nil) { // 没有缓冲，取数据库
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (data != nil) { // 数据库中有数据，存缓冲
            [self.modelCache setObject:data forKey:fileName];
        }
    }
    return data;
}

- (void)removeObject:(NSString *)fileName {
    NSString *path = [[self fileDir]stringByAppendingPathComponent:fileName];
    [self.modelCache removeObjectForKey:fileName];
    NSError *error = nil;
    [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
}

- (void)clearAllMemory {
    if (self.modelCache) {
        [self.modelCache removeAllObjects];
    }
    [YXUtils removeFile:[self fileDir]];
}


@end
