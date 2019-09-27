//
//  YRNetworkManager+Cache.h
//  YRNetwork
//
//  Created by pyyx on 2018/3/6.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "YRNetworkManager.h"

typedef NS_ENUM(NSInteger, YRDataType) {
    YRDataTypeCache         = 0,
    YRDataTypeNetwork
};

@interface YRNetworkManager (Cache)

/**
 * 读取缓存数据
 */
- (void)readCacheData:(NSString *) url
               params:(NSDictionary *) params
                cache:(BOOL) cache
              completion:(YRHttpCompletion) completion;



/**
 * 保存缓存数据到文件中
 */
- (void)saveCacheData:(NSDictionary *)data
             filePath:(NSString *)url
               params:(NSDictionary *)params;

@end
