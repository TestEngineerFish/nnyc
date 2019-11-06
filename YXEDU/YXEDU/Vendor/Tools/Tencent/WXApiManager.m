//
//  WXApiOperation.m
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "WXApiManager.h"
#import "WXApi.h"
#import "Growing.h"

@interface WXApiManager () <WXApiDelegate>
@property (nonatomic, copy)NSString *shareBusiness;
@property (nonatomic, assign) int scene;
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
        req.state = kWechatLogin;
        [WXApi sendReq:req];
    } else {
        [YXUtils showHUD: nil title: @"还没有安装微信，请安装后再使用微信登录"];
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
        [YXUtils showHUD: nil title: @"还没有安装微信，请安装后再使用微信登录"];
    }
}

#pragma -delegate-

-(void)onReq:(BaseReq*)req{
    NSLog(@"----");
    NSLog(@"%@",req);
}


-(void)onResp:(BaseResp*)resp {
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response = (SendAuthResp *)resp;
        NSString *code = response.code;
        if ([response.state isEqualToString:kWechatLogin]) {
            [Growing track:kGrowingTracePlatformLoginResult withVariable:@{@"platform_result":resp, @"platform_type":@"WeChat"}];
        }
//        self.finishBlock(code, YES);

//        [[NSNotificationCenter defaultCenter]postNotificationName:@"CompletedBind" object:@"wechat" userInfo:@{@"token":code}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletedBind" object:nil userInfo:@{@"platfrom":@"wechat", @"token":code}];

    }else if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSString *platform = @"";
        if (self.scene == WXSceneSession) {
            platform = kPlatformWX;
        }else if(self.scene == WXSceneTimeline){
            platform = kPlatformWXTimeLine;
        }
        NSString *des = [NSString stringWithFormat:@"%@-%@",platform,self.shareBusiness];
        [MobClick event:kTracePunchCardResult attributes:@{kTraceDescKey : des}];
        [MobClick event:kTracePunchCardResult attributes:@{kTraceDescKey : kPlatformWX}];
        SendMessageToWXResp *messageResps = (SendMessageToWXResp *)resp;
        
        if (messageResps.errCode == 0){
            [YXUtils showHUD:nil title:@"分享成功！"];
        }
        else {
            [YXUtils showHUD:nil title:@"分享未成功！"];
        }
    }
//    else if([resp isKindOfClass:[SendMessageToWXResp class]]) {
//        SendMessageToWXResp *resps = (SendMessageToWXResp *)resp;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kYXShareCallBackNotify object:nil userInfo:@{@"response" : resp}];
//    }
}

//通过code获取access_token，openid，unionid
- (void)getWXOpenId:(NSString *)code {
    //通过code获取access_token，openid，unionid：// 获取微信用户信息
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",wechatId,wechatAppSerect,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *token = dic[@"access_token"];
                NSString *openID = dic[@"openid"];
                
                if (token){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CompletedBind" object:@"wechat" userInfo:@{@"token":token, @"openID":openID}];
                }
            }
        });
    });
}

#pragma mark - share
- (void)shareImage:(UIImage *)image
        toPaltform:(YXSharePalform)platform
             title:(NSString *)title
      describution:(NSString *)desc
      shareBusiness:(NSString *)shareBusiness {
    self.shareBusiness = shareBusiness;
    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageData = UIImageJPEGRepresentation(image, 0.8);
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObj;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    sentMsg.scene = (platform == YXShareWXSession) ? WXSceneSession : WXSceneTimeline;
    self.scene = sentMsg.scene;
    [WXApi sendReq:sentMsg];
}

- (void)shareText:(NSString *)text toPaltform:(YXSharePalform)platform {
    SendMessageToWXReq * req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = platform;
    
    [WXApi sendReq:req];
}
@end
