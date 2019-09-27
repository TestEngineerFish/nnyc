//
//  YXResultView.m
//  YXEDU
//
//  Created by yao on 2018/11/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXResultView.h"
#import "YXAnimatorStarView.h"
@interface YXResultView ()
@property (nonatomic, weak) UIImageView *resultImageView;
@property (nonatomic, weak) YXAnimatorStarView *starView;
@end
@implementation YXResultView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.whiteColor.CGColor;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = UIColorOfHex(0xD0E0EF).CGColor;
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        
        UIImageView *resultImageView = [[UIImageView alloc] init];
        [self addSubview:resultImageView];
        _resultImageView = resultImageView;

        [resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(-6);
            make.right.equalTo(self).offset(6);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        [self starView];
        
    }
    return self;
}

// 显示一个提示动画
- (void)setResultType:(YXReultStateType)resultType {
    if (resultType == YXReultStateNone) {
        self.resultImageView.hidden    = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }else {
        self.resultImageView.hidden    = NO;
        NSString *imageName = nil;
        if (resultType == YXReultStateCorrect) {
            imageName = @"正确";
            self.layer.borderColor = UIColorOfHex(0x09E9BC).CGColor;
            [self.starView launchAnimations];
        }else {
            imageName = @"错误";
            self.layer.borderColor = UIColorOfHex(0xFC7D8B).CGColor;
        }
        self.resultImageView.image    = [UIImage imageNamed:imageName];
    }
}


- (YXAnimatorStarView *)starView {
    if (!_starView) {
        YXAnimatorStarView *starView = [[YXAnimatorStarView alloc] initWithRadius:22 position:CGPointZero];
        [self addSubview:starView];
        _starView = starView;
    }
    return _starView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _starView.position = CGPointMake(_resultImageView.centerX + 5, _resultImageView.centerY - 5);
//    CGFloat trOff = 6;
//    CGSize size = self.size;
//    self.resultImageView.frame = CGRectMake(size.width + trOff - wh, -trOff, wh, wh);
}


@end
