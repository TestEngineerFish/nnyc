//
//  YXKeyPointWordCell.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/6/4.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXKeyPointWordCell.h"
#import "YXAudioAnimations.h"
#import "YXWordDetailModel.h"
#import "YXWordModelManager.h"
#import "YXUtils.h"
#import "AVAudioPlayerManger.h"
#import "YXRemotePlayer.h"
#import "YXWordDetailModel.h"

@interface YXKeyPointWordCell ()
@property (nonatomic, strong) YXAudioAnimations *speakerBtn;
@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UILabel *phoneticSymbolLabel;
@property (nonatomic, strong) UILabel *explanLabel;
@property (nonatomic, weak)   UIView *lineView;
@property (nonatomic, strong) YXWordDetailModel *wordDetailModel;
@property (nonatomic, strong)YXRemotePlayer *remotePlayer;
@end

@implementation YXKeyPointWordCell

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
    [self.speakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(20.f);
        make.size.mas_equalTo(CGSizeMake(20.f, 18.f));
    }];
    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.speakerBtn.mas_right).with.offset(10.f);
    }];
    [self.phoneticSymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.wordLabel.mas_right).with.offset(10.f);
    }];
    [self.explanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.phoneticSymbolLabel.mas_right).with.offset(10.f);
        make.right.lessThanOrEqualTo(self).with.offset(-20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(17.f);
        make.right.equalTo(self).with.offset(-17.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self);
    }];
}

- (void)setCell:(YXKeyPointWordModel *)model {
    [self initUI];
    [YXWordModelManager quardWithWordId:model.wordId.stringValue completeBlock:^(id obj, BOOL result) {
        if (result) {
            self.wordDetailModel = obj;
            self.wordLabel.text = self.wordDetailModel.word;
            self.phoneticSymbolLabel.text = [YXConfigure shared].confModel.baseConfig.speech ?  self.wordDetailModel.usphone : self.wordDetailModel.ukphone;
            self.explanLabel.text = self.wordDetailModel.explainText;
        } else {
            NSLog(@"查询数据失败");
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - subviews

- (YXAudioAnimations *)speakerBtn {
    if (!_speakerBtn) {
        YXAudioAnimations *speakerBtn = [YXAudioAnimations playSpeakerAnimation:NO];
        [speakerBtn addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:speakerBtn];
        _speakerBtn = speakerBtn;
    }
    return _speakerBtn;
}

- (UILabel *)wordLabel {
    if (!_wordLabel) {
        UILabel *wordLabel = [[UILabel alloc] init];
        wordLabel.font = [UIFont systemFontOfSize:15.f];
        wordLabel.textColor = UIColorOfHex(0x485461);
        wordLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:wordLabel];
        _wordLabel = wordLabel;
    }
    return _wordLabel;
}

- (UILabel *)phoneticSymbolLabel {
    if (!_phoneticSymbolLabel) {
        UILabel *phoneticSymbolLabel = [[UILabel alloc] init];
        phoneticSymbolLabel.font = [UIFont systemFontOfSize:15.f];
        phoneticSymbolLabel.textColor = UIColorOfHex(0x55A7FD);
        phoneticSymbolLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:phoneticSymbolLabel];
        _phoneticSymbolLabel = phoneticSymbolLabel;
    }
    return _phoneticSymbolLabel;
}

- (UILabel *)explanLabel {
    if (!_explanLabel) {
        UILabel *explanLabel = [[UILabel alloc] init];
        explanLabel.font = [UIFont systemFontOfSize:15.f];
        explanLabel.textColor = UIColorOfHex(0x485461);
        [self addSubview:explanLabel];
        _explanLabel = explanLabel;
    }
    return _explanLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorOfHex(0xE9EFF4);
        [self addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}

#pragma mark - event

- (void)playAudio {
    if (!self.wordDetailModel) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(stopArticleAudio)]) {
        [self.delegate stopArticleAudio];
    }
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

@end
