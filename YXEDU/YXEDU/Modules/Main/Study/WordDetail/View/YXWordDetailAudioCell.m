//
//  YXWordDetailAudioCell.m
//  YXEDU
//
//  Created by yao on 2018/11/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordDetailAudioCell.h"

#import "AVAudioPlayerManger.h"

@interface YXWordDetailAudioCell ()
//@property (nonatomic, strong) YXAudioAnimations *speakButton;
@end

@implementation YXWordDetailAudioCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.speakButton = [YXAudioAnimations playSpeakerAnimation:NO];
        [self.speakButton addTarget:self action:@selector(speakButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.speakButton];
        
        [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-40);
        }];
        
        [self.speakButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)setUrlKey:(NSString *)urlKey {
    _urlKey = urlKey;
    self.speakButton.hidden = (urlKey == nil);
}
- (void)speakButtonClicked:(UIButton *)btn {
    if(self.urlKey) {
        [[AVAudioPlayerManger shared] startPlay:[NSURL URLWithString:self.urlKey] ];
        __weak typeof(self) weakSelf = self;
        [[AVAudioPlayerManger shared] startPlay:[NSURL URLWithString:self.urlKey] finish:^(BOOL isSuccess) {
            [weakSelf playWordSoundFinished];
        }];
    }
}

- (void)playWordSound {
//    [self.speakButton startAnimating];
    [self speakButtonClicked:nil];
}

- (void)playWordSoundFinished{
    [self.speakButton stopAnimating];// 结束播放
}

@end
