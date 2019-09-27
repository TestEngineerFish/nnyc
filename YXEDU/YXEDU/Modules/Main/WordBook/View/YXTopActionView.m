//
//  YXTopActionView.m
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXTopActionView.h"
@interface YXTopActionView ()
@property (nonatomic, weak) YXSpringAnimateButton *createWordBookBtn;
@property (nonatomic, weak) YXSpringAnimateButton *shareWordBookBtn;
@end

@implementation YXTopActionView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorOfHex(0xF3F8FB);
        
        [self shareWordBookBtn];
        [self createWordBookBtn];
        [self.shareWordBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(AdaptSize(5));
            make.right.mas_equalTo(self.mas_centerX).offset(AdaptSize(-9));
            make.size.mas_equalTo(MakeAdaptCGSize(164, 47));
        }];
        
        [self.createWordBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.centerY.equalTo(self.shareWordBookBtn);
            make.left.mas_equalTo(self.mas_centerX).offset(AdaptSize(9));
        }];
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
- (YXSpringAnimateButton *)createWordBookBtn {
    if (!_createWordBookBtn) {
        YXSpringAnimateButton *createWordBookBtn = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        [createWordBookBtn addTarget:self action:@selector(createWordBook) forControlEvents:UIControlEventTouchUpInside];
        [createWordBookBtn setImage:[UIImage imageNamed:@"addWordBookIcon"] forState:UIControlStateNormal];
        [createWordBookBtn setTitle:@" 创建自选词单" forState:UIControlStateNormal];
        [createWordBookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        createWordBookBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [createWordBookBtn setBackgroundImage:[UIImage imageNamed:@"createWordBookBtnSmallIcon"] forState:UIControlStateNormal];
        createWordBookBtn.tag = 1001;
        [self addSubview:createWordBookBtn];
        _createWordBookBtn = createWordBookBtn;
    }
    return _createWordBookBtn;
}

- (YXSpringAnimateButton *)shareWordBookBtn {
    if (!_shareWordBookBtn) {
        YXSpringAnimateButton *shareWordBookBtn = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        [shareWordBookBtn addTarget:self action:@selector(shareWordBook) forControlEvents:UIControlEventTouchUpInside];
        [shareWordBookBtn setTitle:@" 输入分享码" forState:UIControlStateNormal];
        shareWordBookBtn.tag = 1000;
        [shareWordBookBtn setImage:[UIImage imageNamed:@"shareCodeIcon"] forState:UIControlStateNormal];
        [shareWordBookBtn setTitleColor:[UIColor secondTitleColor] forState:UIControlStateNormal];
        shareWordBookBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [shareWordBookBtn setBackgroundImage:[UIImage imageNamed:@"shareWordBookBtnSmallIcon"] forState:UIControlStateNormal];
        [self addSubview:shareWordBookBtn];
        _shareWordBookBtn = shareWordBookBtn;
    }
    return _shareWordBookBtn;
}

- (void)setManageState:(BOOL)manageState {
    _manageState = manageState;
    self.createWordBookBtn.enabled = !manageState;
    self.shareWordBookBtn.enabled = !manageState;
}
@end
