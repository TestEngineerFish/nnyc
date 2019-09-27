//
//  YXShareView.m
//  YXEDU
//
//  Created by yao on 2018/11/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXShareView.h"
#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "YXShareHelper.h"
@implementation YXShareButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat wh = 53;
    CGFloat x = (contentRect.size.width - wh) * 0.5;
    return CGRectMake(x, 10, wh, wh);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 73, contentRect.size.width, 15);
}

@end


#pragma mark - >>>>
@interface YXShareView ()
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *link;
@property (nonatomic, strong)YXPunchModel *punchModel;
@end

@implementation YXShareView
+ (YXShareView *)showShareInView:(UIView *)view {
    YXShareView *shareView = [[self alloc] initWithFrame:view.bounds];
    [view addSubview:shareView];
    return shareView;
}

+ (YXShareView *)showShareInView:(UIView *)view punchModel:(YXPunchModel *)punchModel {
    YXShareView *shareView = [[self alloc] initWithFrame:view.bounds];
    shareView.punchModel = punchModel;
    [view addSubview:shareView];
    return shareView;
}

+ (YXShareView *)showShareInView:(UIView *)view title:(NSString *)title shareLink:(NSString *)link {
    YXShareView *shareView = [[self alloc] initWithFrame:view.bounds];
    shareView.title = title;
    shareView.link = link;
    [view addSubview:shareView];
    return shareView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxBackResponst:) name:kYXShareCallBackNotify object:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleShare)];
        [self.maskView addGestureRecognizer:tap];
        self.maskView.alpha = 0;
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200 + kSafeBottomMargin)];
        self.bottomView.backgroundColor = UIColor.whiteColor;
        [self addSubview:self.bottomView];
        
        NSArray *titles = @[@"微信",@"朋友圈",@"QQ"];
        NSArray *images = @[@"学习结果页的微信",@"学习结果页的朋友圈",@"学习结果页的QQ"];
        CGFloat width = 60;
        CGFloat margin = (SCREEN_WIDTH - titles.count * width) / 4;
        for (int i = 0; i < titles.count; i ++) {
            YXShareButton *shareButton = [[YXShareButton alloc] init];
            shareButton.tag = i;
            [shareButton setTitle:titles[i] forState:UIControlStateNormal];
            [shareButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [shareButton addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:shareButton];
            
            [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bottomView).offset(20);
                make.height.mas_equalTo(87);
                make.width.mas_equalTo(width);
                make.left.equalTo(self.bottomView).offset(margin + (width + margin) * i);
            }];
        }
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorOfHex(0xEFF4F7);
        
        UIButton *cancleButton = [[UIButton alloc] init];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:lineView];
        [self.bottomView addSubview:cancleButton];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bottomView);
            make.height.mas_equalTo(10);
            make.top.equalTo(self.bottomView).offset(136);
        }];
        
        [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bottomView);
            make.top.equalTo(lineView.mas_bottom);
            make.bottom.equalTo(self.bottomView);
        }];
        
        CGRect oriFrame = self.bottomView.frame;
        oriFrame.origin.y = SCREEN_HEIGHT - CGRectGetHeight(oriFrame);
        [UIView animateWithDuration:0.25 animations:^{
            self.maskView.alpha = 0.6;
            self.bottomView.frame = oriFrame;
        }];
    }
    return self;
}

- (void)shareResult:(YXShareButton *)shareButton {
    [YXShareHelper shareResultToPaltform:shareButton.tag
                              punchModel:self.punchModel];
    
    //关闭分享页面
    [self cancleShare];
    
    NSString *way = @"";
    switch (shareButton.tag) {
        case YXShareWXSession:
            way = @"wechat";break;
        case YXShareWXTimeLine:
            way = @"moments";break;
        case YXShareQQ:
            way = @"qq";break;
        default:
            break;
    }
    NSDictionary *contentDic = @{@"way":way};
    NSDictionary *param = @{
        @"event":@"clockSharing",
        @"comment":[contentDic mj_JSONString]
    };
    [YXDataProcessCenter POST:DOMAIN_SEEDSREPORT parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        
    }];
    
    if ([way isEqualToString:@"moments"]){
        [YXDataProcessCenter POST:DOMAIN_USERSHARECREDIT parameters:contentDic finshedBlock:^(YRHttpResponse *response, BOOL result) {
            NSLog(@"%@",response.responseObject);
        }];
    }
    
}

- (void)wxBackResponst:(NSNotification *)notify {
    [self cancleShare];
}

- (void)cancleShare {
    CGRect oriFrame = self.bottomView.frame;
    oriFrame.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
        self.bottomView.frame = oriFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - share
- (UIImage *)genrateShareImage:(YXSharePalform)platForm {
    //    dispatch_async_to_globalThread(^{
    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platForm];
    UIImage *shareImage = [YXShareImageGenerator generateResultImage:self.punchModel
                                                                link:picUrl];
    return shareImage;
    //    });
}

- (NSData *)genrateShareImageData:(YXSharePalform)platForm {
    UIImage *image = [self genrateShareImage:platForm];
    return UIImageJPEGRepresentation(image, 0.8);
}


@end

//- (void)shareWithWeChat:(YXShareButton *)shareButton {
//    [YXShareHelper shareResultToPaltform:shareButton.tag
//                              punchModel:self.punchModel];
//
//    return;
//    if (shareButton.tag == 0) { //微信
//        WXWebpageObject *object = [WXWebpageObject object];
//        object.webpageUrl = self.link;
//
//        WXMediaMessage *message = [WXMediaMessage message];
//        [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
//        message.title = self.title;
//        message.description = @"跟着念念学英语，考试提分不用愁。";
//        message.mediaObject = object;
//        message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
//
//        SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
//        sentMsg.message = message;
//        sentMsg.bText = NO;
//        sentMsg.scene = WXSceneSession;
//
//        [WXApi sendReq:sentMsg];
//    }else if(shareButton.tag == 1) { //微信
//        WXWebpageObject *object = [WXWebpageObject object];
//        object.webpageUrl = self.link;
//
//        WXMediaMessage *message = [WXMediaMessage message];
//        [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
//        message.title = self.title;//@"单词量up！今日份的单词打卡~【念念有词】";
//        message.description = @"跟着念念学英语，考试提分不用愁。";
//        message.mediaObject = object;
//        message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
//
//        SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
//        sentMsg.message = message;
//        sentMsg.bText = NO;
//
//        sentMsg.scene = WXSceneTimeline;
//
//        [WXApi sendReq:sentMsg];
//    }else {
//        NSString *link = [self.link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//        QQApiNewsObject *object = [QQApiNewsObject
//                                   objectWithURL:[NSURL URLWithString:link]
//                                   title:self.title        //@"单词量up！今日份的单词打卡~【念念有词】"
//                                   description:@"跟着念念学英语，考试提分不用愁。"
//                                   previewImageURL:nil];
//        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
//
//        [QQApiInterface sendReq:req];
//    }
//}
