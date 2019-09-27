//
//  YXCheckButton.m
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCheckButton.h"
#import "BSCommon.h"
#import "YXAPI.h"

@interface YXCheckButton ()



@end

@implementation YXCheckButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.exclusiveTouch = YES;
        
        self.answerModel = [[YXAnswerModel alloc]init];

        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.whiteColor.CGColor;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = UIColorOfHex(0xD0E0EF).CGColor;
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textColor = UIColorOfHex(0x485461);
        self.titleLable.font = [UIFont boldSystemFontOfSize:16];
        self.titleLable.textAlignment = NSTextAlignmentLeft;

        self.checkAnswerImageView = [[UIImageView alloc] init];
        self.checkAnswerImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.titleLable];
        [self addSubview:self.checkAnswerImageView];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
        }];
        
        [self.checkAnswerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(-6);
            make.right.equalTo(self).offset(6);
            make.height.width.mas_equalTo(44);
        }];
    }
    return self;
}

- (void)setType:(YXCheckButtonType)type {
    _type = type;
    switch (_type) {
        case CheckNone: {
            self.checkAnswerImageView.hidden = YES;
            self.layer.borderColor = UIColorOfHex(0xFFFFFF).CGColor;
        }
            break;
        case CheckTrue: {
            self.checkAnswerImageView.hidden = NO;
            self.checkAnswerImageView.image = [UIImage imageNamed:@"正确"];
            self.layer.borderColor = UIColorOfHex(0x09E9BC).CGColor;

        }
            break;
        case CheckFalse: {
            self.checkAnswerImageView.hidden = NO;
            self.checkAnswerImageView.image = [UIImage imageNamed:@"错误"];
            self.layer.borderColor = UIColorOfHex(0xFC7D8B).CGColor;

        }
            break;
        default:
            break;
    }
}


@end
