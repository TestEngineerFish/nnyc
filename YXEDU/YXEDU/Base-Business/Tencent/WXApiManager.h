//
//  WXApiOperation.h
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChatType) {
    ChatSession, // 好友
    ChatTimeline, // 朋友圈
    ChatFavorite, // 收藏
};

typedef void (^wxFinishBlock) (id obj, BOOL result);

@interface WXApiManager : NSObject

@property (nonatomic, copy) wxFinishBlock finishBlock;

+ (instancetype)shared;

- (void)registerWX:(NSString *)appid;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)wxLogin;

- (BOOL)wxIsInstalled;

- (void)sharedWX;
@end
