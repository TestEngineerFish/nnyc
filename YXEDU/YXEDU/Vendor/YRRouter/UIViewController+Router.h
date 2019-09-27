//
//  UIViewController+Router.h
//  pyyx
//
//  Created by sunwu on 2017/10/13.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * *****************************************************************
 * 对 UIViewController 基类进行扩展，增加使用路由跳转方式所需要的相关属性参数
 *
 * Router 扩展属性如下：
 * 1. params
 * 2. query
 * 3. url
 * 详情见属性定义。
 * *****************************************************************
 */
@interface UIViewController (Router)

/** 存储通过外部scheme传递进来的参数 */
@property (nonatomic, strong) NSDictionary          *params;

/** 存储内部调用方式传递进来的参数， 如果是使用scheme方式进来， query等同于params */
@property (nonatomic, strong) NSDictionary          *query;

/** 当前ViewController 关联对应的Scheme url，例如：pyyx://global/browser */
@property (nonatomic, strong) NSURL                 *url;


/**
 * 根据url创建ViewController
 * @param   url     页面的url
 * @return  对应的ViewController对象
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 * 根据url创建ViewController
 * @param   url     页面的url
 * @param   query   所需要的参数
 * @return  对应的ViewController对象
 */
- (instancetype)initWithURL:(NSURL *)url query:(NSDictionary *)query;

/**
 * 创建ViewController后设置 url和query参数
 * @param   url     页面的url
 * @param   query   所需要的参数
 */
- (void)setURL:(NSURL *)url query:(NSDictionary *)query;

/**
 * 抽象方法，当子类有接受参数时，可以重写该方法，通过query获取相应参数
 * 此方法非必须，不重写也可以通过 self.query 或 self.param 获取相应参数
 */
- (void)handleDataWithQuery:(NSDictionary *) query;

/**
 * 根据storyboard创建ViewController
 * @param   sbname       storyboard文件名
 * @param   identifier   VC的标示名称
 * @return  对应的ViewController对象
 */
+ (UIViewController *)storyboardWithName:(NSString *)sbname identifier:(NSString *)identifier;

@end
