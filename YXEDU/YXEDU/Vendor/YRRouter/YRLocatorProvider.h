//
//  YRLocatorProvider.h
//  pyyx
//
//  Created by sunwu on 2017/10/13.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * ****************************************************
 * 页面URL管理类，管理所有ViewController和对应的URL地址
 *
 * 提供根据URL实例化对应的ViewController的方法，支持3种方式：
 * 1. 纯代码创建 ViewController 页面
 * 2. storyboard 创建 ViewController 页面
 * 3. xib 创建 ViewController 页面
 *
 * ****************************************************
 */
@interface YRLocatorProvider : NSObject

/**
 * 全局统一的URL管理器
 */
+ (YRLocatorProvider *)sharedInstance;

/**
 * 处理url
 * 1. 如果是NSString 类型，转换成NSURL类型
 *
 * 2. 如果没有Scheme头，自动补充上自定义的Scheme头
 *    例如: user/homepage,转成pyyx://com.xxx/user/homepage
 *
 * @prarm   url     要处理的url地址，可以是NSString类型，也可以是NSURL类型
 * @return     返回带Scheme头的NSURL对象
 */
- (NSURL *)processURL:(id) url;

/**
 * 根据URL返回对应的ViewController 对象
 * @param   url     url地址，可以是自定义scheme地址，也可以是http或者https地址
 * @param   query   页面所需要的参数，当前为字典类型
 */
- (UIViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query;

/**
 * 根据URL返回对应的ViewController名称字符串
 */
- (NSString *)viewControllerStringWithURL:(NSURL *) url;

@end
