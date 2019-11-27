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
//@property (nonatomic, strong) YXCustomButton *firstBtn;
//@property (nonatomic, strong) UIButton *secondBtn;
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
    __weak typeof(comAlert) weakAlert = comAlert;
    [comAlert showAlert:alertType inView:view info:info content:content firstBlock:^(id obj) {
        if (firstBlock) {
            firstBlock(obj);
        }
        
        if (alertType != YXAlertGraphCode) {
            [weakAlert removeFromSuperview];
        }
    } secondBlock:^(id obj) {
        if (secondBlock) {
            secondBlock(obj);
        }
        if (alertType != YXAlertGraphCode) {
            [weakAlert removeFromSuperview];
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
    self.tag = 999;
    [self maskView];
    switch (alertType) {
            
        case YXAlertGraphCode: {
            [kNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
            self.verifyCodeImage.frame = CGRectMake(20, 20, 230, 70);
            self.verifyCodeImage.backgroundColor = UIColorOfHex(0x666666);
            self.verifyCodeField.frame = CGRectMake(20, CGRectGetMaxY(self.verifyCodeImage.frame)+8, 230, 36);
            self.lineView.frame = CGRectMake(20, CGRectGetMaxY(self.verifyCodeField.frame), 230, 0.5);
            self.firstBtn.frame = CGRectMake(40, CGRectGetMaxY(self.lineView.frame) + 20, 190, 44);
            self.firstBtn.cornerRadius = 22;
            [self.firstBtn setTitle:@"提交" forState:UIControlStateNormal];
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-270)/2.0, (SCREEN_HEIGHT-221)/2.0, 270, 221);
            [view addSubview:self];
            
            // 弹框动画有必要时添加
            CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animater.values = @[@1,@1.1,@1.0];
            animater.duration = 0.25;
            animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.maskView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                self.maskView.alpha = 0.6;
            }];
            [self.pannelView.layer addAnimation:animater forKey:nil];
            [self.verifyCodeField becomeFirstResponder];
        }
            break;
        case YXAlertLogout: {
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-300)/2.0, (SCREEN_HEIGHT-140)/2.0, 300, 194);
            self.titleLab.text = @"提示";
            self.titleLab.frame = CGRectMake(0, 25, 300, 20);
            self.titleLab.textAlignment = NSTextAlignmentCenter;
            
            self.contentLab.text = @"确定要退出吗？";
            self.contentLab.frame = CGRectMake(0, 70, 300, 20);
            self.contentLab.textAlignment = NSTextAlignmentCenter;
            
            self.firstBtn.frame = CGRectMake(35, 127, 110, 36);
            [self.firstBtn setTitle:@"确  定" forState:UIControlStateNormal];
//            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
//            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
//            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            self.secondBtn.frame = CGRectMake(155, 127, 110, 36);
//            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"取  消" forState:UIControlStateNormal];
//            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
//            [self.secondBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            self.closeBtn.hidden = YES;
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            
//            if (content) {
//                self.pannelView.frame = CGRectMake((SCREEN_WIDTH-270)/2.0, (SCREEN_HEIGHT-180)/2.0, 270, 180);
//                self.pannelView.backgroundColor = UIColor.redColor;
//                self.firstBtn.frame = CGRectMake(15, 134, 80, 32);
//                self.secondBtn.frame = CGRectMake(105, 134, 80, 32);
//
//                self.titleLab.frame = CGRectMake(0, 10, 200, 40);
//                self.contentLab.frame = CGRectMake(20, 45, 160, 70);
//                self.contentLab.text = content;
//            }
            
            [view addSubview:self];
            
            CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animater.values = @[@1,@1.1,@1.0];
            animater.duration = 0.25;
            animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.maskView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                self.maskView.alpha = 0.6;
            }];
            [self.pannelView.layer addAnimation:animater forKey:nil];
        }
            break;
        case YXAlertManageBook: {
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-270)/2.0, (SCREEN_HEIGHT-180)/2.0, 270, 180);
            self.titleLab.frame = CGRectMake(10, 10, 250, 40);
            self.titleLab.font = [UIFont systemFontOfSize:21];
            self.contentLab.font = [UIFont systemFontOfSize:14];
            self.contentLab.frame = CGRectMake(20, 45, 230, 70);
            self.contentLab.text = content;
            self.titleLab.text = info;
            self.firstBtn.frame = CGRectMake(20, 120, 90, 32);
            [self.firstBtn setTitle:@"确定" forState:UIControlStateNormal];
//            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
//            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            self.firstBtn.backgroundColor = [UIColor clearColor];
            self.secondBtn.frame = CGRectMake(160, 120, 90, 32);
            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
//            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
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
//            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
//            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            self.firstBtn.backgroundColor = [UIColor clearColor];
            self.secondBtn.frame = CGRectMake(105, 94, 80, 32);
            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"继续学习" forState:UIControlStateNormal];
//            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
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
//            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
//            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            self.secondBtn.frame = CGRectMake(105, 94, 80, 32);
            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"取  消" forState:UIControlStateNormal];
//            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
            self.closeBtn.hidden = YES;
            
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            [view addSubview:self];
        }
            break;
            
        case YXAlertCommon: {
            NSString *title = info.length ? info : @"提 示";
            self.pannelView.frame = CGRectMake((SCREEN_WIDTH-300)/2.0, (SCREEN_HEIGHT-140)/2.0, 300, 194);
            self.titleLab.text = title;
            self.titleLab.frame = CGRectMake(0, 25, 300, 20);
            self.titleLab.textAlignment = NSTextAlignmentCenter;
            
            self.contentLab.frame = CGRectMake(25, 62, 250, 40);
            self.contentLab.text = content;
            
            
            self.firstBtn.frame = CGRectMake(35, 127, 110, 36);
            [self.firstBtn setTitle:@"确 定" forState:UIControlStateNormal];
            //            [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_graybtn"] forState:UIControlStateNormal];
            //            [self.firstBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
//            [self.firstBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            self.secondBtn.frame = CGRectMake(155, 127, 110, 36);
//            [self.secondBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.secondBtn setTitle:@"取 消" forState:UIControlStateNormal];
            //            [self.secondBtn setBackgroundImage:[UIImage imageNamed:@"com_alert_yellowbtn"] forState:UIControlStateNormal];
            [self.secondBtn setTitleColor:UIColorOfHex(0x8095AB) forState:UIControlStateNormal];
            self.closeBtn.hidden = YES;
            self.firstBlock = firstBlock;
            self.secondBlock = secondBlock;
            
//            if (content) {
//                self.pannelView.frame = CGRectMake((SCREEN_WIDTH-240)/2.0, (SCREEN_HEIGHT-180)/2.0, 240, 160);
////                self.pannelView.backgroundColor = UIColor.redColor;
//                self.firstBtn.frame = CGRectMake(15, 105, 90, 32);
//                self.secondBtn.frame = CGRectMake(135, 105, 90, 32);
//
//                self.titleLab.frame = CGRectMake(0, 10, 240, 40);
//                self.contentLab.frame = CGRectMake(20, 30, 200, 70);
//                self.contentLab.text = content;
//            }
            
            [view addSubview:self];
            
            CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animater.values = @[@1,@1.1,@1.0];
            animater.duration = 0.25;
            animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.maskView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                self.maskView.alpha = 0.6;
            }];
            [self.pannelView.layer addAnimation:animater forKey:nil];
        }
            break;
        default:
            break;
            
    }
}

- (void)updateVerifyCodeImage:(UIImage *)verifyCodeImage {
    self.verifyCodeImage.image = verifyCodeImage;
    self.verifyCodeField.text = nil;
    [self.verifyCodeField becomeFirstResponder];
}
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = UIColorOfHex(0x000000);
        _maskView.alpha = 0.6;
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
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
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
        _contentLab.font = [UIFont systemFontOfSize:16];
        [self.pannelView addSubview:_contentLab];
    }
    return _contentLab;
}

- (UIButton *)firstBtn {
    if (!_firstBtn) {
        _firstBtn = [YXCustomButton commonBlueWithCornerRadius:18];
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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
        [_secondBtn setTitleColor:UIColorOfHex(0x8095AB) forState:UIControlStateNormal];
        [_secondBtn setBackgroundColor:UIColorOfHex(0xEFF4F7)];
        [_secondBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_secondBtn addTarget:self action:@selector(secondBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _secondBtn.layer.cornerRadius = 18;
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
        [_lineView setBackgroundColor:UIColorOfHex(0xD9E6EE)];
        [self.pannelView addSubview:_lineView];
    }
    return _lineView;
}

- (void)firstBtnClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    self.firstBlock(weakSelf);
}

- (void)secondBtnClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    self.secondBlock(weakSelf);
}

- (void)pan {
    __weak typeof(self) weakSelf = self;
    self.secondBlock(weakSelf);
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

#pragma mark - 监听键盘
- (void)keyboardWillChangeFrame:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    CGFloat  animationDuration = [[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect finalFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect oriFrame = self.pannelView.frame;
    if (finalFrame.origin.y < SCREEN_HEIGHT) { //  弹出
        oriFrame.origin.y = finalFrame.origin.y - oriFrame.size.height;
    }else {
        oriFrame.origin.y = (SCREEN_HEIGHT - oriFrame.size.height) * 0.5;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.pannelView.frame = oriFrame;
    }];
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}
@end
