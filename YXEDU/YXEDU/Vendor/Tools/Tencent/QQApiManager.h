//
//  QQApiManager.h
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApiManager.h"

typedef NS_ENUM(NSInteger, QQShareType) {
    QQShareFriend,
    QQShareQZone,
};

typedef void (^qqFinishBlock) (id obj1, id obj2, BOOL result);

@interface QQApiManager : NSObject

@property (nonatomic, copy) qqFinishBlock finishBlock;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

+ (instancetype)shared;

- (void)registerQQ:(NSString *)appid;

- (void)qqLogin;

- (BOOL)qqIsInstalled;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)qqShare:(QQShareType)shareType;

- (void)shareImage:(UIImage *)image
        toPaltform:(YXSharePalform)platform
             title:(NSString *)title
      describution:(NSString *)desc
     shareBusiness:(NSString *)shareBusiness;

- (void)shareUrl:(NSString *)urlStr
    previewImage:(UIImage *)image
           title:(NSString *)title
    describution:(NSString *)desc
   shareBusiness:(NSString *)shareBusiness;

- (void)shareText:(NSString *)text;
@end
