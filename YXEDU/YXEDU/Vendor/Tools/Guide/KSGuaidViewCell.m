//
//  KSGuaidViewCell.m
//  KSGuaidViewDemo
//
//  Created by Mr.kong on 2017/5/24.
//  Copyright © 2017年 Bilibili. All rights reserved.
//

#import "KSGuaidViewCell.h"

@implementation KSGuaidViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imageView];
        
        self.buttonStartBack = [[UIButton alloc]init];
        [self.contentView addSubview:self.buttonStartBack];
        [_buttonStartBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-60);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
//        _buttonStartBack.backgroundColor = [UIColor whiteColor];
////        _buttonStartBack.layer.shadowColor = kMainColor.CGColor;
//        _buttonStartBack.layer.shadowOffset = CGSizeMake(0, 0);
//        _buttonStartBack.layer.shadowRadius = 3;
//        _buttonStartBack.layer.shadowOpacity = 1;
//        _buttonStartBack.layer.cornerRadius= 3;
        _buttonStartBack.hidden = YES;
        
        self.buttonStart = [[UIButton alloc]init];
        [_buttonStartBack addSubview:self.buttonStart];
        [_buttonStart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-40);
            make.width.mas_equalTo(170);
            make.height.mas_equalTo(48);
        }];
        _buttonStart.layer.masksToBounds = YES;
        _buttonStart.layer.cornerRadius = 24;
        _buttonStart.hidden = YES;
        [_buttonStart setTitle:@"立即前往" forState:UIControlStateNormal];
        [_buttonStart setBackgroundImage:[UIImage imageNamed:@"buttonBackImage"] forState:UIControlStateNormal];
//        _buttonStart.titleLabel.font = HIFont(17);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end

NSString * const KSGuaidViewCellID = @"KSGuaidViewCellID";
