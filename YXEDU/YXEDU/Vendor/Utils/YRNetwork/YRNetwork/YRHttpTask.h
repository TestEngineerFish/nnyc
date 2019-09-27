//
//  YRHttpTask.h
//  YRHttpManager
//
//  Created by sunwu on 2018/2/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * 任务状态
 */
typedef NS_ENUM(NSInteger, YRHttpTaskStatus) {
    YRHttpTaskStatusFinish,
    YRHttpTaskStatusExecuting
};


@interface YRHttpTask : NSObject

@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) NSDictionary *header;
@property (nonatomic, assign, readonly) NSUInteger identifier;
@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, assign) YRHttpTaskStatus taskStatus;

/**
 * 构建Task【由YRNetworkManager创建请求时进行构建】，业务使用方法不需要创建该对象
 */
- (instancetype)initWithTask:(NSURLSessionTask *) task
                     withUrl:(NSString *) url
                  withParams:(NSDictionary *)params
                  withHeader:(NSDictionary *) header;

/**
 * 取消网络任务请求，业务方进行调用
 */
- (void)cancel;

/**
 * 是否在请求中
 */
- (BOOL)isExecuting;
@end

