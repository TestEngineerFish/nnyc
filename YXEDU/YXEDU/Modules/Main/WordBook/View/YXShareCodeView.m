//
//  YXShareCodeView.m
//  YXEDU
//
//  Created by yixue on 2019/3/1.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXShareCodeView.h"
#import "QQApiManager.h"
#import "WXApiManager.h"
@interface YXShareCodeView ()

@property (nonatomic, weak) UIButton *bgBtnView;
@property (nonatomic, weak) UIView *shareView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *codeLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIView *shareCollectionView;
@property (nonatomic, weak) UIView *successView;

@property (nonatomic, copy) NSString *codeStr;

@end

@implementation YXShareCodeView

-(id)initWithCodeStr:(NSString *)codeStr {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _codeStr = codeStr;
        
        [self bgBtnView];
        [self shareView];
        [self titleLabel];
        [self codeLabel];
        [self lineView];
        [self shareCollectionView];
        
    }
    return self;
}

- (void)didMoveToSuperview {
    [self showWithAnimate];
}

#pragma mark - SubViews
- (UIButton *)bgBtnView {
    if (!_bgBtnView) {
        UIButton *bgBtnView = [[UIButton alloc] initWithFrame:self.frame];
        bgBtnView.backgroundColor = [UIColor blackColor];
        bgBtnView.alpha = 0.0;
        [self addSubview:bgBtnView];
        [bgBtnView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _bgBtnView = bgBtnView;
    }
    return _bgBtnView;
}

- (UIView *)shareView {
    if (!_shareView) {
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50+250 + kSafeBottomMargin)];
        shareView.backgroundColor = [UIColor whiteColor];
        [self addSubview:shareView];
        _shareView = shareView;
    }
    return _shareView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 100, 19)];
        titleLabel.text = @"分享口令：";
        titleLabel.textColor = UIColorOfHex(0x485461);
        titleLabel.font = [UIFont pfSCRegularFontWithSize:18];
        [_shareView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 58, SCREEN_WIDTH - 100, 90)];
        codeLabel.layer.cornerRadius = 7;
        codeLabel.layer.borderColor = UIColorOfHex(0xD2E0E8).CGColor;
        codeLabel.layer.borderWidth = 1;
        codeLabel.backgroundColor = UIColorOfHex(0xF9FCFF);
        NSString *codeStr = _codeStr;
        codeLabel.text = [NSString stringWithFormat:@"  %@",codeStr];
        codeLabel.textColor = UIColorOfHex(0x485461);
        codeLabel.font = [UIFont pfSCRegularFontWithSize:16];
        codeLabel.numberOfLines = 0;
        
        [_shareView addSubview:codeLabel];
        _codeLabel = codeLabel;
    }
    return _codeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 50+118, SCREEN_WIDTH - 100, 19)];
        
        UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 70, 3, 40, 14)];
        lineLbl.text = @"分享到";
        lineLbl.textColor = UIColorOfHex(0x849EC5);
        lineLbl.font = [UIFont pfSCRegularFontWithSize:13];
        [lineView addSubview:lineLbl];
        
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 9, SCREEN_WIDTH/2 - 80, 1)];
        leftLine.backgroundColor = UIColorOfHex(0xEAF4FC);
        [lineView addSubview:leftLine];
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 9, SCREEN_WIDTH/2 - 80, 1)];
        rightLine.backgroundColor = UIColorOfHex(0xEAF4FC);
        [lineView addSubview:rightLine];
        
        [_shareView addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}

- (UIView *)shareCollectionView {
    if (!_shareCollectionView) {
        UIView *shareCollectionView = [[UIView alloc] initWithFrame:CGRectMake(50, 50+155, SCREEN_WIDTH - 100, 78)];
        shareCollectionView.backgroundColor = [UIColor whiteColor];
        
//        UIButton *shareBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 78)];
//        [shareBtn1 setImage:[UIImage imageNamed:@"copy_icon"] forState:UIControlStateNormal];
//        [shareBtn1 setTitle:@"复制口令" forState:UIControlStateNormal];
//        [self handleCustomBtn:shareBtn1];
//        [shareCollectionView addSubview:shareBtn1];
//        [shareBtn1 addTarget:self action:@selector(pasteToBoardAndDismiss) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shareBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 53, 78)];
        shareBtn2.tag = YXShareWXSession;
        [shareBtn2 addTarget:self action:@selector(shareCodeToThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn2 setImage:[UIImage imageNamed:@"wx_icon"] forState:UIControlStateNormal];
        [shareBtn2 setTitle:@"微信" forState:UIControlStateNormal];
        [self handleCustomBtn:shareBtn2];
        [shareCollectionView addSubview:shareBtn2];
        
        UIButton *shareBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(200.0, 0, 53, 78)];
        shareBtn3.tag = YXShareQQ;
        [shareBtn3 addTarget:self action:@selector(shareCodeToThirdPlatform:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn3 setImage:[UIImage imageNamed:@"qq_icon"] forState:UIControlStateNormal];
        [shareBtn3 setTitle:@"QQ" forState:UIControlStateNormal];
        [self handleCustomBtn:shareBtn3];
        [shareCollectionView addSubview:shareBtn3];
        
        [_shareView addSubview:shareCollectionView];
        _shareCollectionView = shareCollectionView;
    }
    return _shareCollectionView;
}

- (void)handleCustomBtn:(UIButton *)btn {
    [btn setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont pfSCRegularFontWithSize:13];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 25, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(63, -53, 0, 0)];
}

- (UIView *)successView {
    if (!_successView) {
        UIView *successView = [[UIView alloc] initWithFrame:CGRectMake(50, 155, SCREEN_WIDTH - 100, 78)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 76.5, 0, 53, 53)];
        [btn setBackgroundImage:[UIImage imageNamed:@"copySuccess_copy"] forState:UIControlStateNormal];
        [successView addSubview:btn];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.origin = CGPointMake(SCREEN_WIDTH/2 - 50 - 100, 65);
        lbl.size = CGSizeMake(200, 14);
        lbl.text = @" 口令已复制，快去分享吧！";
        lbl.font = [UIFont pfSCRegularFontWithSize:13];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = UIColorOfHex(0x485461);
        [successView addSubview:lbl];
        
        [_shareView addSubview:successView];
        _successView = successView;
    }
    return _successView;
}

#pragma mark - Animate
- (void)showWithAnimate {
    [UIView animateWithDuration:0.3 animations:^{
        _bgBtnView.alpha = 0.5;
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT - 250-50, SCREEN_WIDTH, 50+250 + kSafeBottomMargin);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideWithAnimate {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _bgBtnView.alpha = 0.0;
        _shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50+250 + kSafeBottomMargin);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//YXShareWXSession,
//YXShareWXTimeLine,
//YXShareQQ

- (void)shareCodeToThirdPlatform:(UIButton *)btn {
    [self dismiss];
    if (btn.tag == YXShareWXSession) { //微信
        [[WXApiManager shared] shareText:self.codeStr toPaltform:btn.tag];
    }else {
        [[QQApiManager shared] shareText:self.codeStr];
    }
}
#pragma mark - Targets
- (void)pasteToBoardAndDismiss {
    self.userInteractionEnabled = NO;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _codeStr;
    
    [_shareCollectionView removeFromSuperview];
    [self successView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideWithAnimate];
    });
}

- (void)dismiss {
    [self hideWithAnimate];
}

@end
