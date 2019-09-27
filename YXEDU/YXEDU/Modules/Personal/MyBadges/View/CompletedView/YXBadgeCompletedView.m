//
//  YXBadgeCompletedView.m
//  YXEDU
//
//  Created by Jake To on 10/26/18.
//  Copyright © 2018 shiji. All rights reserved.
//
#import "YXComHttpService.h"

#import "YXBadgeCompletedView.h"

#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "YXShareHelper.h"
@interface YXBadgeCompletedView ()

@property (nonatomic, strong) NSString *badgeShareURL;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, strong) NSString *badgeName;
@property (nonatomic, strong) UIImage *badgeImage;
@property (nonatomic, strong) NSString *badgeCompletedImageUrl;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, copy) NSString *finishDate;
@property (nonatomic, strong)YXPersonalBadgeModel *badge;
@end

@implementation YXBadgeCompletedView

+ (YXBadgeCompletedView *)showCompletedViewWithBadge:(YXPersonalBadgeModel *)badge {
    
    YXBadgeCompletedView *view = [[self alloc] initWithBadge:badge];
    return view;
    
}

- (instancetype)initWithBadge:(YXPersonalBadgeModel *)badge {
    if (self = [super init]) {
        
        self.badgeCompletedImageUrl = badge.completedBadgeImageUrl;
        self.badge = badge;
//        NSDictionary *paramter = @{@"badgeId":badge.badgeID};
        
//        [[YXComHttpService shared] requestBadgeShareURL:paramter block:^(id obj, BOOL result) {
//            if (result) {
//                self.badgeShareURL = [[obj valueForKey:@"share"] valueForKey:@"shareUrl"];
//                self.shareTitle = [[obj valueForKey:@"share"] valueForKey:@"shareTitle"];
//            }
//        }];
        
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = UIColor.whiteColor;
        containerView.layer.cornerRadius = 8;
        
        UIView *avatarBackgroundView = [[UIView alloc] init];
        avatarBackgroundView.backgroundColor = UIColor.whiteColor;
        avatarBackgroundView.layer.cornerRadius = 64;

        UIImageView *avatarImageView = [[UIImageView alloc] init];
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:badge.completedBadgeImageUrl]];
        self.badgeImage = avatarImageView.image;
        
        UIImageView *decorateImageView = [[UIImageView alloc] init];
        decorateImageView.contentMode = UIViewContentModeScaleAspectFit;
        decorateImageView.image = [UIImage imageNamed:@"装饰"];
        
        UIImageView *envelopeImageView = [[UIImageView alloc] init];
        envelopeImageView.contentMode = UIViewContentModeScaleAspectFit;
        envelopeImageView.image = [UIImage imageNamed:@"信封"];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:18];
        nameLabel.text = badge.badgeName;
//        nameLabel.font = [UIFont systemFontOfSize:24];
        nameLabel.textColor = UIColorOfHex(0x485461);
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:12];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *finishDate = [formatter dateFromString:badge.finishDate];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *finishDateString = [formatter stringFromDate:finishDate];
        self.finishDate = finishDateString;
        dateLabel.text = [NSString stringWithFormat:@"已获得：%@",finishDateString];
        dateLabel.textColor = UIColorOfHex(0x849EC5);

        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:13];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.text = badge.desc;
        descLabel.textColor = UIColorOfHex(0x485461);
        
        [self addSubview:containerView];
        [containerView addSubview:decorateImageView];
        [containerView addSubview:avatarBackgroundView];
        [avatarBackgroundView addSubview:avatarImageView];
        [containerView addSubview:nameLabel];
        [containerView addSubview:dateLabel];
        [containerView addSubview:descLabel];
        [containerView addSubview:envelopeImageView];

//        [self genrateShareImage];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [decorateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(containerView);
            make.left.equalTo(containerView).offset(-20);
            make.right.equalTo(containerView).offset(28);
            make.centerY.equalTo(containerView.mas_top).offset(32);
        }];
        
        [avatarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(128);
            make.centerX.equalTo(containerView);
            make.centerY.equalTo(containerView.mas_top).offset(24);
        }];
        
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(96);
            make.center.equalTo(avatarBackgroundView);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(avatarBackgroundView.mas_bottom).offset(0);
            make.centerX.equalTo(containerView);
        }];
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(4);
            make.centerX.equalTo(containerView);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dateLabel.mas_bottom).offset(20);
            make.left.equalTo(containerView).offset(20);
            make.right.equalTo(containerView).offset(-20);
            make.centerX.equalTo(containerView);
        }];
        
        [envelopeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(containerView).offset(-9);
            make.right.equalTo(containerView).offset(8);
            make.bottom.equalTo(containerView).offset(8);
//            make.centerX.equalTo(containerView);
        }];
        
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
        [wechatButton addTarget:self action:@selector(shareBadge:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *momentButton = [[UIButton alloc] init];
        momentButton.tag = YXShareWXTimeLine;
        [momentButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        [momentButton addTarget:self action:@selector(shareBadge:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *qqButton = [[UIButton alloc] init];
        qqButton.tag = YXShareQQ;
        [qqButton setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        [qqButton addTarget:self action:@selector(shareBadge:) forControlEvents:UIControlEventTouchUpInside];
        
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
        }];
        
        [momentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(momentButton);
            make.top.equalTo(momentButton.mas_bottom);
        }];
        
        [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(momentButton);
            make.left.equalTo(envelopeImageView).offset(32);
        }];
        
        [wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wechatButton);
            make.bottom.equalTo(momentLabel);
        }];
        
        [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(momentButton);
            make.right.equalTo(envelopeImageView).offset(-32);
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

    }
    return self;
}
//根据平台返回分享图像
- (UIImage *)genrateShareImage:(YXSharePalform)platForm {
//    dispatch_async_to_globalThread(^{
    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platForm];
    UIImage *shareImage = [YXShareImageGenerator generateBadgeImage:self.badgeImage
                                                          title:self.badge.badgeName
                                                           date:self.finishDate
                                                    describtion:self.badge.desc
                                                               link:picUrl];
    return shareImage;
//    });
}

- (NSData *)genrateShareImageData:(YXSharePalform)platForm {
     UIImage *image = [self genrateShareImage:platForm];
    return UIImageJPEGRepresentation(image, 0.8);
}


- (void)shareBadge:(UIButton *)btn {
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self title:@"网络不给力"];
        return;
    }
   
    [YXShareHelper shareBageImageToPaltform:btn.tag
                                 badgeImage:self.badgeImage
                                      title:self.badge.badgeName
                                       date:self.finishDate
                                describtion:self.badge.desc];
}


#pragma mark - before
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
}

- (void)shareWithQQ:(id)sender {
//    NSData *imageData = UIImageJPEGRepresentation(self.shareImage, 0.8);
    UIImage *imageData = [self genrateShareImage:YXShareQQ];
    NSData *oriData = UIImageJPEGRepresentation(imageData, 0.8);
    NSData *thumData = UIImageJPEGRepresentation(imageData, 0.5);
    QQApiImageObject *imageObj = [QQApiImageObject objectWithData:oriData
                                                 previewImageData:thumData
                                                            title:self.badge.badgeName
                                                      description:self.badge.desc];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObj];
    [QQApiInterface sendReq:req];
}

@end
