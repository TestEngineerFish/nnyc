//
//  QQApiManager.m
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "QQApiManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "Growing.h"

@interface QQApiManager () <TencentSessionDelegate,QQApiInterfaceDelegate>
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, copy)NSString *shareBusiness;
@end

@implementation QQApiManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)shared {
    static QQApiManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [QQApiManager new];
    });
    return shared;
}

- (void)registerQQ:(NSString *)appid {
    //初始化SDK
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];
}

- (void)qqLogin {
    //设置应用需要用户授权的API列表
    NSArray *_permissions =  [NSArray arrayWithObjects:
                              kOPEN_PERMISSION_GET_USER_INFO,
                              kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                              kOPEN_PERMISSION_ADD_ALBUM,
                              //                              kOPEN_PERMISSION_ADD_IDOL,
//                              kOPEN_PERMISSION_ADD_ONE_BLOG,
                              //                              kOPEN_PERMISSION_ADD_PIC_T,
//                              kOPEN_PERMISSION_ADD_SHARE,
                              kOPEN_PERMISSION_ADD_TOPIC,
                              kOPEN_PERMISSION_CHECK_PAGE_FANS,
                              //                              kOPEN_PERMISSION_DEL_IDOL,
                              //                              kOPEN_PERMISSION_DEL_T,
                              //                              kOPEN_PERMISSION_GET_FANSLIST,
                              //                              kOPEN_PERMISSION_GET_IDOLLIST,
                              kOPEN_PERMISSION_GET_INFO,
                              kOPEN_PERMISSION_GET_OTHER_INFO,
                              //                              kOPEN_PERMISSION_GET_REPOST_LIST,
                              kOPEN_PERMISSION_LIST_ALBUM,
                              kOPEN_PERMISSION_UPLOAD_PIC,
                              kOPEN_PERMISSION_GET_VIP_INFO,
                              kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                              //                              kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                              //                              kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                              nil];
    //调用SDK登录
    [_tencentOAuth authorize:_permissions inSafari:YES];
}

// qq 分享
- (void)qqShare:(QQShareType)shareType {
    if (![QQApiInterface isQQInstalled]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装QQ客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionConfirm];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        return;
    }
    QQApiObject *apiObj = nil;
    apiObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"https://www.baidu.com/s?rsv_idx=2&tn=baiduhome_pg&wd=%E7%A0%81%E5%86%9C&usm=2&ie=utf-8&rsv_cq=&rsv_dl=0_top_relation_28310&cq=ios%20%E5%BE%AE%E4%BF%A1%E5%88%86%E4%BA%AB&srcid=28310&rt=%E7%9B%B8%E5%85%B3%E8%AF%8D%E6%B1%87&recid=21102&euri=5d87626fee2f43b197a4722eca3c7faa"] title:@"uuuuuuu" description:@"eeeeeeee" previewImageURL:[NSURL URLWithString:@"https://www.baidu.com/s?rsv_idx=2&tn=baiduhome_pg&wd=%E7%A0%81%E5%86%9C&usm=2&ie=utf-8&rsv_cq=&rsv_dl=0_top_relation_28310&cq=ios%20%E5%BE%AE%E4%BF%A1%E5%88%86%E4%BA%AB&srcid=28310&rt=%E7%9B%B8%E5%85%B3%E8%AF%8D%E6%B1%87&recid=21102&euri=5d87626fee2f43b197a4722eca3c7faa"]];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:apiObj];
    QQApiSendResultCode sent;
    if (shareType == QQShareFriend) {
        sent = [QQApiInterface sendReq:req];
    } else {
        sent = [QQApiInterface SendReqToQZone:req];
    }
    switch (sent) {
        case EQQAPISENDSUCESS:
            {
                
            }
            break;
            
        default:
            break;
    }
}


- (BOOL)handleOpenURL:(NSURL *)url {
    [QQApiInterface handleOpenURL:url delegate:self]; //处理由手Q唤起的跳转请求
    return [TencentOAuth HandleOpenURL:url];
}

#pragma mark -TencentSessionDelegate-
//登录成功
- (void)tencentDidLogin {
    [Growing track:kGrowingTracePlatformLoginResult withVariable:@{@"platform_result":@"", @"platform_type":@"QQ"}];
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]) {
        self.finishBlock(_tencentOAuth.accessToken,_tencentOAuth.openId, YES);
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"%@",_tencentOAuth.accessToken);

//        [[NSNotificationCenter defaultCenter]postNotificationName:@"CompletedBind" object:@"qq" userInfo:@{@"token":_tencentOAuth.accessToken, @"openID":_tencentOAuth.openId}];
        
    } else {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

//非网络错误导致登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"用户取消登录");
    } else {
        NSLog(@"登录失败");
    }
}

//网络错误导致登录失败
-(void)tencentDidNotNetWork {
    NSLog(@"无网络连接，请设置网络");
    
}


// 处理来至QQ的请求
- (void)onReq:(QQBaseReq *)req {
    NSLog(@" ----req %@",req);
}


//处理来至QQ的响应
- (void)onResp:(QQBaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        if (resp.type == ESENDMESSAGETOQQRESPTYPE) {
            NSString *des = [NSString stringWithFormat:@"%@-%@",kPlatformQQ,self.shareBusiness];
            [MobClick event:kTracePunchCardResult attributes:@{kTraceDescKey : des}];
            
            if ([resp.result isEqualToString:@"0"]){
                [YXUtils showHUD:nil title:@"分享成功！"];
            }
            else{
                [YXUtils showHUD:nil title:@"分享未成功！"];
            }
        }
    }
    NSLog(@" ----resp %@",resp);
}

#pragma mark - share

- (void)shareImage:(UIImage *)image
        toPaltform:(YXSharePalform)platform
             title:(NSString *)title
      describution:(NSString *)desc
     shareBusiness:(NSString *)shareBusiness
{
    self.shareBusiness = shareBusiness;
    NSData *oriData = UIImageJPEGRepresentation(image, 0.8);
    NSData *thumData = UIImageJPEGRepresentation(image, 0.5);
    
    QQApiImageObject *imageObj = [QQApiImageObject objectWithData:oriData
                                                 previewImageData:thumData
                                                            title:title
                                                      description:desc];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObj];
    QQApiSendResultCode retCode = [QQApiInterface sendReq:req];
    NSLog(@"%d",retCode);
}

- (void)shareText:(NSString *)text {
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    NSLog(@"%d",sent);
}
@end
