//
//  YXMediator.h
//  YXEDU
//
//  Created by shiji on 2018/3/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YXMediator : NSObject
@property (weak, nonatomic) UIWindow *window;
+ (instancetype)shared;

- (void)configure;

- (void)afterLogout;

- (void)showMainVC;

- (void)showSelectVC;

- (void)showLoginVC;

- (void)showGuideView;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)registerDeviceToken:(NSData *)deviceToken;
@end
