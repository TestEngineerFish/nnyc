//
//  YRWebViewJSBridge.m
//  pyyx
//
//  Created by sunwu on 2018/6/21.
//  Copyright © 2018年 朋友印象. All rights reserved.
//

#import "YRWebViewJSBridge.h"
#import "YRWebViewJSAction.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

/** 容器，可变数组，用于保存创建的JSAction对象  */
static NSMutableArray<YRWebViewJSAction *> *jsActionContainer;


@implementation YRWebViewJSBridge

#pragma mark - ################# Public method #################

/**
 * 方法被调用时的处理
 */
- (void)onScriptMessageHandler:(NSString *)message {

    // 将JSon字符串转换成字典
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *messageBody = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    // 出错判断
    if (err) {
        NSLog(@"Json字符串转字典， 解析出错");
        return;
    }
    
    /*解析 action    callBack   params 三个参数  */
    NSString *action = messageBody[@"action"];
    NSString *callback = messageBody[@"callback"];
    NSDictionary *params = messageBody[@"params"];

    // 实例化JSAction
    YRWebViewJSAction * jsAction = (YRWebViewJSAction*)[self createJSAction:action];
    
    [jsAction setJsBridge:self];
    
    // 参数设置
    [jsAction setParams:params callback:callback];
    // 调用执行动作方法
    [jsAction action];
    
#if 0
    // 创建保存jsAction对象的数组
    [self jsActionContainer];
    // 将创建的jsAction对象保存到容器中
    [self storeNewJSActionIntoContaninerWith:jsAction];
    // 调用释放jsAction对象的方法
    [self dismissJSActionWith:jsAction];
    
#else
#endif
    
}

/**
 *  实现保存jsAction对象容器的方法
 */
- (void)jsActionContainer {
    if (!jsActionContainer) {
        jsActionContainer = [[NSMutableArray alloc] init];
        NSLog(@"*****************************************************************\n");
        NSLog(@"####创建了一个新的容器对象：%@，内存地址：%p", jsActionContainer, &jsActionContainer);
        NSLog(@"*****************************************************************\n");
    } else {
        NSLog(@"*****************************************************************\n");
        NSLog(@"###已经存在一个容器对象：%@，\n当前容器内jsAction对象个数：%lu，内存地址：%p", jsActionContainer, jsActionContainer.count, &jsActionContainer);
        NSLog(@"*****************************************************************\n");
    }
}

/**
 *  将新创建的jsAction对象放入容器中，删除过早创建的jsAction对象
 *  同时根据业务需求来确定容器中需要保存的jsAction对象的数目
 *  【问题】如果容器中剩余jsAction是同一个类的对象，怎么解决？
 @param newJSAction 新创建的jsAction对象
 */
- (void)storeNewJSActionIntoContaninerWith:(YRWebViewJSAction *)newJSAction {
    // 遍历数组，检查容器中是否已经存在了新创建的jsAction对象的相同类的对象
    for (YRWebViewJSAction *jsAction in jsActionContainer) {
        // 如果存在，则删除之前创建的jsAction对象
        if ([newJSAction.class isEqual:jsAction.class]) {
            [jsActionContainer removeObject:jsAction];
            // 如果当前容器中jsAction对象数目不低于5个，继续查找；否则跳出循环
            if (jsActionContainer.count >=5) {
                continue;
            } else {
                break;
            }
        }
    }
    
    // 将新创建的jsAction对象添加到容器中
    [jsActionContainer addObject:newJSAction];
}

/** 业务完成后，释放jsAction对象 */
- (void)dismissJSActionWith:(YRWebViewJSAction *)newJSAction {
    NSLog(@"*****************************************************************\n");
    NSLog(@"###当前被释放的jsAction对象是：%@", newJSAction);
    NSLog(@"*****************************************************************\n");

    [jsActionContainer removeObject:newJSAction];
}

/**
 *  通过协议的方式，根据action构建JSAction类对象方法
 */
- (nullable id<YRWebViewJSActionDelegate>)createJSAction:(NSString *)action {
    
    // 如果代理当前对象的代理存在且响应了代理方法
    // 面向协议方法处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(relationActionHandleClass)]) {
        NSDictionary<NSString *, Class<YRWebViewJSActionDelegate>> *_relationActionHandleClass = [self.delegate relationActionHandleClass];
        Class _actionClass = _relationActionHandleClass[action];
        id<YRWebViewJSActionDelegate> _actionInstanse = [[_actionClass alloc] init];
        
        return _actionInstanse;
    }
    
    return nil;
}

@end
