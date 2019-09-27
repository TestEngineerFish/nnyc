//
//  UIViewController+Router.m
//  pyyx
//
//  Created by sunwu on 2017/10/13.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import "UIViewController+Router.h"

#import "NSString+Router.h"
#import <objc/runtime.h>

static const void * kParamsKey = &kParamsKey;
static const void * kQueryKey = &kQueryKey;
static const void * kUrlKey = &kUrlKey;

@interface UIViewController()

@end

@implementation UIViewController (Router)

#pragma -mark ********************* get and set *********************
- (NSDictionary *)params {
    return objc_getAssociatedObject(self, kParamsKey);
}
- (void)setParams:(NSDictionary *)params {
    objc_setAssociatedObject(self, kParamsKey, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSDictionary *)query {
    return objc_getAssociatedObject(self, kQueryKey);
}
- (void)setQuery:(NSDictionary *)query {
    objc_setAssociatedObject(self, kQueryKey, query, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSURL *)url {
    return objc_getAssociatedObject(self, kUrlKey);
}
- (void)setUrl:(NSURL *)url {
    objc_setAssociatedObject(self, kUrlKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma -mark ********************* init *********************
- (instancetype)initWithURL:(NSURL *)aUrl {
    return [self initWithURL:aUrl query:nil];
}

- (instancetype)initWithURL:(NSURL *)aUrl query:(NSDictionary *)aQuery {
//    self = [self initWithNibName:nil bundle:nil];
    self = [self init];
    if (self) {
        self.url = aUrl;
        self.params = [aUrl.absoluteString params];
        self.query = aQuery;
        
        if(!aQuery) self.query = self.params;
        
        [self handleDataWithQuery:self.query];
    }
    return self;
}

- (void)setURL:(NSURL *)aUrl query:(NSDictionary *)aQuery {
    self.url = aUrl;
    self.params = [aUrl.absoluteString params];
    self.query = aQuery;
    
    if(!aQuery) self.query = self.params;
    
    [self handleDataWithQuery:self.query];
}

- (void)handleDataWithQuery:(NSDictionary *) query {
    
}

+ (UIViewController *)storyboardWithName:(NSString *)sbname identifier:(NSString *)identifier {
    NSParameterAssert(sbname != nil
                      && sbname.length > 0
                      && identifier != nil
                      && identifier.length > 0);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbname bundle:nil];
    UIViewController *controller = [sb instantiateViewControllerWithIdentifier:identifier];
    return controller;
}

@end
