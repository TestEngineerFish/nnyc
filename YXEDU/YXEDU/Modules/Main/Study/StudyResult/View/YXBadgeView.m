//
//  YXBadgeView.m
//  YXEDU
//
//  Created by yao on 2018/11/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBadgeView.h"

#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "YXShareHelper.h"
@interface YXBadgeView ()
@property (nonatomic, strong) NSString *badgeShareURL;
@property (nonatomic, strong) NSString *badgeName;
@property (nonatomic, strong) UIImage *badgeImage;
@property (nonatomic, strong) NSString *badgeCompletedImageUrl;

@property (nonatomic, weak)UIView *containerView;
@property (nonatomic, weak)UIView *maskView;
@property (nonatomic, weak)UIImageView *badgeImageView;
@property (nonatomic, weak)UILabel *badgeNameL;
@property (nonatomic, weak)UILabel *badgeDateL;
@property (nonatomic, weak)UILabel *descLabel;
@property (nonatomic, copy)ActionFinishBlock finishBlock;
@property (nonatomic, strong)YXShareLinkModel *shareModel;
@end

@implementation YXBadgeView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *maskView = [[UIView alloc] init];
        maskView.alpha = 0;
        maskView.backgroundColor = [UIColor blackColor];
        [self addSubview:maskView];
        _maskView = maskView;
        [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishAction)];
        [maskView addGestureRecognizer:tap];
        
        UIView *containerView = [[UIView alloc] init];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishAction)];
        [containerView addGestureRecognizer:tap1];
        containerView.backgroundColor = UIColor.whiteColor;
        containerView.layer.cornerRadius = 8;
        [self addSubview:containerView];
        _containerView = containerView;
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(280, 324));
        }];
        
        UIView *roundView = [[UIView alloc] init];
        roundView.backgroundColor = [UIColor whiteColor];
        roundView.layer.cornerRadius = 55;
        roundView.layer.masksToBounds = YES;
        [containerView addSubview:roundView];
        [roundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView);
            make.centerY.equalTo(self.containerView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(110, 110));
        }];
        
        UIImageView *badgeImageView = [[UIImageView alloc] init];
        badgeImageView.userInteractionEnabled = YES;
        badgeImageView.contentMode = UIViewContentModeScaleToFill;
        badgeImageView.backgroundColor = [UIColor whiteColor];
        [roundView addSubview:badgeImageView];
        _badgeImageView = badgeImageView;
        [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerView);
            make.centerY.equalTo(self.containerView.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        UILabel *badgeNameL = [[UILabel alloc] init];
        badgeNameL.userInteractionEnabled = YES;
        badgeNameL.font = [UIFont boldSystemFontOfSize:18];
        badgeNameL.textColor = UIColorOfHex(0x485461);
        badgeNameL.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:badgeNameL];
        _badgeNameL = badgeNameL;
        
        [badgeNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView);
            make.top.equalTo(badgeImageView.mas_bottom).offset(10);
        }];
        
        UILabel *badgeDateL = [[UILabel alloc] init];
        badgeDateL.userInteractionEnabled = YES;
        badgeDateL.font = [UIFont systemFontOfSize:12];
        badgeDateL.textColor = UIColorOfHex(0x8095AB);
        badgeDateL.textAlignment = NSTextAlignmentCenter;
        badgeDateL.text = @"已获得";
        [containerView addSubview:badgeDateL];
        _badgeDateL = badgeDateL;
        
        [badgeDateL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView);
            make.top.equalTo(badgeNameL.mas_bottom).offset(10);
        }];
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.userInteractionEnabled = YES;
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:13];
        descLabel.textColor = UIColorOfHex(0x434A5D);;
        descLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:descLabel];
        _descLabel = descLabel;
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(240);
            make.centerX.equalTo(containerView);
            make.top.equalTo(badgeDateL.mas_bottom).offset(20);
        }];
        
        UIImageView *decorateImageView = [[UIImageView alloc] init];
        decorateImageView.userInteractionEnabled = YES;
        decorateImageView.contentMode = UIViewContentModeScaleAspectFit;
        decorateImageView.image = [UIImage imageNamed:@"装饰"];
        [containerView addSubview:decorateImageView];
        [decorateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(containerView.mas_top).offset(32);
            make.left.equalTo(containerView).offset(-20);
            make.right.equalTo(containerView).offset(28);
            make.height.mas_equalTo(286);
//            make.size.mas_equalTo(CGSizeMake(331, 286));
        }];
        
        UIImageView *envelopeImageView = [[UIImageView alloc] init];
        envelopeImageView.contentMode = UIViewContentModeScaleAspectFit;
        envelopeImageView.userInteractionEnabled = YES;
        envelopeImageView.image = [UIImage imageNamed:@"信封"];
        [containerView addSubview:envelopeImageView];
        [envelopeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(179);
            make.left.equalTo(containerView).offset(-9);
            make.right.equalTo(containerView).offset(8);
            make.top.equalTo(containerView.mas_centerY);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:24];
        nameLabel.textColor = UIColorOfHex(0x485461);
        
        UILabel *shareLabel = [[UILabel alloc] init];
        shareLabel.font = [UIFont systemFontOfSize:14];
        shareLabel.textColor = UIColor.whiteColor;
        shareLabel.text = @"炫耀一下";
        
        UILabel *wechatLabel = [[UILabel alloc] init];
        wechatLabel.textColor = UIColor.whiteColor;
        wechatLabel.font = [UIFont systemFontOfSize:12];
        wechatLabel.text = @"微信";
        
        UILabel *momentLabel = [[UILabel alloc] init];
        momentLabel.textColor = UIColor.whiteColor;
        momentLabel.font = [UIFont systemFontOfSize:12];
        momentLabel.text = @"朋友圈";
        
        UILabel *qqLabel = [[UILabel alloc] init];
        qqLabel.textColor = UIColor.whiteColor;
        qqLabel.font = [UIFont systemFontOfSize:12];
        qqLabel.text = @"QQ";
        
        UIButton *wechatButton = [[UIButton alloc] init];
        wechatButton.tag = YXShareWXSession;
        [wechatButton setImage:[UIImage imageNamed:@"徽章微信"] forState:UIControlStateNormal];
        [wechatButton addTarget:self action:@selector(shareWithWeChat:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *momentButton = [[UIButton alloc] init];
        momentButton.tag = YXShareWXTimeLine;
        [momentButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        [momentButton addTarget:self action:@selector(shareWithMoment:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *qqButton = [[UIButton alloc] init];
        qqButton.tag = YXShareQQ;
        [qqButton setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        [qqButton addTarget:self action:@selector(shareWithQQ:) forControlEvents:UIControlEventTouchUpInside];
        
        [containerView addSubview:shareLabel];
        [containerView addSubview:wechatLabel];
        [containerView addSubview:momentLabel];
        [containerView addSubview:qqLabel];
        [containerView addSubview:wechatButton];
        [containerView addSubview:momentButton];
        [containerView addSubview:qqButton];
        
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(envelopeImageView).offset(64);
            make.centerX.equalTo(envelopeImageView);
        }];
        
        [momentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(envelopeImageView).offset(-32);
            make.centerX.equalTo(envelopeImageView);
            make.size.mas_equalTo(CGSizeMake(46, 46));
        }];
        
        [momentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(momentButton);
            make.top.equalTo(momentButton.mas_bottom);
        }];
        
        [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(momentButton);
            make.left.equalTo(envelopeImageView).offset(32);
            make.size.equalTo(momentButton);
        }];
        
        [wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wechatButton);
            make.bottom.equalTo(momentLabel);
        }];
        
        [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(momentButton);
            make.right.equalTo(envelopeImageView).offset(-32);
            make.size.equalTo(momentButton);
        }];
        
        [qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(qqButton);
            make.bottom.equalTo(momentLabel);
        }];
        
        UIImageView *leftLine = [[UIImageView alloc] init];
        leftLine.alpha = 0.5;
        leftLine.image = [UIImage imageNamed:@"leftLine"];
        [containerView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 1));
            make.centerY.equalTo(shareLabel);
            make.right.equalTo(shareLabel.mas_left).offset(-10);
        }];
        
        UIImageView *rightLine = [[UIImageView alloc] init];
        rightLine.alpha = 0.5;
        rightLine.image = [UIImage imageNamed:@"rightLine"];
        [containerView addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 1));
            make.centerY.equalTo(shareLabel);
            make.left.equalTo(shareLabel.mas_right).offset(10);
        }];
    
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.userInteractionEnabled = NO;
        [closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(envelopeImageView.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return self;
}

- (void)setBadgeModel:(YXBadgeModel *)badgeModel {
    _badgeModel = badgeModel;
    self.badgeNameL.text = badgeModel.badgeName;
    [self.badgeImageView sd_setImageWithURL:[NSURL URLWithString:badgeModel.realize]];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    self.badgeDateL.text = [formatter stringFromDate:[NSDate date]];
    self.descLabel.text = badgeModel.desc;
}

- (void)shareBadge:(UIButton *)btn {
    [YXShareHelper shareBageImageToPaltform:btn.tag
                                 badgeImage:self.badgeImageView.image
                                      title:self.badgeModel.badgeName
                                       date:nil
                                describtion:self.badgeModel.desc];
}


+ (YXBadgeView *)showBadgeViewTo:(UIView *)view
                       WithModel:(YXBadgeModel *)badgeModel
                      shareModel:(YXShareLinkModel *)shareModel
                     finishBlock:(ActionFinishBlock)finishBlock
{
    YXBadgeView *badgeView = [[YXBadgeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    badgeView.badgeModel = badgeModel;
    badgeView.shareModel = shareModel;
    [view addSubview:badgeView];
    badgeView.finishBlock = [finishBlock copy];
    
    CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animater.values = @[@1,@1.1,@1.0];
    animater.duration = 0.25;
    animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [UIView animateWithDuration:0.25 animations:^{
        badgeView.maskView.alpha = 0.5;
    }];
    [badgeView.containerView.layer addAnimation:animater forKey:nil];
    return badgeView;
}

+ (YXBadgeView *)showBadgeViewWithModel:(YXBadgeModel *)badgeModel
                             shareModel:(YXShareLinkModel *)shareModel
                            finishBlock:(ActionFinishBlock)finishBlock
{
    YXBadgeView *badgeView = [[YXBadgeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    badgeView.badgeModel = badgeModel;
    badgeView.shareModel = shareModel;
    [[UIApplication sharedApplication].windows.lastObject addSubview:badgeView];
    badgeView.finishBlock = [finishBlock copy];
    
    CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animater.values = @[@1,@1.1,@1.0];
    animater.duration = 0.25;
    animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [UIView animateWithDuration:0.25 animations:^{
        badgeView.maskView.alpha = 0.5;
    }];
    [badgeView.containerView.layer addAnimation:animater forKey:nil];
    return badgeView;
}

- (void)finishAction {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.finishBlock) {
            self.finishBlock();
        }
    }];
}


#pragma mark - before share
- (UIImage *)genrateShareImage:(YXSharePalform)platForm {
    //    dispatch_async_to_globalThread(^{
    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platForm];
    UIImage *shareImage = [YXShareImageGenerator generateBadgeImage:self.badgeImageView.image
                                                              title:self.badgeModel.badgeName
                                                               date:nil
                                                        describtion:self.badgeModel.desc
                                                               link:picUrl];
    return shareImage;
    //    });
}

- (NSData *)genrateShareImageData:(YXSharePalform)platForm {
    UIImage *image = [self genrateShareImage:platForm];
    return UIImageJPEGRepresentation(image, 0.8);
}


- (void)shareWithWeChat:(id)sender {
    WXImageObject *imageObj = [WXImageObject object];
    
    imageObj.imageData = [self genrateShareImageData:YXShareWXSession];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObj;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    sentMsg.scene = WXSceneSession;
    
    [WXApi sendReq:sentMsg];
    //    WXWebpageObject *object = [WXWebpageObject object];
    //    object.webpageUrl = self.shareModel.shareUrl;
    //
    //    WXMediaMessage *message = [WXMediaMessage message];
    //    [message setThumbImage:self.badgeImage];
    ////    NSString *username = [YXConfigure shared].loginModel.user.nick;
    //    message.title = _shareModel.shareTitle;//[NSString stringWithFormat:@"%@的%@【念念有词】", username, self.badgeName];
    //    message.description = @"爱学习的孩子总会发现更多徽章~";
    //    message.mediaObject = object;
    //    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    //
    //    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    //    sentMsg.message = message;
    //    sentMsg.bText = NO;
    //    sentMsg.scene = WXSceneSession;
    //
    //    [WXApi sendReq:sentMsg];
}

- (void)shareWithMoment:(id)sender {
    
    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageData = [self genrateShareImageData:YXShareWXTimeLine];//UIImageJPEGRepresentation(self.shareImage, 0.8);
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObj;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    
    sentMsg.scene = WXSceneTimeline;
    
    [WXApi sendReq:sentMsg];
    
    
    //    WXWebpageObject *object = [WXWebpageObject object];
    //    object.webpageUrl = self.shareModel.shareUrl;
    //
    //    WXMediaMessage *message = [WXMediaMessage message];
    //    [message setThumbImage:self.badgeImage];
    //    message.title = _shareModel.shareTitle;//[NSString stringWithFormat:@"%@",self.shareModel.shareTitle];
    //    message.description = @"爱学习的孩子总会发现更多徽章~";
    //    message.mediaObject = object;
    //    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";
    //
    //    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    //    sentMsg.message = message;
    //    sentMsg.bText = NO;
    //
    //    sentMsg.scene = WXSceneTimeline;
    //
    //    [WXApi sendReq:sentMsg];
}

- (void)shareWithQQ:(id)sender {
    UIImage *imageData = [self genrateShareImage:YXShareQQ];
    NSData *oriData = UIImageJPEGRepresentation(imageData, 0.8);
    NSData *thumData = UIImageJPEGRepresentation(imageData, 0.5);
    
    QQApiImageObject *imageObj = [QQApiImageObject objectWithData:oriData
                                                 previewImageData:thumData
                                                            title:self.badgeModel.badgeName
                                                      description:self.badgeModel.desc];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObj];
    [QQApiInterface sendReq:req];
    
    
    ////    NSString *username = [YXConfigure shared].loginModel.user.nick;
    //    //[NSString stringWithFormat:@"%@的%@【念念有词】", username, self.badgeName]
    //    NSString *url = [_shareModel.shareUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    //    QQApiNewsObject *object = [QQApiNewsObject
    //                               objectWithURL:[NSURL URLWithString:url]  // _shareModel.shareUrl
    //                               title:_shareModel.shareTitle
    //                               description:@"爱学习的孩子总会发现更多徽章~"
    //                               previewImageURL:[NSURL URLWithString:self.badgeCompletedImageUrl]];
    //    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
    //
    //    [QQApiInterface sendReq:req];
    //    //    [QQApiInterface SendReqToQZone:req];
}
@end
