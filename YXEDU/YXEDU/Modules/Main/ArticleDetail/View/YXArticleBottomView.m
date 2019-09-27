//
//  YXArticleBottomView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleBottomView.h"
#import "YXAudioAnimations.h"

@interface YXArticleBottomView()
@property (nonatomic, weak)   UIView *topLineView;
@property (nonatomic, strong) YXAudioAnimations *playAudioIcon;
@property (nonatomic, weak)   UIView *shadeView;
@property (nonatomic, strong) UILabel *playAudioLabel;
@property (nonatomic, weak)   UIView *translateView;
@property (nonatomic, strong) UIImageView *translateIcon;
@property (nonatomic, strong) UILabel *translateLabel;
@property (nonatomic, assign) BOOL inTranslate;
@property (nonatomic, weak)   UIView *readAloudView;
@property (nonatomic, strong) UIImageView *readAloudIcon;
@property (nonatomic, strong) UILabel *readAloudLabel;
@end

@implementation YXArticleBottomView

#pragma mark - subviews

- (UIView *)topLineView {
    if (!_topLineView) {
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = UIColorOfHex(0xE9EFF4);
        [self addSubview:topLineView];
        _topLineView = topLineView;
    }
    return _topLineView;
}

- (UIView *)playAudioView {
    if (!_playAudioView) {
        UIView *playAudioView = [[UIView alloc] init];
        playAudioView.backgroundColor = UIColor.clearColor;
        [self addSubview:playAudioView];
        _playAudioView = playAudioView;
    }
    return _playAudioView;
}

- (UIView *)shadeView {
    if (!_shadeView) {
        UIView *shadeView = [[UIView alloc] init];
        shadeView.backgroundColor = UIColor.clearColor;
        [shadeView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayController:)];
        [shadeView addGestureRecognizer:tap];
        [self.playAudioView addSubview:shadeView];
        [self.playAudioView bringSubviewToFront:shadeView];
        _shadeView = shadeView;
    }
    return _shadeView;
}

- (YXAudioAnimations *)playAudioIcon {
    if (!_playAudioIcon) {
        YXAudioAnimations *playAudioIcon = [YXAudioAnimations playSpeakerAnimation:NO];
        playAudioIcon.gifImageView.image = [UIImage imageNamed: @"soundBtnUnselect"];
        [playAudioIcon setUserInteractionEnabled:NO];
        playAudioIcon.backgroundColor = UIColor.clearColor;
        [self.playAudioView addSubview:playAudioIcon];
        _playAudioIcon = playAudioIcon;
    }
    return _playAudioIcon;
}

- (UILabel *)playAudioLabel {
    if (!_playAudioLabel) {
        UILabel *playAudioLabel = [[UILabel alloc] init];
        playAudioLabel.text = @"听声";
        playAudioLabel.font = [UIFont systemFontOfSize:11.f];
        playAudioLabel.textColor = UIColorOfHex(0x8893B9);
        [self.playAudioView addSubview:playAudioLabel];
        _playAudioLabel = playAudioLabel;
    }
    return _playAudioLabel;
}

- (UIView *)translateView {
    if (!_translateView) {
        UIView *translateView = [[UIView alloc] init];
        translateView.backgroundColor = UIColor.clearColor;
        [translateView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
        [translateView addGestureRecognizer:tap];
        [self addSubview:translateView];
        _translateView = translateView;
    }
    return _translateView;
}

- (UIImageView *)translateIcon {
    if (!_translateIcon) {
        UIImageView *translateIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"translateBtnUnselect"]];
        [self.translateView addSubview:translateIcon];
        _translateIcon = translateIcon;
    }
    return _translateIcon;
}

- (UILabel *)translateLabel {
    if (!_translateLabel) {
        UILabel *translateLabel = [[UILabel alloc] init];
        translateLabel.text = @"翻译";
        translateLabel.font = [UIFont systemFontOfSize:11.f];
        translateLabel.textColor = UIColorOfHex(0x8893B9);
        [self.translateView addSubview:translateLabel];
        _translateLabel = translateLabel;
    }
    return _translateLabel;
}

- (UIView *)readAloudView {
    if (!_readAloudView) {
        UIView *readAloudView = [[UIView alloc] init];
        readAloudView.backgroundColor = UIColor.clearColor;
        [readAloudView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readAloud:)];
        [readAloudView addGestureRecognizer:tap];
        [self addSubview:readAloudView];
        _readAloudView = readAloudView;
    }
    return _readAloudView;
}

- (UIImageView *)readAloudIcon {
    if (!_readAloudIcon) {
        UIImageView *readAloudIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readAloudUnselect"]];
        [self.readAloudView addSubview:readAloudIcon];
        _readAloudIcon = readAloudIcon;
    }
    return _readAloudIcon;
}

- (UILabel *)readAloudLabel {
    if (!_readAloudLabel) {
        UILabel *readAloudLabel = [[UILabel alloc] init];
        readAloudLabel.text = @"跟读";
        readAloudLabel.font = [UIFont systemFontOfSize:11.f];
        readAloudLabel.textColor = UIColorOfHex(0x8893B9);
        [self.readAloudView addSubview:readAloudLabel];
        _readAloudLabel = readAloudLabel;
    }
    return _readAloudLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = UIColor.whiteColor;

    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self);
        make.height.mas_equalTo(1.f);
    }];

    [self.playAudioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.equalTo(self);
        make.width.mas_equalTo(26.f);
        make.left.mas_equalTo(20.f);
    }];
    [self.playAudioIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.playAudioView.mas_width);
        make.top.equalTo(self.playAudioView).with.offset(5.f);
        make.left.equalTo(self.playAudioView);
    }];
    [self.playAudioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.playAudioView);
        make.top.equalTo(self.playAudioIcon.mas_bottom).with.offset(5.f);
    }];
    [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playAudioView);
    }];
    [self.translateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.equalTo(self);
        make.width.mas_equalTo(26.f);
        make.centerX.equalTo(self);
    }];
    [self.translateIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.translateView.mas_width);
        make.top.equalTo(self.translateView).with.offset(5.f);
        make.left.equalTo(self.translateView);
    }];
    [self.translateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.translateView);
        make.top.equalTo(self.translateIcon.mas_bottom).with.offset(5.f);
    }];
    [self.readAloudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.equalTo(self);
        make.width.mas_equalTo(26.f);
        make.right.mas_equalTo(-20.f);
    }];
    [self.readAloudIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.readAloudView.mas_width);
        make.top.equalTo(self.readAloudView).with.offset(5.f);
        make.left.equalTo(self.readAloudView);
    }];
    [self.readAloudLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.readAloudView);
        make.top.equalTo(self.readAloudIcon.mas_bottom).with.offset(5.f);
    }];
}

#pragma mark - event

- (void)showSpeakerAnimation {
    [self.playAudioIcon startAnimating];
}

- (void)stopSpeakerAnimation {
    [self.playAudioIcon stopAnimating];
}


- (void)showPlayController:(UITapGestureRecognizer *)tap {
    self.isShow = !self.isShow;
    if (self.delegate) {
        [self.delegate showPlayControllerView:self.isShow];
    }
}

- (void)translate:(UITapGestureRecognizer *)tap {
    self.inTranslate = !self.inTranslate;
    if (self.delegate) {
        [self.delegate translateArticle:self.inTranslate];
    }
}

- (void)readAloud:(UITapGestureRecognizer *)tap {
    //跳转到跟读页面
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    if (isShow) {
        self.playAudioIcon.gifImageView.image = [UIImage imageNamed: @"soundBtnSelected"];
        self.playAudioLabel.textColor = UIColorOfHex(0x55A7FD);
    } else {
        self.playAudioIcon.gifImageView.image = [UIImage imageNamed: @"soundBtnUnselect"];
        self.playAudioLabel.textColor = UIColorOfHex(0x8893B9);
    }
}

- (void)setInTranslate:(BOOL)inTranslate {
    _inTranslate = inTranslate;
    if (inTranslate) {
        self.translateIcon.image = [UIImage imageNamed: @"translateBtnSelected"];
        self.translateLabel.textColor = UIColorOfHex(0x55A7FD);
    } else {
        self.translateIcon.image = [UIImage imageNamed: @"translateBtnUnselect"];
        self.translateLabel.textColor = UIColorOfHex(0x8893B9);
    }
}

@end
