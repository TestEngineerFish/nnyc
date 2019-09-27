//
//  YXShareChallengeRankView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/15.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXShareChallengeRankView.h"
#import "QQApiManager.h"
#import "WXApiManager.h"
#import "YXShareHelper.h"
#import "YXGameResultModel.h"
#import "YXShareImageGenerator.h"

@interface YXShareChallengeRankView()
@property (nonatomic, weak) UIButton *bgBtnView;
@property (nonatomic, weak) UIView *shareView;
@property (nonatomic, weak) UIView *shareCollectionview;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, strong) YXGameResultModel *resultModel;

@end

@implementation YXShareChallengeRankView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bgBtnView];
        [self shareView];
        [self shareCollectionview];
        [self lineView];
        [self cancelBtn];
    }
    return self;
}

- (void)setDescoverModel:(YXDescoverModel *)descoverModel {
    _descoverModel = descoverModel;
    YXGameResultModel *model = [[YXGameResultModel alloc] init];
//    model.state =
    model.avatar = descoverModel.myGrades.avatar;
    model.rightNum = descoverModel.myGrades.desc.correctNum;
    model.answerTime = descoverModel.myGrades.desc.speedTime;
    model.ranking = descoverModel.myGrades.desc.ranking;
//    model.userIcon =

    _resultModel = model;
}

#pragma mark - subviews
- (UIButton *)bgBtnView {
    if (!_bgBtnView) {
        UIButton *bgBtnView = [[UIButton alloc] initWithFrame:self.frame];
        bgBtnView.backgroundColor = [UIColor blackColor];
        bgBtnView.alpha = 0.5;
        [self addSubview:bgBtnView];
        [bgBtnView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _bgBtnView = bgBtnView;
    }
    return _bgBtnView;
}

- (UIView *)shareView {
    if (!_shareView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200.f + kSafeBottomMargin)];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        _shareView = view;
    }
    return _shareView;
}

- (UIView *)shareCollectionview {
    if (!_shareCollectionview) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(AdaptSize(50.f), AdaptSize(30.f), SCREEN_WIDTH - AdaptSize(100.f), AdaptSize(136.f))];
        view.backgroundColor = [UIColor whiteColor];
        [_shareView addSubview:view];
        //微信
        UIButton *wechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, AdaptSize(52), AdaptSize(78))];
        wechatBtn.tag = YXShareWXSession;
        [wechatBtn addTarget:self action:@selector(shareChallengeRank:) forControlEvents:UIControlEventTouchUpInside];
        [wechatBtn setImage:[UIImage imageNamed:@"wx_icon"] forState:UIControlStateNormal];
        [wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
        [self handleCustomBtn:wechatBtn];
        [view addSubview:wechatBtn];
        //朋友圈
        UIButton *momentBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.width/2.f - AdaptSize(26.f), 0, AdaptSize(52), AdaptSize(78))];
        momentBtn.tag = YXShareWXTimeLine;
        [momentBtn addTarget:self action:@selector(shareChallengeRank:) forControlEvents:UIControlEventTouchUpInside];
        [momentBtn setImage:[UIImage imageNamed:@"moment_icon"] forState:UIControlStateNormal];
        [momentBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
        [self handleCustomBtn:momentBtn];
        [view addSubview:momentBtn];
        //QQ
        UIButton *qqBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.width - AdaptSize(52.f), 0, AdaptSize(52), AdaptSize(78))];
        qqBtn.tag = YXShareQQ;
        [qqBtn addTarget:self action:@selector(shareChallengeRank:) forControlEvents:UIControlEventTouchUpInside];
        [qqBtn setImage:[UIImage imageNamed:@"qq_icon"] forState:UIControlStateNormal];
        [qqBtn setTitle:@"QQ" forState:UIControlStateNormal];
        [self handleCustomBtn:qqBtn];
        [view addSubview:qqBtn];

        _shareCollectionview = view;
    }
    return _shareCollectionview;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 136.f, SCREEN_WIDTH, 10.f)];
        view.backgroundColor = UIColorOfHex(0xEFF4F7);
        [_shareView addSubview:view];
        _lineView = view;
    }
    return _lineView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 146.f, SCREEN_WIDTH, 55.f)];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:AdaptSize(18.f)]];
        [btn setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        [_shareView addSubview:btn];
        _cancelBtn = btn;
    }
    return _cancelBtn;
}

- (void)handleCustomBtn:(UIButton *)btn {
    [btn setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont pfSCRegularFontWithSize:13];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 25, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(63, -53, 0, 0)];
}

# pragma mark - event

- (void)didMoveToSuperview {
    [self showWithAnimate];
}

- (void)dismiss {
    [self hideWithAnimate];
}

- (void)shareChallengeRank:(UIButton *)btn {
    [self dismiss];
    [self shareResultTo:btn.tag resultModel: _resultModel];
}
#pragma mark - share action

- (void)shareResultTo:(YXSharePalform)platform resultModel:(YXGameResultModel *)resultModel {
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self title:@"网络不给力"];
        return;
    }

    if(!resultModel) {
        return;
    }
    self.shareView.userInteractionEnabled = NO;
    if (resultModel.userIcon) {
        UIImage *shareImage = [YXShareImageGenerator generateGameResultImage:resultModel
                                                                    platform:platform];
        [self shareResultTo:platform withImage:shareImage];
        return;
    }
    __weak typeof(self) weakSelf = self;
    // 下载头像
    [[SDWebImageManager sharedManager].imageDownloader
     downloadImageWithURL:[NSURL URLWithString:resultModel.avatar]
     options:SDWebImageDownloaderLowPriority
     progress:nil
     completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
         if (image && !error) {
             resultModel.userIcon = image;
         }else {
             resultModel.userIcon = [UIImage imageNamed:@"userPlaceHolder"];
         }
         UIImage *shareImage = [YXShareImageGenerator generateGameResultImage:resultModel
                                                                     platform:platform];

         [weakSelf shareResultTo:platform withImage:shareImage];
     }];
}

- (void)shareResultTo:(YXSharePalform)platform withImage:(UIImage *)image {
    self.shareView.userInteractionEnabled = YES;
    if (image) {
        [YXShareHelper shareImage:image
                       toPaltform:platform
                            title:nil
                     describution:nil
                    shareBusiness:kShareGameResult];
    }
}

#pragma mark - animation

- (void)hideWithAnimate {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _bgBtnView.alpha = 0.0f;
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200.f + kSafeBottomMargin);
    } completion:nil];
}

- (void)showWithAnimate {
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _bgBtnView.alpha = 0.5f;
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT - 200.f - kSafeBottomMargin, SCREEN_WIDTH, 200.f + kSafeBottomMargin);
    } completion:nil];
}

@end
