//
//  YRHttpTask.m
//  YRHttpManager
//
//  Created by sunwu on 2018/2/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "YRHttpTask.h"

@interface YRHttpTask()

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, assign) NSUInteger identifier;

@property (nonatomic, strong) NSURLRequest *request;

@end


@implementation YRHttpTask

- (instancetype)initWithTask:(NSURLSessionTask *) task
                     withUrl:(NSString *) url
                  withParams:(NSDictionary *)params
                  withHeader:(NSDictionary *) header {
    
    if (self = [super init]) {
        self.task = task;
        self.url = url;
        self.params = params;
        self.header = header;
        self.identifier = task.taskIdentifier;
        self.request = task.originalRequest;
        self.taskStatus = YRHttpTaskStatusExecuting;
    }
    return self;
    
}
- (void)cancel {
    [self.task cancel];
    self.taskStatus = YRHttpTaskStatusFinish;
    
    // 结束后，没有从集合容器中删除 Task
}

/**
 * 是否在请求中
 */
- (BOOL)isExecuting {
    return self.taskStatus == YRHttpTaskStatusExecuting;
}
@end

