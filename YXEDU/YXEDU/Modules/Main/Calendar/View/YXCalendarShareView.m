//
//  YXCalendarShareView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/26.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarShareView.h"
#import "FSCalendar.h"
#import "YXShareImageGenerator.h"
#import "YXShareHelper.h"
#import "WXApi.h"
#import <CALayer+YYAdd.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "CALayer+YXCustom.h"
#import "NSString+YX.h"
#import "Reachability.h"

@interface YXCalendarShareView () <FSCalendarDelegateAppearance, FSCalendarDataSource>
@property (nonatomic, strong) YXCalendarStudyMonthData *monthData;

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *momentButton;
@property (nonatomic, assign) CGFloat shareViewHeight;
@property (nonatomic, assign) CGFloat shareViewWidth;
//Loading
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingAlertLabel;
@property (nonatomic, strong) UIImageView *loadingImageView;
@end

@implementation YXCalendarShareView

static CGFloat const kShareViewScale = 1.78f; //分享图高/宽比

- (void)setShareImage:(UIImage *)shareImage {
    _shareImage = shareImage;
    self.shareImageView.image = self.shareImage;
    [self setupViewStatus];
}

- (CGFloat)shareViewHeight {
    if (!_shareViewHeight) {
        _shareViewHeight = SCREEN_HEIGHT - kNavHeight - kSafeBottomMargin - 80;
    }
    return _shareViewHeight;
}

- (CGFloat)shareViewWidth {
    if (!_shareViewWidth) {
        _shareViewWidth = self.shareViewHeight/kShareViewScale;
    }
    return _shareViewWidth;
}

+ (YXCalendarShareView *)showCompletedViewWithMonthDate:(YXCalendarStudyMonthData *)monthData {
    YXCalendarShareView *view = [[self alloc] initWithMonthData:monthData];
    view.backgroundColor = UIColorOfHex(0xE9F4FE);
    return view;
}

- (UIImageView *)loadingIcon {
    if (!_loadingIcon) {
        UIImageView *loadingIcon = [[UIImageView alloc] init];
        _loadingIcon = loadingIcon;
    }
    return _loadingIcon;
}

- (UILabel *)loadingAlertLabel {
    if (!_loadingAlertLabel) {
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = UIColorOfHex(0xF19B3F);

        _loadingAlertLabel = label;
    }
    return _loadingAlertLabel;
}

- (instancetype)initWithMonthData:(YXCalendarStudyMonthData *)monthData
{
    self = [super init];
    if (self) {
        //开始分享图的请求
        [self getShareImageWithMonth: [monthData.summary.month transitionNumber]];

        self.monthData = monthData;
        UIView *shareView = [self shareView:YXShareWXSession];
        shareView.clipsToBounds = YES;
        shareView.layer.cornerRadius = 12.f;

        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closedView) forControlEvents:UIControlEventTouchUpInside];

        self.qqButton = [[UIButton alloc] init];
        self.qqButton.tag = YXShareQQ;
        [self.qqButton addTarget:self action:@selector(shareWithQQ) forControlEvents:UIControlEventTouchUpInside];
        
        self.wechatButton = [[UIButton alloc] init];
        self.wechatButton.tag = YXShareWXSession;
        [self.wechatButton addTarget:self action:@selector(shareWithWeChat) forControlEvents:UIControlEventTouchUpInside];
        
        self.momentButton = [[UIButton alloc] init];
        self.momentButton.tag = YXShareWXTimeLine;
        [self.momentButton addTarget:self action:@selector(shareWithMoment) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:shareView];
        [self addSubview:closeBtn];
        [self addSubview:self.qqButton];
        [self addSubview:self.wechatButton];
        [self addSubview:self.momentButton];

        [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_top).with.offset(AdaptSize(30.f + kStatusBarHeight));
            make.size.mas_equalTo(CGSizeMake(self.shareViewWidth, self.shareViewHeight));
        }];

        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(shareView.mas_left).with.offset(AdaptSize(5.f));
            make.centerY.mas_equalTo(shareView.mas_top);
            make.size.mas_equalTo(CGSizeMake(AdaptSize(35.f), AdaptSize(35.f)));
        }];

        [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(AdaptSize(15.f));
            make.bottom.equalTo(self).with.offset(AdaptSize(-5.f - kSafeBottomMargin));
            make.size.mas_equalTo(CGSizeMake(AdaptSize(45.f), AdaptSize(45.f)));
        }];

        [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_qqButton.mas_right).with.offset(AdaptSize(15.f));
            make.centerY.equalTo(_qqButton);
            make.size.mas_equalTo(CGSizeMake(AdaptSize(45.f), AdaptSize(45.f)));
        }];

        [self.momentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_qqButton);
            make.left.equalTo(_wechatButton.mas_right).with.offset(AdaptSize(20.f));
            make.right.equalTo(self).with.offset(AdaptSize(-15.f));
            make.height.mas_equalTo(AdaptSize(45.f));
        }];

    }
    [self setupViewStatus];
    return self;
}

- (UIView *)shareView:(YXSharePalform)platorm {
    UIImageView *shareView = [UIImageView new];
    shareView.backgroundColor = UIColor.whiteColor;
    //分享图
    self.shareImageView = [UIImageView new];
    if (self.shareImage) {
        self.shareImageView.image = self.shareImage;
    }
    //日期图
    UIView *dateBgView = [[UIView alloc] init];
    dateBgView.backgroundColor = UIColor.blackColor;
    dateBgView.alpha = 0.5;
    dateBgView.layer.cornerRadius = 15.f;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:AdaptSize(14)];
    dateLabel.textColor = UIColor.whiteColor;
    dateLabel.text = [NSString stringWithFormat:@"%@.%@", [self transformEnglishStr:self.monthData.summary.month], self.monthData.summary.year];
    //数据View
    UIView *monthDateBgView = [[UIView alloc] init];
    monthDateBgView.backgroundColor = UIColor.blackColor;
    monthDateBgView.alpha = 0.5f;
    monthDateBgView.layer.cornerRadius = 5.f;
    
    UILabel *title1 = [[UILabel alloc] init];
    title1.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
    title1.text = @"本月坚持学习";
    title1.textColor = UIColor.whiteColor;
    
    UILabel *title2 = [[UILabel alloc] init];
    title2.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
    title2.text = @"累计学习单词";
    title2.textColor = UIColor.whiteColor;
    
    UILabel *daysLabel = [[UILabel alloc] init];
    NSString *daysStr = [NSString stringWithFormat:@"%ld 天", self.monthData.summary.studyDays];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:daysStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: AdaptSize(14.f)],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [attrStr1 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(20.f)], NSForegroundColorAttributeName: UIColorOfHex(0xFFEC4F)} range:NSMakeRange(0, daysStr.length - 2)];
    daysLabel.attributedText = attrStr1;
    daysLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *studyLabel = [[UILabel alloc] init];
    NSString *wordsStr =[NSString stringWithFormat:@"%ld 个", self.monthData.summary.studyWords];
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:wordsStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: AdaptSize(14.f)],NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [attrStr2 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: AdaptSize(20.f)], NSForegroundColorAttributeName: UIColorOfHex(0xFFEC4F)} range:NSMakeRange(0, wordsStr.length - 2)];
    studyLabel.attributedText = attrStr2;
    studyLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView *calendarBgView = [[UIView alloc] init];
    calendarBgView.backgroundColor = UIColor.blackColor;
    calendarBgView.alpha = 0.5f;

    //日历
    FSCalendar *calendarView = [[FSCalendar alloc] init];
    calendarView.headerHeight = 0.f;
    calendarView.weekdayHeight = 0.f;
    calendarView.backgroundColor = UIColor.clearColor;
    calendarView.appearance.titlePlaceholderColor = UIColor.whiteColor;
    calendarView.appearance.titleDefaultColor = UIColor.whiteColor;
    calendarView.appearance.todayColor = UIColor.clearColor;
    calendarView.appearance.borderSelectionColor = UIColor.whiteColor;
    calendarView.appearance.selectionColor = UIColor.redColor;
    calendarView.appearance.titleSelectionColor = UIColor.whiteColor;
    calendarView.appearance.titleFont = [UIFont systemFontOfSize:AdaptSize(12)];
    calendarView.scrollEnabled = NO;
    calendarView.pagingEnabled = NO;
    calendarView.allowsSelection = NO;
    calendarView.dataSource = self;
    calendarView.delegate = self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    calendarView.currentPage = [dateFormatter dateFromString: [NSString stringWithFormat:@"%@-%@-%@",self.monthData.summary.year, self.monthData.summary.month, @"01"]];
    //二维码背景
    UIView *qrcodeBgView = [[UIView alloc] init];
    qrcodeBgView.backgroundColor = UIColor.whiteColor;

    UIImageView *qrcode = [UIImageView new];
    qrcode.image = [self genrateQRCode:platorm];

    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:@"miniIcon"];
    //状态标示
    UIView *punchedIcon = [[UIView alloc] init];
    punchedIcon.backgroundColor = UIColor.whiteColor;
    punchedIcon.layer.cornerRadius = 3.f;

    UILabel *punchedLabel = [[UILabel alloc] init];
    punchedLabel.text = @"已打卡";
    punchedLabel.font = [UIFont systemFontOfSize:AdaptSize(10.f)];
    punchedLabel.textColor = UIColor.whiteColor;

    UIView *studiedIcon = [[UIView alloc] init];
    studiedIcon.backgroundColor = UIColor.clearColor;
    studiedIcon.layer.cornerRadius = 3.f;
    studiedIcon.layer.borderColor = UIColor.whiteColor.CGColor;
    studiedIcon.layer.borderWidth = 1.f;

    UILabel *studiedLabel = [[UILabel alloc] init];
    studiedLabel.text = @"已学习";
    studiedLabel.font = [UIFont systemFontOfSize:AdaptSize(10.f)];
    studiedLabel.textColor = UIColor.whiteColor;

    [shareView addSubview:self.shareImageView];
    [shareView addSubview:dateBgView];
    [shareView addSubview:monthDateBgView];
    [shareView addSubview:calendarBgView];
    [shareView addSubview:dateLabel];
    [shareView addSubview:title1];
    [shareView addSubview:daysLabel];
    [shareView addSubview:title2];
    [shareView addSubview:studyLabel];
    [shareView addSubview:calendarView];
    [shareView addSubview:qrcodeBgView];
    [qrcodeBgView addSubview:qrcode];
    [qrcode addSubview:iconImageView];
    [shareView addSubview:punchedIcon];
    [shareView addSubview:punchedLabel];
    [shareView addSubview:studiedIcon];
    [shareView addSubview:studiedLabel];

    self.loadingImageView = [UIImageView new];
    [shareView addSubview:self.loadingImageView];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(shareView);
    }];
    self.loadingImageView.image = [UIImage imageNamed:@"share_calendar_loading_bg"];
    self.loadingImageView.contentMode = UIViewContentModeScaleToFill;
    [self.loadingImageView addSubview:self.loadingIcon];
    [self.loadingImageView addSubview:self.loadingAlertLabel];
    //设置点击重加载事件
    [shareView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getShareImage)];
    [self.loadingImageView addGestureRecognizer:tap];

    [self.loadingIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loadingImageView);
    }];
    [self.loadingAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loadingIcon);
        make.top.equalTo(self.loadingIcon.mas_bottom).with.offset(AdaptSize(25.f));
    }];

    [_shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(shareView);
    }];
    
    [dateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareView).with.offset(AdaptSize(-10.f));
        make.left.equalTo(shareView).with.offset(AdaptSize(-10.f));
        make.size.mas_equalTo(CGSizeMake(AdaptSize(115.f), AdaptSize(40.f)));
    }];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(dateBgView).with.offset(AdaptSize(5.f));
        make.centerY.equalTo(dateBgView).with.offset(AdaptSize(5.f));
    }];
    
    [monthDateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareView).with.offset(AdaptSize(-10.f));
        make.right.equalTo(shareView).with.offset(AdaptSize(10.f));
        make.size.mas_equalTo(CGSizeMake(AdaptSize(120.f), AdaptSize(130.f)));
    }];
    
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monthDateBgView).with.offset(AdaptSize(25.f));
        make.left.equalTo(monthDateBgView).with.offset(AdaptSize(15.f));
        make.height.mas_equalTo(AdaptSize(13.f));
    }];
    [daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1);
        make.top.equalTo(title1.mas_bottom).with.offset(AdaptSize(10.f));
        make.height.mas_equalTo(AdaptSize(18.f));
    }];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1);
        make.top.equalTo(daysLabel.mas_bottom).with.offset(AdaptSize(10.f));
        make.height.mas_equalTo(AdaptSize(13.f));
    }];
    [studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title1);
        make.top.equalTo(title2.mas_bottom).with.offset(AdaptSize(10.f));
        make.height.mas_equalTo(AdaptSize(18.f));
    }];
    
    [calendarBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(shareView);
        make.height.equalTo(shareView).multipliedBy(0.23f);
    }];
    
    [qrcodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(calendarBgView).with.offset(AdaptSize(20.f));
        make.right.equalTo(calendarBgView).with.offset(AdaptSize(-30.f));
        make.width.height.equalTo(calendarBgView.mas_height).multipliedBy(0.55);
    }];

    [qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(qrcodeBgView).with.offset(AdaptSize(5.f));
        make.bottom.right.equalTo(qrcodeBgView).with.offset(AdaptSize(-5.f));
    }];

    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(qrcode);
        make.centerY.equalTo(qrcode);
        make.size.equalTo(qrcodeBgView).multipliedBy(0.2f);
    }];
    
    [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(calendarBgView).with.offset(AdaptSize(15.f));
        make.left.equalTo(calendarBgView).with.offset(AdaptSize(30.f));
        make.bottom.greaterThanOrEqualTo(calendarBgView);
        make.right.equalTo(qrcode.mas_left).with.offset(AdaptSize(-15.f));
    }];

    [punchedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrcodeBgView);
        make.top.equalTo(calendarView.mas_bottom).with.offset(AdaptSize(-20.f));
        make.width.and.height.mas_equalTo(AdaptSize(6.f));
    }];

    [punchedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(punchedIcon);
        make.left.equalTo(punchedIcon.mas_right).with.offset(AdaptSize(3.f));
        make.height.mas_equalTo(AdaptSize(11.f));
    }];

    [studiedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(punchedIcon);
        make.left.equalTo(punchedLabel.mas_right).with.offset(AdaptSize(5.f));
        make.width.and.height.mas_equalTo(AdaptSize(6.f));
    }];

    [studiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(punchedIcon);
        make.left.equalTo(studiedIcon.mas_right).with.offset(AdaptSize(3.f));
        make.height.mas_equalTo(AdaptSize(11.f));
    }];

    return shareView;
}

- (void)getShareImage {
    if (!self.monthData) {
        return;
    }
    [self getShareImageWithMonth: [self.monthData.summary.month transitionNumber]];
}

- (void)getShareImageWithMonth:(NSNumber *)month {
    [self setupViewStatus];
    NSDictionary *param = @{@"month" : month};
    [YXDataProcessCenter GET:DOMAIN_CALENDARSHAREIMAGE parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSString *imageUrl = response.responseObject[@"imgUrl"];
            self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
        }
        [self setupViewStatus];
    }];
}

//根据平台返回分享二维码图像
- (UIImage *)genrateQRCode:(YXSharePalform)platForm {
    NSString *picUrl = [[YXConfigure shared].confModel.baseConfig shareLinkOf:platForm];
    UIImage *qrcodeImage = [YXShareImageGenerator generatorQRCodeImageWith:picUrl];
    return qrcodeImage;
}

- (UIImage *)genrateShareImageData:(YXSharePalform)platForm {
    UIView *shareView = [self shareView:platForm];
    [self.loadingImageView setHidden:YES];
    shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [shareView layoutIfNeeded];
    return [shareView.layer snapshotImage];
}

- (void)closedView {
    if ([self.delegate respondsToSelector:@selector(closeShareViewBlock)]) {
        [self.delegate closeShareViewBlock];
    }
    [self removeFromSuperview];
}

- (void)shareWithWeChat {
    WXImageObject *imageObj = [WXImageObject object];
    UIImage *image = [self genrateShareImageData:YXShareWXSession];
    imageObj.imageData = UIImageJPEGRepresentation(image, 0.8);

    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObj;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";

    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    sentMsg.message = message;
    sentMsg.bText = NO;
    sentMsg.scene = WXSceneSession;

    [WXApi sendReq:sentMsg];
}

- (void)shareWithMoment {
    WXImageObject *imageObj = [WXImageObject object];
    UIImage *image = [self genrateShareImageData:YXShareWXTimeLine];
    imageObj.imageData = UIImageJPEGRepresentation(image, 0.8);

    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObj;
    message.mediaTagName = @"ISOFTEN_TAG_JUMP_SHOWRANK";

    SendMessageToWXReq *sentMsg = [[SendMessageToWXReq alloc] init];
    sentMsg.message = message;
    sentMsg.bText = NO;

    sentMsg.scene = WXSceneTimeline;

    [WXApi sendReq:sentMsg];
}

- (void)shareWithQQ {
    UIImage *imageData = [self genrateShareImageData:YXShareQQ];
    NSData *oriData = UIImageJPEGRepresentation(imageData, 0.8);
    NSData *thumData = UIImageJPEGRepresentation(imageData, 0.5);
    QQApiImageObject *imageObj = [QQApiImageObject objectWithData:oriData
                                                 previewImageData:thumData
                                                            title:@""
                                                      description:@""];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObj];
    [QQApiInterface sendReq:req];
}

- (void)setupViewStatus {
    if (self.shareImage) {
        [self.loadingIcon.layer removeAllAnimations];
        [self.loadingImageView setHidden:YES];
        [self.qqButton setImage:[UIImage imageNamed:@"qq_icon_enabled"] forState:UIControlStateNormal];
        [self.wechatButton setImage:[UIImage imageNamed:@"wechat_icon_enabled"] forState:UIControlStateNormal];
        [self.momentButton setImage:[UIImage imageNamed:@"moment_icon_enabled"] forState:UIControlStateNormal];
        [self.qqButton setUserInteractionEnabled:YES];
        [self.wechatButton setUserInteractionEnabled:YES];
        [self.momentButton setUserInteractionEnabled:YES];
    } else {
        if ([Reachability reachabilityForInternetConnection].isReachable) {
            [self.loadingIcon.layer rotateView];
             [self.loadingImageView setUserInteractionEnabled:NO];
            self.loadingIcon.image = [UIImage imageNamed:@"calenar_loading_icon"];
            self.loadingAlertLabel.text = @"海报生成中...";
        } else {
            [self.loadingImageView setUserInteractionEnabled:YES];
            [self.loadingIcon.layer removeAllAnimations];
            self.loadingIcon.image = [UIImage imageNamed:@"noNetworkWithCalendar"];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"网络不给力,点击重试"];
            [attr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x8095AB) range:NSMakeRange(0, 8)];
            self.loadingAlertLabel.attributedText = attr;
        }
        [self.loadingImageView setHidden:NO];
        [self.qqButton setImage:[UIImage imageNamed:@"qq_icon_disabled"] forState:UIControlStateNormal];
        [self.wechatButton setImage:[UIImage imageNamed:@"wechat_icon_disabled"] forState:UIControlStateNormal];
        [self.momentButton setImage:[UIImage imageNamed:@"moment_icon_disabled"] forState:UIControlStateNormal];

        [self.qqButton setUserInteractionEnabled:NO];
        [self.wechatButton setUserInteractionEnabled:NO];
        [self.momentButton setUserInteractionEnabled:NO];
    }
}

#pragma mark - FSCalendarDelegateAppearance, FSCalendarDataSource
//设置已学习选中框颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateformatter stringFromDate:date];
    if ([self.monthData.studiedDateDict.allKeys containsObject:key]) {
        return UIColor.whiteColor;
    }
    return  UIColor.clearColor;
}

// 设置已打卡的背景色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateformatter stringFromDate:date];
    if ([self.monthData.punchedDateDict.allKeys containsObject:key]) {
        return UIColor.whiteColor;
    }
    return nil;
}
//设置已打卡的字体颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateformatter stringFromDate:date];
    if ([self.monthData.punchedDateDict.allKeys containsObject:key]) {
        return UIColor.blackColor;
    }
    return nil;
}

- (NSString *)transformEnglishStr:(NSString *)month {
    NSArray<NSString *> *monthArray = @[@"",@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec"];
    return monthArray[[month intValue]];
}

@end
