//
//  YRNetworkManager+Cache.m
//  YRNetwork
//
//  Created by pyyx on 2018/3/6.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "YRNetworkManager+Cache.h"
#import "YRHttpResponse.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation YRNetworkManager (Cache)

/**
 * 读取缓存数据
 */
- (void)readCacheData:(NSString *) url params:(NSDictionary *) params cache:(BOOL) cache completion:(YRHttpCompletion) completion {
    if (!cache) return; // 不读缓存
    
    NSString *txtPath = [self cacheFilePath:url params:params]; // 文件保存路径
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:txtPath]) {
        NSMutableDictionary *cacheData = [NSMutableDictionary dictionaryWithContentsOfFile:txtPath];
        
        if (completion && cacheData) {
            [cacheData setObject:@(YES) forKey:@"isCache"];
            
            YRHttpResponse *httpResponse = [[YRHttpResponse alloc] initWithResponseObject:cacheData
                                                                               statusCode:0
                                                                                  message:nil
                                                                                    error:nil
                                                                                  isCache:YES
                                                                              requestType:YRHttpRequestTypeCache
                                                                                     task:nil];
            completion(httpResponse);
        }
    }
}

/**
 * 保存缓存数据到文件中
 */
- (void)saveCacheData:(id) data filePath:(NSString *) url params:(NSDictionary *) params {
    NSString *txtPath = [self cacheFilePath:url params:params]; // 文件保存路径
    if ([data isKindOfClass:[NSDictionary class]]) {
        BOOL result = [data writeToFile:txtPath atomically:YES];
        NSLog(@"缓存 %d", result);
    }
}

/**
 * 根据URL获取对应的缓存文件路径
 */
- (NSString *)cacheFilePath:(NSString *) url params:(NSDictionary *) params {
    // 获取Library/Preferences目录
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,   YES) objectAtIndex:0];
    NSString *dir = [rootPath stringByAppendingPathComponent:@"Preferences"];
    
    NSString *userIdentifier = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    if (self.configuration && [self.configuration respondsToSelector:@selector(userIdentifier)]) {
        userIdentifier = [self.configuration userIdentifier];
    }
    
    NSString *appCacheDir = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"YRAppCacheData/%@", userIdentifier]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    BOOL isExist = [fileManager fileExistsAtPath:appCacheDir isDirectory:&isDir];
    if (!(isDir && isExist)) {
        [fileManager createDirectoryAtPath:appCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fileName = [self cacheFileName:url params:params];
    NSString *txtPath = [appCacheDir stringByAppendingPathComponent:fileName]; // 文件保存路径
    
    return txtPath;
}


- (NSString *)cacheFileName:(NSString *) url params:(NSDictionary *) params {
    NSString *newUrl = [url copy];
    
    if (![newUrl hasPrefix:@"/"]) {
        newUrl = [NSString stringWithFormat:@"/%@", newUrl];
    }
    
    NSMutableString *paramStr = [NSMutableString string];
    NSArray *allKey = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    if (allKey.count > 0) {
        [paramStr appendString:@"?"];
    }
    for (NSString *key in allKey) {
        [paramStr appendFormat:@"%@=%@", key, params[key]];
        
        if (![[allKey lastObject] isEqualToString:key]) {
            [paramStr appendString:@"&"];
        }
    }
    
    // 拼成完整的URL
    NSString *baseUrl = @"";
    if (self.configuration && [self.configuration respondsToSelector:@selector(baseUrl)]) {
        baseUrl = [[self.configuration baseUrl] absoluteString];
    }
    
    
    newUrl = [NSString stringWithFormat:@"%@%@%@", baseUrl, newUrl, paramStr];
    NSString *fileName = [NSString stringWithFormat:@"%@.txt", [self md5String:newUrl]];
    return fileName;
}

- (NSString *) md5String:(NSString *) text {
    NSData * md5Data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(md5Data.bytes, (CC_LONG)md5Data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


@end

