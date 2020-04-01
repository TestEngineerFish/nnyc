//
//  YRWebViewJSBridge.h
//  pyyx
//
//  Created by sunwu on 2018/6/21.
//  Copyright © 2018年 朋友印象. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol YRWebViewJSActionDelegate;

// 申明一个桥接文件的协议，用于外部传值
@protocol YRWebViewJSBridgeDelegate <NSObject>
@optional
/** 可选的协议方法，该方法从外部返回一个字典 @{@action, class ...}
 *  eg: return @{@"Share" : YRWebViewShareAction.class};
 *  在此协议中可以定义多种返回数据结构类型的方法，如返回数组等
 */
- (nullable NSDictionary<NSString *, Class<YRWebViewJSActionDelegate>> *)relationActionHandleClass;

@end


@interface YRWebViewJSBridge : NSObject

/** 浏览器，负责注入JS对象，执行JS回调函数   */
@property (nonatomic, strong) WKWebView * _Nullable webView;

/** 当前协议的代理方    */
@property (nonatomic, assign) id<YRWebViewJSBridgeDelegate> _Nullable delegate;

/**
 *  唯一对外接口，方法被调用时的处理
 */
- (void)onScriptMessageHandler:(NSString *_Nullable)message;

@end
