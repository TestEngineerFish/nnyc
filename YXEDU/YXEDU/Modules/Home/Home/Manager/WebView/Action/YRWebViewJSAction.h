//
//  YRWebViewJSAction.h
//  pyyx
//
//  Created by sunwu on 2018/6/21.
//  Copyright © 2018年 朋友印象. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 动作类型枚举 */
typedef NS_ENUM(NSInteger, YRWebViewJSActionType) {
    YRWebViewJSActionTypeCheckInstall,
    YRWebViewJSActionTypeShare
};


/** 定义Action动作的协议 */
@protocol YRWebViewJSActionDelegate <NSObject>
@required
/**
 * 定义所有的Action类型必须执行的动作，该方法中实现具体业务
 */
- (void)action;

@end


/**
 * JSAction 基类，所有JSAction必须继承自该类，并且实现 action 方法；
 */
@class YRWebViewJSBridge;
@interface YRWebViewJSAction : NSObject <YRWebViewJSActionDelegate>

/** 桥接对象，用于Action执行H5页面的函数回调 */
@property (nonatomic, weak) YRWebViewJSBridge *jsBridge;

/** 当前Action是什么类型*/
@property (nonatomic, assign) YRWebViewJSActionType actionType;

/** 当前Action需要的参数*/
@property (nonatomic, strong) NSDictionary *params;

/** 当前Action需要的回调函数*/
@property (nonatomic, copy) NSString *callback;

/** 非初始化方法，只是为了设置相关的属性 */
- (YRWebViewJSAction *)setParams:(NSDictionary *)params callback:(NSString *) callback;

/**
 * 释放当前的Action对象
 * 各业务场景不用取独立释放
 */
- (void)dissmisAction;

@end
