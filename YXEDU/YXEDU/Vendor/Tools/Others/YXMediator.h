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

/** 用户被挤掉
 * @version 2.0.0
 */
- (void)userKickedOut;

- (BOOL)handleOpenURL:(NSURL *)url;

-(BOOL)handleOpenUnivrsalLinkURL:(NSUserActivity *)userActivity;

@end
