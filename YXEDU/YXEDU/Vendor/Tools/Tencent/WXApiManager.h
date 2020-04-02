//
//  WXApiOperation.h
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXSharePalform) {
    YXShareWXSession,
    YXShareWXTimeLine,
    YXShareQQ
};

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

//- (void)sharedWX;

- (void)shareImage:(UIImage *)image
        toPaltform:(YXSharePalform)platform
             title:(NSString *)title
      describution:(NSString *)desc
      shareBusiness:(NSString *)shareBusiness;

- (void)shareUrl:(NSString *)url
      toPaltform:(YXSharePalform)platform
    previewImage:(UIImage *)image
           title:(NSString *)title
     description:(NSString *)desc
   shareBusiness:(NSString *)shareBusiness;

- (void)shareText:(NSString *)text
       toPaltform:(YXSharePalform)platform;
@end
