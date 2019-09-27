//
//  YXTostView.m
//  YXEDU
//
//  Created by yao on 2018/11/9.
//  Copyright © 2018年 shiji. All rights reserved.
//
#import "YXTostView.h"

@interface YXTostView ()


@end

@implementation YXTostView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.layer.cornerRadius = 7.0;
        self.layer.masksToBounds = YES;
        
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.text = @"5";
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont iconFontWithSize:49];
        [self addSubview:countLabel];
        _countLabel = countLabel;
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(20);
        }];
        
        UILabel *countingTips = [[UILabel alloc] init];
        countingTips.textColor = [UIColor whiteColor];
        countingTips.font = [UIFont systemFontOfSize:14];
        countingTips.text = @"松开手指，取消录音";
        [self addSubview:countingTips];
        _countingTips = countingTips;
        [countingTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(countLabel.mas_bottom).offset(20);
        }];
    }
    return self;
}
- (void)setCurrentRecordState:(YXVoiceRecordState)currentRecordState {
    if (currentRecordState == YXVoiceRecordState_Normal) {
        [self delayHide:NO];
    }else {
        self.hidden = NO;
        if (currentRecordState == YXVoiceRecordState_Recording) {
            self.countingTips.text = @"手指上滑，取消录音";
            self.countingTips.backgroundColor = [UIColor clearColor];
        } else if (currentRecordState == YXVoiceRecordState_ReleaseToCancel) {
            self.countingTips.text = @"松开手指，取消录音";
            self.countingTips.backgroundColor = UIColorOfHex(0xbc2f2d);//[UIColor redColor];
        }else if (currentRecordState == YXBVoiceRecordState_RecordTooShort) {
            self.countingTips.text = @"录音时间过短";
            self.countingTips.backgroundColor = [UIColor clearColor];
            self.countLabel.text = kIconFont_excalmatory;
        }
    }
}

- (void)showRecordCounting:(CGFloat)count {
    double sss = ceilf(count);
    NSString *text = [NSString stringWithFormat:@"%.f",sss];
    self.countLabel.text = text;//ceilf(count)
}

- (void)delayHide:(BOOL)isDelay {
    if (isDelay) {
        self.hidden = YES;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//        });
    }else {
        self.hidden = YES;
    }
}
@end
