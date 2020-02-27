//
//  YRLocatorProvider.m
//  pyyx
//
//  Created by sunwu on 2017/10/13.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import "YRLocatorProvider.h"
#import "UIViewController+Router.h"
//#import "YRWebViewController.h"

//static NSString * const kPyyx_scheme = @"pyyx";
//#define kPYYXAppScheme [NSString stringWithFormat:@"%@://com.pyyx/", kPyyx_scheme]
static NSString * const kPYYXAppScheme = @"nnyc://com.nnyc/";


/** URL 和 ViewController对应关系，key为url，value为ViewController */
static NSMutableDictionary *locatorMap;
/** ViewController对象在哪个storyboard文件下，key为ViewController字符串标识，value为storyboard文件名称 */
static NSMutableDictionary *sbMap;

@interface YRLocatorProvider() {
}
@end


@implementation YRLocatorProvider

+ (YRLocatorProvider *)sharedInstance {
    static YRLocatorProvider *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if(self = [super init]) {
        if (nil == locatorMap) {
            locatorMap = [[NSMutableDictionary alloc] init];
            sbMap = [[NSMutableDictionary alloc] init];
            
            [self loadLocatorMap];
        }
        return self;
    }
    return nil;
}

#pragma mark - ****************** Public method ******************

- (NSURL *)processURL:(id) url {
    NSString *newUrl = nil;
    
    if ([url isKindOfClass:[NSURL class]]) {
        newUrl = [url absoluteString];
    } else if([url isKindOfClass:[NSString class]]){
        newUrl = [NSString stringWithString:url];
    }
    
    if ([newUrl hasPrefix:kPYYXAppScheme] == NO) {
        newUrl = [NSString stringWithFormat:@"%@%@", kPYYXAppScheme, newUrl];
    }
    
    newUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:newUrl];
}

/**
 * 根据URL返回对应的ViewController 对象
 * @param   url     url地址，可以是自定义scheme地址，也可以是http或者https地址
 * @param   query   页面所需要的参数，当前为字典类型
 */
- (UIViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query {
    UIViewController * viewController = nil;
    
    // 处理url,去掉有可能会拼接的参数，例如： scheme://host/path?param=1, 把?param=1去掉
    NSString *newUrl = [self removeURLParameter:url];
    
    if ([self isURLAvailable:[NSURL URLWithString:newUrl]]) {
        NSString *vcString = [locatorMap objectForKey:newUrl];
        
        if ([sbMap objectForKey:vcString]) {// storyboard UI
            
            viewController = [UIViewController storyboardWithName:sbMap[vcString] identifier:vcString];
            [viewController setURL:url query:query];
            
        } else {// xib或者纯代码UI
            
            Class class = NSClassFromString(vcString);
            if (class == nil) {
                class = NSClassFromString([NSString stringWithFormat:@"YXEDU.%@",vcString]);
            }
            if (nil == query) {
                viewController = [[class alloc] initWithURL:url];
            } else {
                viewController = [[class alloc] initWithURL:url query:query];
            }
            
        }
        
    } else if ([@"http" isEqualToString:[url scheme]] || [@"https" isEqualToString:[url scheme]]) {
//        viewController = [[YRWebViewController alloc] initWithURL:url query:query];
    }
    return viewController;
}

- (NSString *)viewControllerStringWithURL:(NSURL *) url {
    // 处理url,去掉有可能会拼接的参数，例如： scheme://host/path?param=1, 把?param=1去掉
    NSString *newUrl = [self removeURLParameter:url];
    NSString *vcString = [locatorMap objectForKey:newUrl];
    return vcString;
}

#pragma mark - ****************** Private method ******************
/**
 * 加载所有的UIViewController
 */
- (void)loadLocatorMap
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"vcmap" ofType:@"plist"];
    NSDictionary *locatorDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *allKey = [locatorDictionary allKeys];
    
    for (NSString *key in allKey) {
        if ([key isEqualToString:@"storyboard"]) {
            
            //所有的storyboard文件
            NSDictionary *allSBDict = locatorDictionary[@"storyboard"];
            
            //所有的storyboard文件名称
            NSArray *sbFileNameKeyArray = [allSBDict allKeys];
            
            for (NSString *sbFileNameKey in sbFileNameKeyArray) {
                //单个sb文件
                NSDictionary *sbDict = allSBDict[sbFileNameKey];
                
                //单个sb文件下，所有的vc key
                NSArray *vcKeyArray = [sbDict allKeys];
                
                for (NSString *vcKey in vcKeyArray) {
                    
                    NSString *newKey = [NSString stringWithFormat:@"%@%@", kPYYXAppScheme, vcKey];
                    id value = [sbDict objectForKey:vcKey];
                    [locatorMap setObject:value forKey:newKey];
                    
                    [sbMap setObject:sbFileNameKey forKey:value];
                }
                
            }
            
        } else {
            
            NSString *newKey = [NSString stringWithFormat:@"%@%@", kPYYXAppScheme, key];
            id value = [locatorDictionary objectForKey:key];
            [locatorMap setObject:value forKey:newKey];
        }
    }
    //[locatorMap setValuesForKeysWithDictionary:locatorDictionary];
}

/**
 * 检查url是否存在
 */
- (BOOL)isURLAvailable:(NSURL *)url {
    NSString *urlString = [url absoluteString];
    return [locatorMap objectForKey:urlString] != nil;
}

/**
 * 处理url,去掉有可能会拼接的参数，例如： scheme://host/path?param=1, 把?param=1去掉
 */
- (NSString *)removeURLParameter:(NSURL *) url {
    NSString *newUrl;
    if(url.path == nil){
        newUrl = [NSString stringWithFormat:@"%@://%@", url.scheme, url.host];
    }else{
        newUrl = [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host,url.path];
    }
    return newUrl;
}
@end

