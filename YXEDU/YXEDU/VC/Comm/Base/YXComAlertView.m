//
//  YXComAlertView.m
//  YXEDU
//
//  Created by shiji on 2018/4/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXComAlertView.h"
#import "BSCommon.h"

@interface YXComAlertView () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *pannelView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) YXFirstBlock firstBlock;
@property (nonatomic, copy) YXSecondBlock secondBlock;
@property (nonatomic, assign) YXAlertType alertType;
@end

@implementation YXComAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (id)showAlert:(YXAlertType)alertType
         inView:(UIView *)view
           info:(NSString *)info
        content:(NSString *)content
     firstBlock:(YXFirstBlock)firstBlock
    secondBlock:(YXSecondBlock)secondBlock {
    for (UIView *subView in view.subviews) {
        if (subView.class == [YXComAlertView class]) {
            return nil;
        }
    }
    YXComAlertView *comAlert = [[YXComAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [comAlert showAlert:alertType inView:view info:info content:content firstBlock:^(id obj) {
        firstBlock(obj);
        if (alertType != YXAlertGraphCode) {
            [comAlert removeFromSuperview];
        }
    } secondBlock:^(id obj) {
        secondBlock(obj);
        if (alertType != YXAlertGraphCode) {
            [comAlert removeFromSuperview];
        }
    }];
    return comAlert;
}

- (void)showAlert:(YXAlertType)alertType
           inView:(UIView *)view
             info:(NSString *)info
          content:(NSString *)content
       firstBlock:(YXFirstBlock)firstBlock
      secondBlock:(YXSecondBlock)secondBlock {
    self.alertType = alertType;
    [self maskView];
    switch (alertType) {
            
        case YXAlertGraphCode: {
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-270)/2.0, (SCREEN_HEIGHT-218)/2.0, 270, 218);
            self.verifyCodeImage.frame = CGRectMake(15, 16, 240, 88);
            self.verifyCodeImage.backgroundColor = UIColorOfHex(0x666666);
            self.verifyCodeField.frame = CGRectMake(15, CGRectGetMaxY(self.verifyCodeImage.frame)+6, 240, 36);
            self.lineView.frame = CGRectMake(15, CGRectGetMaxY(self.verifyCodeField.frame), 240, 0.5);
            self.firstBtn.frame = CGRectMake(15, CGRectGetMaxY(self.lineView.frame)+16, 240, 42);
            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
            [self.firstBtn setTitle:@"提交" forState:UIControlStateNormal];
            [self.firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            [view addSubview:self];
            [self.verifyCodeField becomeFirstResponder];
        }
            break;
        case YXAlertLogout: {
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, (SCREEN_HEIGHT-140)/2.0, 200, 140);
            self.titleLab.text = @"确定要退出吗？";
            self.titleLab.frame = CGRectMake(0, 40, 200, 20);
            self.firstBtn.frame = CGRectMake(15, 94, 80, 32);
            [self.firstBtn setTitle:@"确  定" forState:UIControlStateNormal];
            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            self.secondBtn.frame = CGRectMake(105, 94, 80, 32);
            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"取  消" forState:UIControlStateNormal];
            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            self.closeBtn.hidden = YES;
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            
            if (content) {
                self.pannelView.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, (SCREEN_HEIGHT-180)/2.0, 200, 180);
                
                self.firstBtn.frame = CGRectMake(15, 134, 80, 32);
                self.secondBtn.frame = CGRectMake(105, 134, 80, 32);
                
                self.titleLab.frame = CGRectMake(0, 10, 200, 40);
                self.contentLab.frame = CGRectMake(20, 45, 160, 70);
                self.contentLab.text = content;
            }
            
            [view addSubview:self];
        }
            break;
        case YXAlertManageBook: {
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, (SCREEN_HEIGHT-180)/2.0, 200, 180);
            self.titleLab.frame = CGRectMake(0, 10, 200, 40);
            self.contentLab.frame = CGRectMake(20, 45, 160, 70);
            self.contentLab.text = content;
            self.titleLab.text = info;
            self.firstBtn.frame = CGRectMake(15, 134, 80, 32);
            [self.firstBtn setTitle:@"删除进度" forState:UIControlStateNormal];
            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            self.firstBtn.backgroundColor = [UIColor clearColor];
            self.secondBtn.frame = CGRectMake(105, 134, 80, 32);
            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"保留进度" forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
            self.closeBtn.hidden = YES;
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            [view addSubview:self];
        }
            break;
        case YXAlertStudySelect: {
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, (SCREEN_HEIGHT-140)/2.0, 200, 140);
            self.titleLab.text = info;
            self.titleLab.frame = CGRectMake(15, 30, 171, 40);
            
            self.firstBtn.frame = CGRectMake(15, 94, 80, 32);
            [self.firstBtn setTitle:@"重新开始" forState:UIControlStateNormal];
            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            self.firstBtn.backgroundColor = [UIColor clearColor];
            self.secondBtn.frame = CGRectMake(105, 94, 80, 32);
            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"继续学习" forState:UIControlStateNormal];
            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            [view addSubview:self];
        }
            break;
        case YXAlertMaterial: {
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, (SCREEN_HEIGHT-140)/2.0, 200, 140);
            self.titleLab.text = info;
            self.titleLab.frame = CGRectMake(0, 40, 200, 20);
            self.firstBtn.frame = CGRectMake(15, 94, 80, 32);
            [self.firstBtn setTitle:@"确  定" forState:UIControlStateNormal];
            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            self.secondBtn.frame = CGRectMake(105, 94, 80, 32);
            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"取  消" forState:UIControlStateNormal];
            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            self.closeBtn.hidden = YES;
            
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            [view addSubview:self];
        }
            break;
        default:
            break;
            
    }
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = UIColorOfHex(0x000000);
        _maskView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskTap)];
        _maskView.userInteractionEnabled = YES;
        if (self.alertType != YXAlertStudySelect) {
            [_maskView addGestureRecognizer:tap];
        }
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (UIView *)pannelView {
    if (!_pannelView) {
        _pannelView = [[UIView alloc]init];
        _pannelView.backgroundColor =UIColorOfHex(0xffffff);
        _pannelView.layer.cornerRadius = 8.0f;
        _pannelView.clipsToBounds = YES;
        [self addSubview:_pannelView];
    }
    return _pannelView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = UIColorOfHex(0x535353);
        _titleLab.font = [UIFont boldSystemFontOfSize:14];
        [self.pannelView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.numberOfLines = 0;
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.textColor = UIColorOfHex(0x535353);
        _contentLab.font = [UIFont systemFontOfSize:13];
        [self.pannelView addSubview:_contentLab];
    }
    return _contentLab;
}

- (UIButton *)firstBtn {
    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _firstBtn.exclusiveTouch = YES;
        [_firstBtn setFrame:CGRectZero];
        [_firstBtn setTitle:@"" forState:UIControlStateNormal];
        [_firstBtn setTitleColor:UIColorOfHex(0x1CB0F6) forState:UIControlStateNormal];
        [_firstBtn setBackgroundColor:[UIColor clearColor]];
        [_firstBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_firstBtn addTarget:self action:@selector(firstBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.pannelView addSubview:_firstBtn];
    }
    return _firstBtn;
}

- (UIButton *)secondBtn {
    if (!_secondBtn) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.exclusiveTouch = YES;
        [_secondBtn setFrame:CGRectZero];
        [_secondBtn setTitle:@"" forState:UIControlStateNormal];
        [_secondBtn setTitleColor:UIColorOfHex(0x1CB0F6) forState:UIControlStateNormal];
        [_secondBtn setBackgroundColor:[UIColor clearColor]];
        [_secondBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_secondBtn addTarget:self action:@selector(secondBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.pannelView addSubview:_secondBtn];
    }
    return _secondBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectZero];
        [_closeBtn setTitleColor:UIColorOfHex(0x1CB0F6) forState:UIControlStateNormal];
        [_closeBtn setBackgroundColor:[UIColor clearColor]];
        [_closeBtn setImage:[UIImage imageNamed:@"alert_close_btn"] forState:UIControlStateNormal];
        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.pannelView addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UIImageView *)verifyCodeImage {
    if (!_verifyCodeImage) {
        _verifyCodeImage = [[UIImageView alloc]init];
        [_verifyCodeImage setFrame:CGRectZero];
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pan)];
        _verifyCodeImage.userInteractionEnabled = YES;
        [_verifyCodeImage addGestureRecognizer:pan];
        [self.pannelView addSubview:_verifyCodeImage];
    }
    return _verifyCodeImage;
}

- (UITextField *)verifyCodeField {
    if (!_verifyCodeField) {
        _verifyCodeField = [[UITextField alloc]init];
        [_verifyCodeField setFrame:CGRectZero];
        _verifyCodeField.delegate = self;
        _verifyCodeField.placeholder = @"请输入验证码";
        [_verifyCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_verifyCodeField setFont:[UIFont systemFontOfSize:16]];
        [self.pannelView addSubview:_verifyCodeField];
    }
    return _verifyCodeField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        [_lineView setFrame:CGRectZero];
        [_lineView setBackgroundColor:[UIColor lightGrayColor]];
        [self.pannelView addSubview:_lineView];
    }
    return _lineView;
}

- (void)firstBtnClicked:(id)sender {
    self.firstBlock(self);
}

- (void)secondBtnClicked:(id)sender {
    self.secondBlock(self);
}

- (void)pan {
    self.secondBlock(self);
}

- (void)maskTap {
    [self removeView];
}

- (void)removeView {
    [self closeBtnClicked:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 0 && [string isEqualToString:@" "]) {
        return NO;
    }
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (result.length > 6) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _verifyCodeField) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (void)closeBtnClicked:(id)sender {
    [self removeFromSuperview];
}

@end
