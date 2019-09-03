//
//  YXGraphSingleBtnView.m
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphSingleBtnView.h"
#import "BSCommon.h"
#import "YXCommHeader.h"

@interface YXGraphSingleBtnView ()
@property (nonatomic, strong) UIImageView *radioImageView;
@property (nonatomic, strong) UIImageView *rightTipImageView;

@end

@implementation YXGraphSingleBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 27.0;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = UIColorOfHex(0xDCDCDC).CGColor;
        self.exclusiveTouch = YES;
        
        self.radioImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 13, 28, 28)];
        self.radioImageView.image = [UIImage imageNamed:@"study_singleselect_radio_unselected"];
        [self addSubview:self.radioImageView];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 16, frame.size.width-104, 22)];
        self.titleLab.text = @"n.(名词)，一种交通工具";
        self.titleLab.textColor = UIColorOfHex(0x666666);
        self.titleLab.font = [UIFont boldSystemFontOfSize:18];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLab];
        
        
        self.rightTipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-44, 13, 28, 28)];
//        self.rightTipImageView.image = [UIImage imageNamed:@"study_singleselect_right"];
        [self addSubview:self.rightTipImageView];
        
        self.answerModel = [[YXAnswerModel alloc]init];
    }
    return self;
}

- (void)setSelectType:(YXSingleSelectType)selectType {
    _selectType = selectType;
    switch (_selectType) {
        case YXSingleSelectNone: {
            self.radioImageView.image = [UIImage imageNamed:@"study_singleselect_radio_unselected"];
            self.rightTipImageView.hidden = YES;
            self.titleLab.textColor = UIColorOfHex(0x666666);
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderWidth = 2.0;
        }
            break;
        case YXSingleSelectRight: {
            self.radioImageView.image = [UIImage imageNamed:@"study_singleselect_radio_selected"];
            self.rightTipImageView.hidden = NO;
            self.rightTipImageView.image = [UIImage imageNamed:@"study_singleselect_right"];
            self.titleLab.textColor = UIColorOfHex(0xffffff);
            self.backgroundColor = UIColorOfHex(0x7AC70C);
            self.layer.borderWidth = 0;
        }
            break;
        case YXSingleSelectFalse: {
            self.radioImageView.image = [UIImage imageNamed:@"study_singleselect_radio_selected"];
            self.rightTipImageView.hidden = NO;
            self.rightTipImageView.image = [UIImage imageNamed:@"study_singleselect_wrong"];
            self.titleLab.textColor = UIColorOfHex(0xffffff);
            self.backgroundColor = UIColorOfHex(0xD33131);
            self.layer.borderWidth = 0;
        }
            break;
        default:
            break;
    }
}


@end
