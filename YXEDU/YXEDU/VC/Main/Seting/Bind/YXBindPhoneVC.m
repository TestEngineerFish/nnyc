//
//  YXBindPhoneVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBindPhoneVC.h"
#import "BSCommon.h"
#import "YXBindViewModel.h"
#import "YXBindModel.h"
#import "NSString+YR.h"
#import "NSTimer+YR.h"
#import "HWWeakTimer.h"
#import "YXUtils.h"
#import "NetWorkRechable.h"
#import "YXLoginViewModel.h"
#import "YXConfigure.h"
#import "YXMediator.h"
#import "YXSendSMSModel.h"
#import "YXComAlertView.h"
#import "NSString+YX.h"


@interface YXBindPhoneVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UITextField *verifyCode;
@property (nonatomic, strong) UIButton *bindBtn;
@property (nonatomic, strong) UIButton *verifyBtn;

@property (nonatomic, strong) UIView *cornersView;
@property (nonatomic, strong) UIView *downViewCorners;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) YXBindViewModel *bindViewModel;
@property (nonatomic, strong) YXLoginViewModel *loginViewModel;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger tikCount;
@property (nonatomic, strong) YXComAlertView *commAlert;
@property (nonatomic, assign) NSRange phoneRange;
@end

@implementation YXBindPhoneVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bindViewModel = [[YXBindViewModel alloc]init];
        self.loginViewModel = [[YXLoginViewModel alloc]init];
        self.tikCount = 60;
    }
    return self;
}

- (void)viewDidLoad {
    self.backType = BackGray;
    self.textColorType = TextColorWhite;
    [super viewDidLoad];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 25)];
    self.titleLab.numberOfLines = 0;
    self.titleLab.textColor = UIColorOfHex(0x3DA6F4);
    self.titleLab.text = @"绑定手机号";
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLab];
    
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-222)/2.0, CGRectGetMaxY(self.titleLab.frame) + 26, 222, 104)];
    self.titleImageView.image = [UIImage imageNamed:@"bind_title_logo"];
    [self.view addSubview:self.titleImageView];
    
    self.subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleImageView.frame) + 16, SCREEN_WIDTH, 34)];
    self.subTitleLab.numberOfLines = 0;
    self.subTitleLab.textColor = UIColorOfHex(0x666666);
    self.subTitleLab.text = @"绑定手机号会让您的账号更安全\n您也可以直接使用手机号进行登录";
    self.subTitleLab.font = [UIFont systemFontOfSize:12];
    self.subTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subTitleLab];
    
    
    //
    [self.phoneNum setFrame:CGRectMake(50, CGRectGetMaxY(self.subTitleLab.frame)+57, SCREEN_WIDTH-100, 30)];
    
    UIView *phoneLine = [[UIView alloc]init];
    [phoneLine setFrame:CGRectMake(50, CGRectGetMaxY(self.phoneNum.frame), SCREEN_WIDTH-100, 1)];
    phoneLine.backgroundColor = UIColorOfHex(0x3DA6F4);
    [self.view addSubview:phoneLine];
    
    [self.verifyCode setFrame:CGRectMake(50, CGRectGetMaxY(phoneLine.frame)+35, SCREEN_WIDTH-100, 30)];
    [self.verifyBtn setFrame:CGRectMake(SCREEN_WIDTH-130, CGRectGetMaxY(phoneLine.frame)+40, 80, 16)];
    
    UIView *verifyLine = [[UIView alloc]init];
    [verifyLine setFrame:CGRectMake(50, CGRectGetMaxY(self.verifyCode.frame), SCREEN_WIDTH-100, 1)];
    verifyLine.backgroundColor = UIColorOfHex(0x3DA6F4);
    [self.view addSubview:verifyLine];
    
    self.bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bindBtn.exclusiveTouch = YES;
    [self.bindBtn setFrame:CGRectMake(68, CGRectGetMaxY(verifyLine.frame)+55, SCREEN_WIDTH-136, 42)];
    [self.bindBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    [self.bindBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [self.bindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bindBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.bindBtn addTarget:self action:@selector(bindBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.bindBtn.layer.cornerRadius = 4.0f;
    [self.view addSubview:self.bindBtn];
    [self disableBindBtn];
    
    [self.phoneNum becomeFirstResponder];
}


- (void)bindBtnClicked:(id)sender {
    [self.view endEditing:YES];
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    __weak YXBindPhoneVC *weakSelf = self;
    YXBindModel *bindModel = [[YXBindModel alloc]init];
    bindModel.mobile = [_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    bindModel.code = _verifyCode.text;
    [YXUtils showHUD:self.view];
    [self.bindViewModel bindPhone:bindModel finish:^(id obj, BOOL result) {
        if (result) {
            [weakSelf.loginViewModel requestUserInfo:^(id obj, BOOL result1) {
                if (result1) {
                    YXLoginModel *model = obj;
                    if (model.learning.bookid.length == 0) {
                        [[YXMediator shared]showSelectVC];
                    } else {
                        [[YXMediator shared]showMainVC];
                    }
                } else {
                    [YXUtils hideHUD:weakSelf.view];
                }
            }];
        } else {
            [YXUtils hideHUD:weakSelf.view];
        }
    }];
}



- (UITextField* )phoneNum{
    if(!_phoneNum) {
        _phoneNum = [[UITextField alloc]init];
        _phoneNum.font = [UIFont systemFontOfSize:16];
        _phoneNum.textColor = UIColorOfHex(0x3DA6F4);
        _phoneNum.keyboardType = UIKeyboardTypePhonePad;
        _phoneNum.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phoneNum.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNum.returnKeyType = UIReturnKeyNext;
        [_phoneNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"请输入手机号"];
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xA1DEF7) range:NSMakeRange(0, attr.string.length)];
        _phoneNum.attributedPlaceholder = attr;
        _phoneNum.delegate = self;
        [self.view addSubview:_phoneNum];
    }
    return _phoneNum;
}

- (UITextField* )verifyCode{
    if(!_verifyCode) {
        _verifyCode = [[UITextField alloc]init];
        _verifyCode.font = [UIFont systemFontOfSize:16];
        _verifyCode.textColor = UIColorOfHex(0x3DA6F4);
        if (@available(iOS 10.0, *)) {
            _verifyCode.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        } else {
            // Fallback on earlier versions
            _verifyCode.keyboardType = UIKeyboardTypeDecimalPad;
        }
        _verifyCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _verifyCode.autocorrectionType = UITextAutocorrectionTypeNo;
        _verifyCode.returnKeyType = UIReturnKeyNext;
        _verifyCode.delegate = self;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"请输入验证码"];
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xA1DEF7) range:NSMakeRange(0, attr.string.length)];
        _verifyCode.attributedPlaceholder = attr;
        [self.view addSubview:_verifyCode];
    }
    return _verifyCode;
}

- (UIButton *)verifyBtn {
    if (!_verifyBtn) {
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
        [_verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_verifyBtn setBackgroundColor:[UIColor clearColor]];
        [_verifyBtn addTarget:self action:@selector(verifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_verifyBtn];
    }
    return _verifyBtn;
}

- (void)enableBindBtn {
    [self.bindBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"]
                             forState:UIControlStateNormal];
    self.bindBtn.enabled = YES;
}

- (void)disableBindBtn {
    [self.bindBtn setBackgroundImage:[UIImage imageNamed:@"login_gray_btn"]
                             forState:UIControlStateNormal];
    self.bindBtn.enabled = NO;
}


- (void)verifyBtnClicked:(id)sender {
    [self.view endEditing:YES];
    [self sendSMS:@"" finish:^(id obj, BOOL result) {
        
    }];
}

- (void)sendSMS:(NSString *)verifyCode finish:(finishBlock)block{
    __weak YXBindPhoneVC* weakSelf = self;
    if (![[_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""] MobileNumber]) {
        [YXUtils showHUD:self.view title:@"请输入正确的手机号!"];
        return;
    }
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    [YXUtils showHUD:self.view];
    YXSendSMSModel *smsModel = [[YXSendSMSModel alloc]init];
    smsModel.mobile = [_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    smsModel.captcha = verifyCode;
    [self.bindViewModel sendSMS:smsModel finish:^(id obj, BOOL result) {
        [YXUtils hideHUD:weakSelf.view];
        if (result) {
            block(nil, YES);
            _verifyBtn.enabled = NO;
            [_verifyBtn setTitle:[NSString stringWithFormat:@"重新获取%lds", (long)self.tikCount] forState:UIControlStateNormal];
            _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0f block:^(id userInfo) {
                weakSelf.tikCount --;
                [weakSelf.verifyBtn setTitle:[NSString stringWithFormat:@"重新获取%lds", (long)weakSelf.tikCount] forState:UIControlStateNormal];
                if (weakSelf.tikCount == 0) {
                    weakSelf.tikCount = 60;
                    weakSelf.verifyBtn.enabled = YES;
                    [weakSelf.verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                }
            } userInfo:@"Fire" repeats:YES];
            [_timer fire];
        } else {
            if (((NSNumber *)obj).integerValue == USER_PF_MOBILE_CAPTCHA_EMPTY_CODE || ((NSNumber *)obj).integerValue == USER_PF_MOBILE_CAPTCHA_CODE) { // 验证码为空
                YXComAlertView *alert = [YXComAlertView showAlert:YXAlertGraphCode
                                                           inView:weakSelf.view
                                                             info:@""
                                                          content:nil
                                                       firstBlock:^(id obj) {
                                                           YXComAlertView *alertView = obj;
                                                           if (alertView.verifyCodeField.text.length == 0) {
                                                               [YXUtils showHUD:weakSelf.view title:@"验证码不能为空"];
                                                           } else {
                                                               [weakSelf sendSMS:alertView.verifyCodeField.text finish:^(id obj, BOOL result) {
                                                                   [alertView removeView];
                                                               }];
                                                           }
                                                       } secondBlock:^(id obj) { // 获取验证吗
                                                           YXComAlertView *alertView = obj;
                                                           [weakSelf requestImage:^(id obj, BOOL result) {
                                                               alertView.verifyCodeImage.image = [UIImage imageWithData:obj];
                                                           }];
                                                       }];
                if (alert) {
                    weakSelf.commAlert = alert;
                }
                [weakSelf requestImage:^(id obj, BOOL result) {
                    weakSelf.commAlert.verifyCodeImage.image = [UIImage imageWithData:obj];
                }];
            }
        }
    }];
}

- (void)requestImage:(finishBlock)block {
    NSString *phoneNum = [_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.bindViewModel requestGraphCodeMobile:phoneNum
                                        finish:^(id obj, BOOL result) {
                                            block(obj, result);
                                        }];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _phoneNum) {
        if (textField.text.length > 13) {
            textField.text = [textField.text substringToIndex:13];
        }
        
        if (self.phoneRange.length) { // 删除
            textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        } else {
            NSString *result = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (result.length >= 3 && result.length < 7) {
                NSString *string = [[result substringWithRange:NSMakeRange(0, 3)] stringByAppendingString:@" "];
                string = [string stringByAppendingString:[result substringWithRange:NSMakeRange(3, result.length-3)]];
                textField.text = string;
            } else if (result.length >= 7) {
                NSString *string = [[result substringWithRange:NSMakeRange(0, 3)] stringByAppendingString:@" "];
                string = [string stringByAppendingString:[result substringWithRange:NSMakeRange(3, 4)]];
                string = [string stringByAppendingString:@" "];
                string = [string stringByAppendingString:[result substringWithRange:NSMakeRange(7, result.length-7)]];
                textField.text = string;
                
                UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:string.length];
                [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
            }
        }
        if ([textField.text isEqualToString:@"100 1234 1234"]) {
            [self verifyBtnClicked:nil];
        }
    } else if (textField == _verifyCode) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _phoneNum) {
        self.phoneRange = range;
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([result MobileNumber] && _verifyCode.text.length == 6) {
            [self enableBindBtn];
        } else {
            [self disableBindBtn];
        }
    } else if (textField == _verifyCode) {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (result.length > 6) {
            return NO;
        }
        if ([[_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""] MobileNumber] && [result trimString].length == 6) {
            [self enableBindBtn];
        } else {
            [self disableBindBtn];
        }
    }
    return YES;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    //限制手机账号长度（有两个空格）
    if (textField.text.length > 13) {
        textField.text = [textField.text substringToIndex:13];
    }
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
