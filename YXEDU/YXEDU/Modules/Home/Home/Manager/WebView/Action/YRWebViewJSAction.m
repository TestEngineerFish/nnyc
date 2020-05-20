//
//  YRWebViewJSAction.m
//  pyyx
//
//  Created by sunwu on 2018/6/21.
//  Copyright © 2018年 朋友印象. All rights reserved.
//

#import "YRWebViewJSAction.h"

/*
 * Action 队列，防止被提前释放，当JSBridge被释放时，需要清空队列中所有的Action对象
 */
static NSMutableArray<YRWebViewJSAction *> *jsActionArray;

@implementation YRWebViewJSAction


- (instancetype)init {
    if (self = [super init]) {
        if (!jsActionArray)
            jsActionArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (YRWebViewJSAction *)setParams:(NSDictionary *)params callback:(NSString *) callback {
    self.params = params;
    self.callback = callback;
    
    return self;
}

/**
 * 执行动作，基类实现，如果子类没有异步处理，可以不用调 [super action];
 */
- (void)action {

#if 1
    // 当容器里面有相同的Action类型，把老的Action对象删除释放掉
    YRWebViewJSAction *oldSameAction;
    for (YRWebViewJSAction *action in jsActionArray) {
        if ([NSStringFromClass(action.class) isEqualToString:NSStringFromClass(self.class)]) {
            oldSameAction = action;
            break;
        }
    }
    if (oldSameAction) {
        [jsActionArray removeObject:oldSameAction];
        oldSameAction = nil;
    }
    
    // 考虑到目前的实际场景，容器中目前只放3个
    if (jsActionArray.count >= 5) {
        [jsActionArray removeObjectAtIndex:0];
    }
    
    // 把action放到队列中，当业务场景使用完毕时，从队列中移除并销毁掉
    [jsActionArray addObject:self];
#else
#endif
}

/**
 * 释放当前的Action对象
 */
- (void)dissmisAction {
    [jsActionArray removeObject:self];
}


@end
