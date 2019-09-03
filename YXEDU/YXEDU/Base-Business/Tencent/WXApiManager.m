//
//  WXApiOperation.m
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "WXApiManager.h"
#import "WXApi.h"

@interface WXApiManager () <WXApiDelegate>

@end

@implementation WXApiManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)shared {
    static WXApiManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [WXApiManager new];
    });
    return shared;
}

- (void)registerWX:(NSString *)appid {
    [WXApi registerApp:appid enableMTA:NO];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)wxLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123";
        [WXApi sendReq:req];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionConfirm];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)wxIsInstalled {
    return [WXApi isWXAppInstalled];
}

- (void)sharedWX:(ChatType)chatType {
    enum WXScene scene;
    switch (chatType) {
        case ChatSession:
            scene = WXSceneSession;
            break;
        case ChatTimeline:
            scene = WXSceneTimeline;
            break;
        case ChatFavorite:
            scene = WXSceneFavorite;
            break;
            
        default:
            break;
    }
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.scene = scene;
        req.bText = YES;
        req.text = @"long time ";
        WXImageObject *imageObject = [WXImageObject object];
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = imageObject;
        req.message = message;
        [WXApi sendReq:req];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionConfirm];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma -delegate-
-(void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
//        [self getWXOpenId:temp.code];
        self.finishBlock(temp.code, YES);
    }
}

////通过code获取access_token，openid，unionid
//- (void)getWeiXinOpenId:(NSString *)code{
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wechatId,wechatAppSerect,code];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *zoneUrl = [NSURL URLWithString:url];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data){
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSString *openID = dic[@"openid"];
////                NSString *unionid = dic[@"unionid"];
//
//            }
//        });
//    });
//
//}

//- (void)getWXOpenId:(NSString *)code {
//    //通过code获取access_token，openid，unionid：// 获取微信用户信息
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wxdab28fb210797f6b",@"52ada40ba8d6b346b2b5e8c10051b5a8",code];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *zoneUrl = [NSURL URLWithString:url];
//        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (data){
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSString *openID = dic[@"openid"];
//                NSString *unionid = dic[@"unionid"];
//            }
//        });
//    });
//
//}


@end
