//
//  YXNNCareerView.m
//  YXEDU
//
//  Created by yao on 2018/11/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXNNCareerView.h"

@interface YXNNCareerButton ()
@property (nonatomic, weak)UILabel *numberL;
@property (nonatomic, weak)UILabel *tipsL;
@end

@implementation YXNNCareerButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        UILabel *numberL = [[UILabel alloc] init];
        numberL.font = [UIFont boldSystemFontOfSize:AdaptSize(22)];
        numberL.textColor = [UIColor whiteColor];
        [self addSubview:numberL];
        _numberL = numberL;
        [numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(AdaptSize(25));
            make.top.equalTo(self).offset(AdaptSize(15));
        }];
        
        UILabel *tipsL = [[UILabel alloc] init];
        tipsL.font = [UIFont systemFontOfSize:AdaptSize(12)];
        tipsL.textColor = [UIColor whiteColor];
        [self addSubview:tipsL];
        _tipsL = tipsL;
        
        [tipsL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberL);
            make.top.equalTo(numberL.mas_bottom).offset(AdaptSize(2));
        }];
    }
    return self;
}

- (void)setNumber:(NSString *)number {
    _number = number;
    self.numberL.text = number;
}
@end

@implementation YXNNCareerView
{
    YXNNCareerButton *_haveLearnBtn;
    YXNNCareerButton *_collectionbtn;
    YXNNCareerButton *_wrongBookbtn;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *centerTitleLab = [[UILabel alloc]init];
        centerTitleLab.textAlignment = NSTextAlignmentLeft;
        centerTitleLab.textColor = UIColorOfHex(0x434A5D);
        centerTitleLab.text = @"念念生涯数据";
        centerTitleLab.font = [UIFont systemFontOfSize:AdaptSize(15)];
        [self addSubview:centerTitleLab];
        [centerTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(AdaptSize(16));
            make.top.equalTo(self);
            make.height.mas_equalTo(AdaptSize(15));
        }];
        
        NSArray *images = @[@"career0",@"career1",@"career2"];
        NSArray *numbers = @[@"--",@"--",@"--"];
        NSArray *titles = @[@"已学单词",@"收藏夹",@"错词本"];
        for (int i = 0; i < images.count; i++) {
            YXNNCareerButton *button = [[YXNNCareerButton alloc] init];
            [button addTarget:self action:@selector(myCareerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            button.tipsL.text = titles[i];
            button.numberL.text = numbers[i];
            button.tag = 1000 + i;
            [self addSubview:button];
        }
        
        [self.collectionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerTitleLab.mas_bottom).offset(AdaptSize(8));
            make.size.mas_equalTo(MakeAdaptCGSize(133, 89));
            make.centerX.equalTo(self);
        }];
        
        [self.haveLearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.collectionbtn);
            make.size.equalTo(self.collectionbtn);
        }];
        
        [self.wrongBookbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self.collectionbtn);
            make.size.equalTo(self.collectionbtn);
        }];
    }
    return self;
}

- (void)myCareerBtnClick:(UIButton *)btn {
    if (self.careerViewClickedBlock) {
        self.careerViewClickedBlock(btn.tag - 1000);
    }
}

- (YXNNCareerButton *)haveLearnBtn {
    if (!_haveLearnBtn) {
        _haveLearnBtn = [self viewWithTag:1000];
    }
    return _haveLearnBtn;
}

- (YXNNCareerButton *)collectionbtn {
    if (!_collectionbtn) {
        _collectionbtn = [self viewWithTag:1001];
    }
    return _collectionbtn;
}

- (YXNNCareerButton *)wrongBookbtn {
    if (!_wrongBookbtn) {
        _wrongBookbtn = [self viewWithTag:1002];
    }
    return _wrongBookbtn;
}

@end

