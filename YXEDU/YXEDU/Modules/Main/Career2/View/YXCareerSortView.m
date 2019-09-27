//
//  YXCareerSortView.m
//  YXEDU
//
//  Created by yixue on 2019/2/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerSortView.h"

@interface YXCareerSortView ()

@property (nonatomic, strong) NSMutableArray *btnAry;
@property (nonatomic, strong) NSMutableArray *bgAry;

@end

@implementation YXCareerSortView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 142, 110)];
        bgImage.image = [UIImage imageNamed:@"sortBg"];
        [self addSubview:bgImage];
        
        UILabel *leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(29, 14, 26, 14)];
        leftLbl.text = @"时间";
        leftLbl.font = [UIFont pfSCRegularFontWithSize:13];
        leftLbl.textColor = UIColorOfHex(0x849EC5);
        [self addSubview:leftLbl];
        
        UILabel *rightLbl = [[UILabel alloc] initWithFrame:CGRectMake(86, 14, 26, 14)];
        rightLbl.text = @"字母";
        rightLbl.font = [UIFont pfSCRegularFontWithSize:13];
        rightLbl.textColor = UIColorOfHex(0x849EC5);
        [self addSubview:rightLbl];
        
        _bgAry = [[NSMutableArray alloc] init];
        [_bgAry addObject:bgImage];
        [_bgAry addObject:leftLbl];
        [_bgAry addObject:rightLbl];
        
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(19, 39, 45, 20)];
        [btn1 setTitle:@"倒序" forState:UIControlStateNormal];
        [btn1 setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont pfSCRegularFontWithSize:12];
        [self addSubview:btn1];
        [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(19, 70, 45, 20)];
        [btn2 setTitle:@"正序" forState:UIControlStateNormal];
        [btn2 setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont pfSCRegularFontWithSize:12];
        [self addSubview:btn2];
        [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(77, 39, 45, 20)];
        [btn3 setTitle:@"A-Z" forState:UIControlStateNormal];
        [btn3 setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        btn3.titleLabel.font = [UIFont pfSCRegularFontWithSize:12];
        [self addSubview:btn3];
        [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(77, 70, 45, 20)];
        [btn4 setTitle:@"Z-A" forState:UIControlStateNormal];
        [btn4 setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        btn4.titleLabel.font = [UIFont pfSCRegularFontWithSize:12];
        [self addSubview:btn4];
        [btn4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnAry = [[NSMutableArray alloc] init];
        [_btnAry addObject:btn1];
        [_btnAry addObject:btn2];
        [_btnAry addObject:btn3];
        [_btnAry addObject:btn4];
    }
    return self;
}

- (void)setCareerModel:(YXCareerModel *)careerModel {
    _careerModel = careerModel;
    if ([_careerModel.item  isEqual: @"new"]) {
        UILabel *leftLbl = _bgAry[1];
        [leftLbl removeFromSuperview];
        UIButton *btn1 = _btnAry[0];
        [btn1 removeFromSuperview];
        UIButton *btn2 = _btnAry[1];
        [btn2 removeFromSuperview];
        
        UIImageView *bgImage = _bgAry[0];
        bgImage.frame = CGRectMake(0, 0, 72, 110);
        
        UILabel *rightLbl = _bgAry[2];
        rightLbl.frame = CGRectMake(24, 14, 26, 14);
        UIButton *btn3 = _btnAry[2];
        btn3.frame = CGRectMake(14, 39, 45, 20);
        UIButton *btn4 = _btnAry[3];
        btn4.frame = CGRectMake(14, 70, 45, 20);
    }
    
    for (UIButton *btn in _btnAry) {
        [btn setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
    }
    if (_careerModel.sort != 5) {
        UIButton *btn = _btnAry[_careerModel.sort - 1];
        [btn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColorOfHex(0x55A7FD).CGColor;
    }
}

#pragma mark - Targets
- (void)btnClicked:(UIButton *)sender {
    NSInteger sortIndex = [_btnAry indexOfObject:sender] + 1;
    
    if ([self.delegate respondsToSelector:@selector(careerSortViewDidChangeSort:sortIndex:)]) {
        [self.delegate careerSortViewDidChangeSort:self sortIndex:sortIndex];
    }
}

@end
