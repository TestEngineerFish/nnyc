//
//  YRRouter.h
//  YRRouter
//
//  Created by sunwu on 2018/6/20.
//  Copyright © 2018年 朋友印象. All rights reserved.
//

#import "YRLocatorProvider.h"
#import "UIViewController+Router.h"

/**
 * *****************************************************************
 * 页面路由管理类，加载所有ViewController页面
 * 根据URL跳转到相应的ViewController，支持push和present。
 *
 * 一、路由器的使用场景：
 * 1. App内部跳转到指定的页面
 * 2. Native+H5混编，H5页面跳转到指定的Native页面
 * 3. 推送消息拉起App到指定的页面
 * 4. 外部的任意Scheme拉起App到指定的页面
 *
 * 二、使用方法示例：
 * 1. 内部跳转
 * [YRRouter openURL:@"user/homepage" query:@{@"userId" : @1} animated:YES];
 * 其中：
 * user/homepage 为用户主页的url
 * userId为页面需要的相关参数
 *
 * 2. H5、推送或者Scheme【推送消息需要做点小的处理，解析出自定义的整个scheme】
 * pyyx://com.pyyx/user/homepage?userId=1&other=xxxxx
 * 其中：
 * pyyx://com.pyyx 为我们App自定义的Scheme头部
 * user/homepage 为用户主页（ViewController）的url,
 * userId为页面需要的相关参数
 *
 *
 * **（注意：present转场动画目前只支持默认方式，如有业务上更多动画需求，需要进行扩展）
 * *****************************************************************
 */
@interface YRRouter : NSObject


/**
 * 全局统一路由管理器， 此方法可能意义不大了，因为Router大部分都定义成了类方法
 */
+ (instancetype _Nonnull )sharedInstance;

/**
 * 返回当前控制器
 */
- (UIViewController *_Nullable)currentViewController;

/**
 * 返回当前的导航控制器
 */
- (UINavigationController*_Nullable)currentNavigationController;

/**
 * 根据URL返回对应的ViewController
 * @param   url     url地址，可以是自定义scheme地址，也可以是http或者https地址
 * @param   query   页面所需要的参数，当前为字典类型
 */
+ (UIViewController * _Nullable)viewControllerForURL:(id _Nonnull)url withQuery:(NSDictionary *_Nullable)query;


#pragma -mark *************************** push or present ****************************
// 建议使用 open URL方法，push和present方法虽然语义更直观，但从打开页面统一性上，open URL更有意义，因此屏蔽相关方法
/*
 - (void)push:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated;
 - (void)push:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated completion:(void(^)()) completion;
 
 - (void)present:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated;
 - (void)present:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated completion:(void(^)()) completion;
 */



// ***********************************************************************
// 以下方法定义为类方法，主要是方便使用，sharedInstance方法可能就没多大意义了
// ***********************************************************************
#pragma -mark *************************** open URL ****************************

/*
 * 打开指定页面（ViewController）， 该方法为 push 方式
 * @param   url         页面地址
 * @param   query       页面所需参数
 * @param   animated    是否需要动画打开
 */
+ (void)openURL:(NSString *_Nonnull) url query:(NSDictionary * _Nullable) query animated:(BOOL) animated;


/*
 * 打开指定页面（ViewController）， 该方法为支持 push 和 present 方式
 * @param   url         页面地址
 * @param   query       页面所需参数
 * @param   modal       页面打开方式，当为NO时是push方式，当为YES是present方式
 * @param   animated    是否需要动画打开， YES为动画
 */
+ (void)openURL:(NSString *_Nonnull) url query:(NSDictionary *_Nullable) query isPresent:(BOOL)present animated:(BOOL) animated;


/*
 * 打开指定页面（ViewController）， 该方法为支持 push 和 present 方式
 * @param   url         页面地址
 * @param   query       页面所需参数
 * @param   modal       页面打开方式，当为NO时是push方式，当为YES是present方式
 * @param   animated    是否需要动画打开， YES为动画
 * @param   completion  打开页面后执行的block，可以为空
 */
+ (void)openURL:(NSString *_Nonnull) url query:(NSDictionary *_Nullable) query isPresent:(BOOL)present animated:(BOOL) animated completion:(void(^_Nullable)(void)) completion;


#pragma -mark *************************** pop ViewController ****************************
/**
 * 基于当前页面，返回上一级页面
 * @param   animated    是否需要动画打开， YES为动画
 */
+ (void)popViewController:(BOOL) animated;

/**
 * 基于当前页面，返回到指定页面
 * @param   url         VC页面对应的url
 * @param   animated    是否需要动画打开， YES为动画
 */
+ (void)popViewControllerWithURL:(NSString *_Nonnull) url animated:(BOOL) animated;


// ###############################################################
#pragma -mark ************ 以下几个方法不推荐直接使用
/**
 * 基于当前页面，返回到指定页面
 * @param   index       数字下标，返回几级
 * @param   animated    是否需要动画打开， YES为动画
 */
+ (void)popViewControllerWithIndex:(NSNumber *_Nonnull) index animated:(BOOL) animated;

/**
 * 基于当前页面，返回到指定页面
 * @param   aClass      VC对应的Class
 * @param   animated    是否需要动画打开， YES为动画
 */
+ (void)popViewControllerWithClass:(Class _Nonnull) aClass animated:(BOOL) animated;

/**
 * 基于当前页面，返回到指定页面
 * @param   string      VC对应的String
 * @param   animated    是否需要动画打开， YES为动画
 */
+ (void)popViewControllerWithString:(NSString * _Nonnull) string animated:(BOOL) animated;

/**
 * 基于当前页面，返回到指定页面
 * 该方法融合了以上根据【下标、Class、String】几个方法
 *
 * @param      target   返回到指定页面
 *
 * target类型：【1/@"UIViewController"/Class/vcObj】
 * 可以是数字下标 / 可以是ViewController的字符串类名 / 可以是ViewController的Class / 还可以是ViewController的实例对象
 *
 * 当target是数字下标时，1 为返回一级，2为返回二级，以此类推。
 * 当target是ViewController的类名、Class或者实例对象，直接返回到此ViewController。
 */
+ (void)popViewController:(id _Nonnull) target animated:(BOOL) animated;


@end
