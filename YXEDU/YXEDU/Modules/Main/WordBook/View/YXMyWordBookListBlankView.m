//
//  YXMyWordBookListBlankView.m
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookListBlankView.h"
@interface YXMyWordBookListBlankView ()
@property (nonatomic, weak) UIImageView *blankIcon;
@property (nonatomic, weak) UILabel *blankTipsLabel;
//@property (nonatomic, weak) UILabel *firstStepLabel;
//@property (nonatomic, weak) UILabel *secondStepLabel;
@property (nonatomic, weak) YXSpringAnimateButton *createWordBookBtn;
//@property (nonatomic, weak) YXSpringAnimateButton *shareWordBookBtn;
@end

@implementation YXMyWordBookListBlankView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorOfHex(0xF3F8FB);
        [self.blankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(MakeAdaptCGSize(174, 140));
            make.top.mas_equalTo(self).offset(AdaptSize(40));
        }];
        
        [self.blankTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.blankIcon.mas_bottom).offset(AdaptSize(25));
        }];
        
//        UIImageView *downArrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrowIcon"]];
//        [self addSubview:downArrowIcon];
//        [downArrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self.blankTipsLabel.mas_bottom).offset(AdaptSize(15));
//            make.size.mas_equalTo(MakeAdaptCGSize(20, 75));
//        }];
//
//        [self.firstStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(downArrowIcon.mas_bottom).offset(AdaptSize(20));
//        }];
        
        [self.createWordBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.blankTipsLabel.mas_bottom).offset(AdaptSize(46));
            make.size.mas_equalTo(MakeAdaptCGSize(284, 54));
        }];
        
//        [self.secondStepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self.createWordBookBtn.mas_bottom).offset(AdaptSize(42));
//        }];
//
//        [self.shareWordBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self.secondStepLabel.mas_bottom).offset(AdaptSize(15));
//            make.size.mas_equalTo(MakeAdaptCGSize(284, 54));
//        }];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<YXMyWordBookActionProtocol>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}
#pragma mark - actions
- (void)createWordBook {
    if ([self.delegate respondsToSelector:@selector(myWordBookDoCreateAction)]) {
        [self.delegate myWordBookDoCreateAction];
    }
}

- (void)shareWordBook {
    if ([self.delegate respondsToSelector:@selector(myWordBookDoShareAction)]) {
        [self.delegate myWordBookDoShareAction];
    }
}

#pragma mark - subviews
- (UIImageView *)blankIcon {
    if (!_blankIcon) {
        UIImageView *blankIcon = [[UIImageView alloc] init];
        blankIcon.image = [UIImage imageNamed:@"WordBookListblankIcon"];
        [self addSubview:blankIcon];
        _blankIcon = blankIcon;
    }
    return _blankIcon;
}

- (UILabel *)blankTipsLabel {
    if (!_blankTipsLabel) {
        UILabel *blakTipsLabel = [[UILabel alloc] init];
        blakTipsLabel.text = @"您还没创建创建词单，快去创建一个吧";
        blakTipsLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(16)];
        blakTipsLabel.textColor = UIColorOfHex(0x485461);
        [self addSubview:blakTipsLabel];
        _blankTipsLabel = blakTipsLabel;
    }
    return _blankTipsLabel;
}


//- (UILabel *)firstStepLabel {
//    if (!_firstStepLabel) {
//        UILabel *firstStepLabel = [[UILabel alloc] init];
//        firstStepLabel.text = @"方法1：试着自己选择单词，完成词单的创建";
//        firstStepLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(14)];
//        firstStepLabel.textColor = UIColorOfHex(0x8095AB);
////        [self addSubview:firstStepLabel];
//        _firstStepLabel = firstStepLabel;
//    }
//    return _firstStepLabel;
//}
//
//- (UILabel *)secondStepLabel {
//    if (!_secondStepLabel) {
//        UILabel *secondStepLabel = [[UILabel alloc] init];
//        secondStepLabel.text = @"方法2：使用老师/同学提供的分享码，快速创建";
//        secondStepLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(14)];
//        secondStepLabel.textColor = UIColorOfHex(0x8095AB);
////        [self addSubview:secondStepLabel];
//        _secondStepLabel = secondStepLabel;
//    }
//    return _secondStepLabel;
//}

- (YXSpringAnimateButton *)createWordBookBtn {
    if (!_createWordBookBtn) {
        YXSpringAnimateButton *createWordBookBtn = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        [createWordBookBtn addTarget:self action:@selector(createWordBook) forControlEvents:UIControlEventTouchUpInside];
        [createWordBookBtn setImage:[UIImage imageNamed:@"addWordBookIcon"] forState:UIControlStateNormal];
        [createWordBookBtn setTitle:@" 创建自选词单" forState:UIControlStateNormal];
        [createWordBookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        createWordBookBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [createWordBookBtn setBackgroundImage:[UIImage imageNamed:@"createWordBookBtnLongIcon"] forState:UIControlStateNormal];
        [self addSubview:createWordBookBtn];
        _createWordBookBtn = createWordBookBtn;
    }
    return _createWordBookBtn;
}

//- (YXSpringAnimateButton *)shareWordBookBtn {
//    if (!_shareWordBookBtn) {
//        YXSpringAnimateButton *shareWordBookBtn = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
//        [shareWordBookBtn addTarget:self action:@selector(shareWordBook) forControlEvents:UIControlEventTouchUpInside];
//        [shareWordBookBtn setTitle:@" 输入分享码" forState:UIControlStateNormal];
//        [shareWordBookBtn setImage:[UIImage imageNamed:@"shareCodeIcon"] forState:UIControlStateNormal];
//        [shareWordBookBtn setTitleColor:[UIColor secondTitleColor] forState:UIControlStateNormal];
//        shareWordBookBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
//        [shareWordBookBtn setBackgroundImage:[UIImage imageNamed:@"shareWordBookBtnLongIcon"] forState:UIControlStateNormal];
////        [self addSubview:shareWordBookBtn];
//        _shareWordBookBtn = shareWordBookBtn;
//    }
//    return _shareWordBookBtn;
//}

@end
