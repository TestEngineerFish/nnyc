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
+ (instancetype)shared;
/** token失效
 * @version 1.4.0 以前
 */
- (void)afterLogout;

/** token失效
 * @version 2.0.0 begin
 */
- (void)tokenExpired;
/** 退出登陆 */
- (void)loginOut;
/** 清除登陆数据 */
- (void)clearData;

/** 用户被挤掉
 * @version 2.0.0
 */
- (void)userKickedOut;

- (BOOL)handleOpenURL:(NSURL *)url;

-(BOOL)handleOpenUnivrsalLinkURL:(NSUserActivity *)userActivity;

@end
