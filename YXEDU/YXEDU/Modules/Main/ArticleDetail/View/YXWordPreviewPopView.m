//
//  YXWordPreviewPopView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXWordPreviewPopView.h"
#import "YXAudioAnimations.h"
#import "BSUtils.h"
#import "YXUtils.h"
#import "AVAudioPlayerManger.h"
#import "YXRemotePlayer.h"
#import "YXWordModelManager.h"

@interface YXWordPreviewPopView ()

@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) YXAudioAnimations *speakerBtn;
@property (nonatomic, strong) UILabel *phoneticSymbolLabel;
@property (nonatomic, strong) UILabel *explanLabel;
@property (nonatomic, strong) UILabel *memoryLabel;
@property (nonatomic, strong) YXWordDetailModel *wordDetailModel;
@property (nonatomic, strong) YXRemotePlayer *remotePlayer;
@property (nonatomic, weak)   UIView *contentView;

@end

@implementation YXWordPreviewPopView

+ (YXWordPreviewPopView *)createWordPreviewPopView:(YXWordDetailModel *)wordModel {
    YXWordPreviewPopView *view = [[YXWordPreviewPopView alloc] init];
    view.wordDetailModel = wordModel;
    [view checkWordFavState];
    //设置UI
    [view initUI];
    view.memoryLabel.text = [view getContentText:wordModel];
    [view playAudio];
    return view;
}

- (NSString *)getContentText:(YXWordDetailModel *)wordModel {
    NSInteger wordToolkitState = [YXConfigure shared].confModel.baseConfig.wordToolkitState;
    if (wordToolkitState == 2) {
        //获取识记方法
        NSDictionary *dict = [BSUtils dictionaryWithJsonString:wordModel.toolkit];
        NSDictionary *memoryKey = [dict objectForKey:@"memoryKey"];
        NSArray *contents = [memoryKey objectForKey:@"content"];
        NSString *title = [contents.firstObject objectForKey:@"title"];
        NSAttributedString *attriStrTitle = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        NSString *content = [contents.firstObject objectForKey:@"content"];
        NSAttributedString *attriStrContent = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        return [NSString stringWithFormat:@"识记方法: %@\n%@", [attriStrTitle string], [attriStrContent string]];
    } else {
        NSAttributedString *engAttr = [[NSMutableAttributedString alloc] initWithData:[wordModel.eng dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        NSAttributedString *chsAttr = [[NSMutableAttributedString alloc] initWithData:[wordModel.chs dataUsingEncoding:NSUnicodeStringEncoding] options: @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error: nil];
        return [NSString stringWithFormat:@"%@\n%@", [engAttr string], [chsAttr string]];
    }
}

- (void)playAudio {
    [self.speakerBtn startAnimating];
    self.speakerBtn.userInteractionEnabled = NO;
    NSString *subpath = [self.wordDetailModel.bookId stringByAppendingPathComponent:self.wordDetailModel.curMaterialSubPath];
    NSString *fullPath = [[YXUtils resourcePath] DIR:subpath];
    __weak typeof(self) weakSelf = self;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        [[AVAudioPlayerManger shared] startPlay:[NSURL fileURLWithPath:fullPath] finish:^(BOOL isSuccess) {
            [weakSelf.speakerBtn stopAnimating];
            self.speakerBtn.userInteractionEnabled = YES;
        }];
    } else {
        [self playRemoteVoice];
    }
}

- (void)dealloc
{
    if (self.remotePlayer) {
        [self.remotePlayer releaseSource];
    }
}

- (void)playRemoteVoice {
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:kWindow title:@"网络不给力"];
        [self.speakerBtn stopAnimating];
        self.speakerBtn.userInteractionEnabled = YES;
        return;
    }
    NSString *dir = [YXConfigure shared].isUsStyle ? self.wordDetailModel.usvoice : self.wordDetailModel.ukvoice;
    NSString *remoteSource = [NSString stringWithFormat:@"%@%@",[YXConfigure shared].confModel.cdn,dir];
    self.remotePlayer = [[YXRemotePlayer alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.remotePlayer startPlay:[NSURL URLWithString:remoteSource] finish:^(BOOL isSuccess) {
        [weakSelf.speakerBtn stopAnimating];
        self.speakerBtn.userInteractionEnabled = YES;
    }];
    NSLog(@"本地不存在音频文件，播放链接");
}

- (void)initUI {

    [self.upImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upImageView.mas_bottom).with.offset(-2);
        make.left.and.right.equalTo(self);
        make.height.equalTo(self).with.offset(-40);
    }];

    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.f);
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.right.equalTo(self.collectBtn.mas_left).with.offset(10.f);
        make.height.mas_equalTo(18.f);
    }];

    [self.speakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.top.equalTo(self.wordLabel.mas_bottom).with.offset(10.f);
        make.size.mas_equalTo(CGSizeMake(20.f, 18.f));
    }];

    [self.phoneticSymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speakerBtn.mas_right).with.offset(5.f);
        make.centerY.equalTo(self.speakerBtn);
        make.height.mas_equalTo(14.f);
    }];

    [self.explanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.top.equalTo(self.phoneticSymbolLabel.mas_bottom).with.offset(12.f);
        make.right.equalTo(self.contentView).with.offset(-10.f);
        make.height.mas_equalTo(14.f);
    }];

    [self.memoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.right.equalTo(self.contentView).with.offset(-10.f);
        make.top.equalTo(self.explanLabel.mas_bottom).with.offset(10.f);
    }];

    [self.checkDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memoryLabel.mas_bottom).with.offset(10.f);
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.height.mas_equalTo(15.f);
    }];

    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wordLabel);
        make.right.equalTo(self.contentView).with.offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(65.f, 25.f));
    }];

    [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).with.offset(-2);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];
    [self bringSubviewToFront:self.upImageView];
    [self bringSubviewToFront:self.downImageView];
}

#pragma mark - subviews

- (UILabel *)wordLabel {
    if (!_wordLabel) {
        UILabel *wordLabel = [[UILabel alloc] init];
        wordLabel.font = [UIFont systemFontOfSize: 18.f];
        wordLabel.textColor = UIColorOfHex(0x103B69);
        wordLabel.text = self.wordDetailModel.word;
        [self.contentView addSubview:wordLabel];
        _wordLabel = wordLabel;
    }
    return _wordLabel;
}

- (YXAudioAnimations *)speakerBtn {
    if (!_speakerBtn) {
        YXAudioAnimations *speakerBtn = [YXAudioAnimations playSpeakerAnimation:NO];
        speakerBtn.backgroundColor = UIColor.clearColor;
        [speakerBtn addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:speakerBtn];
        _speakerBtn = speakerBtn;
    }
    return _speakerBtn;
}

- (UILabel *)phoneticSymbolLabel {
    if (!_phoneticSymbolLabel) {
        UILabel *phoneticSymbolLabel = [[UILabel alloc] init];
        phoneticSymbolLabel.textColor = UIColorOfHex(0x55A7FD);
        phoneticSymbolLabel.font = [UIFont systemFontOfSize:13];
        phoneticSymbolLabel.text = [YXConfigure shared].confModel.baseConfig.speech ?  self.wordDetailModel.usphone : self.wordDetailModel.ukphone;
        [self.contentView addSubview:phoneticSymbolLabel];
        _phoneticSymbolLabel = phoneticSymbolLabel;
    }
    return _phoneticSymbolLabel;
}

- (UILabel *)explanLabel {
    if (!_explanLabel) {
        UILabel *explanLabel = [[UILabel alloc] init];
        explanLabel.textColor = UIColorOfHex(0x485461);
        explanLabel.font = [UIFont systemFontOfSize:14];
        explanLabel.text = self.wordDetailModel.explainText;
        [self.contentView addSubview:explanLabel];
        _explanLabel = explanLabel;
    }
    return _explanLabel;
}

- (UILabel *)memoryLabel {
    if (!_memoryLabel) {
        UILabel *memoryLabel = [[UILabel alloc] init];
        memoryLabel.textColor = UIColorOfHex(0x485461);
        memoryLabel.font = [UIFont systemFontOfSize:13.f];
        memoryLabel.numberOfLines = 2;
        [self.contentView addSubview:memoryLabel];
        _memoryLabel = memoryLabel;
    }
    return _memoryLabel;
}

- (UIButton *)checkDetail {
    if (!_checkDetail) {
        UIButton *checkDetail = [[UIButton alloc] init];
        [checkDetail setTitle:@"查看详情 > " forState:UIControlStateNormal];
        [checkDetail setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        checkDetail.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:checkDetail];
        _checkDetail = checkDetail;
    }
    return _checkDetail;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        UIButton *collectBtn = [[UIButton alloc] init];
        [collectBtn setImage:[UIImage imageNamed:@"收藏前"] forState:UIControlStateNormal];
        [collectBtn setImage:[UIImage imageNamed:@"收藏后"] forState:UIControlStateSelected];
        [collectBtn setTitle:@"" forState:UIControlStateNormal];
        [collectBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        [collectBtn addTarget:self action:@selector(hideCollectText:) forControlEvents:UIControlEventTouchDown];
        collectBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [collectBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        collectBtn.layer.cornerRadius = 12.f;
        collectBtn.layer.borderWidth = 1.f;
        collectBtn.layer.borderColor = UIColorOfHex(0x55A7FD).CGColor;
        [self.contentView addSubview:collectBtn];
        _collectBtn = collectBtn;
    }
    return _collectBtn;
}

- (UIImageView *)upImageView {
    if (!_upImageView) {
        UIImageView *upImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向上"]];
        [upImageView setHidden:YES];
        [self addSubview:upImageView];
        _upImageView = upImageView;
    }
    return _upImageView;
}

- (UIImageView *)downImageView {
    if (!_downImageView) {
        UIImageView *downImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向下"]];
        [downImageView setHidden:YES];
        [self addSubview:downImageView];
        _downImageView = downImageView;
    }
    return _downImageView;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = UIColor.clearColor;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(id)UIColorOfHex(0xDAF2FF).CGColor, (id)UIColorOfHex(0xF2FAFF).CGColor];
        gradientLayer.locations = @[@0.5, @1.0];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 50.f, 160.f);
        [contentView.layer addSublayer:gradientLayer];
        contentView.layer.cornerRadius = 6.f;
        contentView.layer.borderColor = UIColorOfHex(0xA3BFD5).CGColor;
        contentView.layer.borderWidth = 1.f;
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

#pragma mark - event

- (void)collectAction:(UIButton *)btn {
    [YXWordModelManager keepWordId:self.wordDetailModel.wordid bookId:self.wordDetailModel.bookId isFav:!btn.selected completeBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            btn.selected = !btn.selected;
            [self setFavStatus];
        }
    }];
}

- (void)hideCollectText:(UIButton *)btn {
    if (btn.selected) {
        [btn setTitle:@"" forState:UIControlStateNormal];
    } else {
        [btn setTitle:@" 收藏" forState:UIControlStateNormal];
    }

}

- (void)checkWordFavState {
    if (self.wordDetailModel) {
        [YXDataProcessCenter GET:DOMAIN_WORDFAVSTATE parameters:@{@"wordId" : self.wordDetailModel.wordid,@"bookId" : self.wordDetailModel.bookId} finshedBlock:^(YRHttpResponse *response, BOOL result) {
            if (result) {
                self.collectBtn.selected = [[response.responseObject objectForKey:@"isFav"] integerValue];
                [self setFavStatus];
            }
        }];
    }
}

- (void)setFavStatus {
    if (self.collectBtn.selected) {
        [self.collectBtn setTitle:@"" forState:UIControlStateSelected];
        [self.collectBtn setTitleColor:UIColor.clearColor forState:UIControlStateSelected];
        self.collectBtn.layer.borderColor = UIColor.clearColor.CGColor;
        [self.collectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wordLabel);
            make.right.equalTo(self).with.offset(-10.f);
            make.size.mas_equalTo(CGSizeMake(25, 25.f));
        }];
    } else {
        [self.collectBtn setTitle:@" 收藏" forState:UIControlStateNormal];
        [self.collectBtn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        self.collectBtn.layer.borderColor = UIColorOfHex(0x55A7FD).CGColor;
        [self.collectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wordLabel);
            make.right.equalTo(self).with.offset(-10.f);
            make.size.mas_equalTo(CGSizeMake(65.f, 25.f));
        }];
    }
}

@end
