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
#import "YXComHttpService.h"
#import "Growing.h"

static NSString *const kBindPlatformKey = @"BindPlatformKey";
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
@property (nonatomic, weak) YXComAlertView *commAlert;
@property (nonatomic, assign) NSRange phoneRange;
@property (nonatomic, weak)UIView *inputArea;
@end

@implementation YXBindPhoneVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bindViewModel = [[YXBindViewModel alloc]init];
        self.loginViewModel = [[YXLoginViewModel alloc]init];
        self.tikCount = 60;
    }
    return self;
}

- (void)setPf:(NSString *)pf {
    _pf = pf;
    if (pf) {
        [[NSUserDefaults standardUserDefaults] setObject:pf forKey:kBindPlatformKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 左滑返回界面下移
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    self.backType = BackGray;
    self.textColorType = TextColorWhite;
    [super viewDidLoad];
    [self setUpleftBarButtonItem];
    self.title = @"绑定手机号";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.titleImageView = [[UIImageView alloc]init]; //WithFrame:CGRectMake((SCREEN_WIDTH-68)/2.0, 30, 68, 68)
    self.titleImageView.image = [UIImage imageNamed:@"bind_title_logo"];
    [self.view addSubview:self.titleImageView];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(68, 68));
        make.top.equalTo(self.view).offset(30.0);
    }];
    
    self.subTitleLab = [[UILabel alloc]init];//WithFrame:CGRectMake(0, CGRectGetMaxY(self.titleImageView.frame) + 16, SCREEN_WIDTH, 34)
    self.subTitleLab.numberOfLines = 0;
    self.subTitleLab.textColor = UIColorOfHex(0x7E9FB2);
    self.subTitleLab.text = @"绑定手机号会让您的账号更安全";
    self.subTitleLab.font = [UIFont systemFontOfSize:13];
    self.subTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleImageView.mas_bottom).offset(15);
    }];
    
    CGFloat leftAligent = 50;
    [self.inputArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftAligent);
        make.right.equalTo(self.view).offset(-leftAligent);
        make.top.equalTo(self.subTitleLab.mas_bottom).offset(35);
        make.height.mas_equalTo(97);
    }];
    
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.inputArea);
        make.top.equalTo(self.inputArea.mas_bottom).offset(30);
        make.height.mas_equalTo(44);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.phoneNum becomeFirstResponder];
}

- (void)setUpleftBarButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"  " forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"back_white"];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 40);// CGSizeMake(80, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)back {
    [self.view endEditing:YES];
    [self cancleTimer];
    [[YXConfigure shared] saveToken:@""];
    [Growing track:kGrowingTraceBindMobile withVariable:@{@"bind_mobile_type": @"cancel"}];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSString *pf = [[NSUserDefaults standardUserDefaults] objectForKey:kBindPlatformKey];
    if (pf) {
        bindModel.pf = pf;
    }
    [YXUtils showHUD:self.view];
    // 统计
    [self traceEvent:kTraceBindMobile traceType:kTraceCount descributtion:pf];
    [Growing track:kGrowingTraceBindMobile withVariable:@{@"bind_mobile_type":@"bind"}];

    [self.bindViewModel bindPhone:bindModel finish:^(id obj, BOOL result) {
        if (result) { // 绑定成功
            [[YXConfigure shared] saveCurrentToken];// 保存token
            [[YXComHttpService shared] requestConfig:^(YRHttpResponse *response, BOOL result) {
                [YXUtils hideHUD:weakSelf.view];
                if (result) { // 成功
                    YXConfigModel *configModel = response.responseObject;
                    if (configModel.baseConfig.learning == 0) {
                        [weakSelf showSelectedVC];
                    } else {
                        [weakSelf cancleTimer];
                        [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                            [app showMainVC];
                        }];
                    }
                }
            }];
        }else {
            [YXUtils hideHUD:weakSelf.view];
        }
    }];
}

- (void)cancleTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dimi {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSelectedVC {
    [self dismissViewControllerAnimated:NO completion:nil];
    [kNotificationCenter postNotificationName:kShowSelectedBookVCNotify object:nil];
}

- (void)enableBindBtn {
//    [self.bindBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    self.bindBtn.enabled = YES;
}

- (void)disableBindBtn {
//    [self.bindBtn setBackgroundImage:[UIImage imageNamed:@"login_gray_btn"] forState:UIControlStateNormal];
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
    NSString *pf = [[NSUserDefaults standardUserDefaults] objectForKey:kBindPlatformKey];
    if (pf) {
        smsModel.pf = pf;
    }
    smsModel.type = @"editMobile";
    // 统计
    [self traceEvent:kTraceIdentifyCode traceType:kTraceCount descributtion:pf];
    [Growing track:kGrowingTraceIdentifyCode withVariable:@{@"identify_code_type":@"bind"}];

    [self.bindViewModel sendSMS:smsModel finish:^(id obj, BOOL result) {
        [YXUtils hideHUD:weakSelf.view];
        if (result) {
            block(nil, YES);
            _verifyBtn.enabled = NO;
            [weakSelf verifyBtnTitleHilight:NO];
            [_verifyBtn setTitle:[NSString stringWithFormat:@"%ld秒重发", (long)self.tikCount] forState:UIControlStateNormal];
            _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1.0f block:^(id userInfo) {
                weakSelf.tikCount --;
                [weakSelf.verifyBtn setTitle:[NSString stringWithFormat:@"%ld秒重发", (long)weakSelf.tikCount] forState:UIControlStateNormal];
                if (weakSelf.tikCount == 0) {
                    weakSelf.tikCount = 60;
                    weakSelf.verifyBtn.enabled = YES;
                    [weakSelf verifyBtnTitleHilight:YES];
                    [weakSelf.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                }
            } userInfo:@"Fire" repeats:YES];
            [_timer fire];
        } else {
            if (((NSNumber *)obj).integerValue == USER_PF_MOBILE_CAPTCHA_EMPTY_CODE || ((NSNumber *)obj).integerValue == USER_PF_MOBILE_CAPTCHA_CODE) { // 验证码为空
                YXComAlertView *alert = [YXComAlertView showAlert:YXAlertGraphCode
                                                           inView:[UIApplication sharedApplication].keyWindow
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
//                                                               alertView.verifyCodeImage.image = [UIImage imageWithData:obj];
                                                               [alertView updateVerifyCodeImage:[UIImage imageWithData:obj]];
                                                           }];
                                                       }];
                if (alert) {
                    weakSelf.commAlert = alert;
                }
                [weakSelf requestImage:^(id obj, BOOL result) {
                    [weakSelf.commAlert updateVerifyCodeImage:[UIImage imageWithData:obj]];
//                    weakSelf.commAlert.verifyCodeImage.image = [UIImage imageWithData:obj];
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
        
        [self verifyBtnTitleHilight:(textField.text.length == 13)];
        
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
        if ([[result stringByReplacingOccurrencesOfString:@" " withString:@""] MobileNumber] && _verifyCode.text.length == 6) {
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

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - subview
- (UIView *)inputArea {
    if (!_inputArea) {
        UIView *inputArea = [[UIView alloc] init];
        [self.view addSubview:inputArea];
        _inputArea = inputArea;
        
        [self phoneNum];
        
        UIImageView *phoneIcon = [[UIImageView alloc] init];
        phoneIcon.image  = [UIImage imageNamed:@"phoneIcon"];
        [inputArea addSubview:phoneIcon];
        [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(inputArea);
            make.centerY.equalTo(self.phoneNum);
            make.size.mas_equalTo(CGSizeMake(18, 20));
        }];
        
        [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneIcon.mas_right).offset(12);
            make.top.right.equalTo(inputArea);
            make.height.mas_equalTo(30.f);
        }];
        
        UIView *phoneLine = [[UIView alloc]init];
        phoneLine.backgroundColor = UIColorOfHex(0xD9E6EE);
        [inputArea addSubview:phoneLine];
        [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(inputArea);
            make.top.equalTo(self.phoneNum.mas_bottom);
            make.height.mas_equalTo(1.f);
        }];
        
        [self verifyCode];
        
        UIImageView *verifyIcon = [[UIImageView alloc] init];
        verifyIcon.image  = [UIImage imageNamed:@"verifyIcon"];
        [inputArea addSubview:verifyIcon];
        [verifyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(inputArea);
            make.centerY.equalTo(self.verifyCode);
            make.size.mas_equalTo(CGSizeMake(18, 20));
        }];
        
        [self.verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneNum);
            make.top.equalTo(phoneIcon.mas_bottom).offset(35);
            make.right.equalTo(inputArea);
            make.height.mas_equalTo(30.f);
        }];
        
        [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(self.verifyCode);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        UIView *verifyLine = [[UIView alloc]init];
        verifyLine.backgroundColor = UIColorOfHex(0xD9E6EE);
        [self.view addSubview:verifyLine];
        [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(inputArea);
            make.top.equalTo(self.verifyCode.mas_bottom);
            make.height.mas_equalTo(1.f);
        }];
        
        //        if (iPhone5) {
        //            [self.verifyCode setFrame:CGRectMake(50, CGRectGetMaxY(phoneLine.frame)+25, SCREEN_WIDTH-100, 30)];
        //            [self.verifyBtn setFrame:CGRectMake(SCREEN_WIDTH-130, CGRectGetMaxY(phoneLine.frame)+30, 80, 16)];
        //            [verifyLine setFrame:CGRectMake(50, CGRectGetMaxY(self.verifyCode.frame), SCREEN_WIDTH-100, 1)];
        //        }
    }
    return _inputArea;
}
- (UITextField* )phoneNum{
    if(!_phoneNum) {
        _phoneNum = [[UITextField alloc]init];
        _phoneNum.font = [UIFont systemFontOfSize:16];
        _phoneNum.textColor = UIColorOfHex(0x485461);
        _phoneNum.keyboardType = UIKeyboardTypePhonePad;
        _phoneNum.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phoneNum.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNum.returnKeyType = UIReturnKeyNext;
        [_phoneNum addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"请输入手机号"];
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x7E9FB2) range:NSMakeRange(0, attr.string.length)];
        _phoneNum.attributedPlaceholder = attr;
        _phoneNum.delegate = self;
        [self.inputArea addSubview:_phoneNum];
    }
    return _phoneNum;
}

- (UITextField* )verifyCode{
    if(!_verifyCode) {
        _verifyCode = [[UITextField alloc]init];
        _verifyCode.font = [UIFont systemFontOfSize:16];
        _verifyCode.textColor = UIColorOfHex(0x485461);
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
        [attr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x7E9FB2) range:NSMakeRange(0, attr.string.length)];
        _verifyCode.attributedPlaceholder = attr;
        [self.inputArea addSubview:_verifyCode];
    }
    return _verifyCode;
}

- (UIButton *)bindBtn {
    if (!_bindBtn) {
        UIButton *bindBtn = [YXCustomButton comBlueShadowBtnWithSize:CGSizeMake(SCREEN_WIDTH - 100, 44) WithCornerRadius:22];
        bindBtn.exclusiveTouch = YES;
        [bindBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        [bindBtn addTarget:self action:@selector(bindBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        bindBtn.enabled = NO;
        [self.view addSubview:bindBtn];
        _bindBtn = bindBtn;
    }
    return _bindBtn;
}

- (UIButton *)verifyBtn {
    if (!_verifyBtn) {
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:UIColorOfHex(0xB7C2D4) forState:UIControlStateNormal];
        [_verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_verifyBtn setBackgroundColor:[UIColor clearColor]];
        [_verifyBtn addTarget:self action:@selector(verifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.inputArea addSubview:_verifyBtn];
    }
    return _verifyBtn;
}

- (void)verifyBtnTitleHilight:(BOOL)isHightLight {
    UIColor *color = isHightLight ? UIColorOfHex(0x55A7FD) : UIColorOfHex(0xB7C2D4);
    [self.verifyBtn setTitleColor:color forState:UIControlStateNormal];
}
@end


//- (void)bindBtnClicked:(id)sender {
//    [self.view endEditing:YES];
//    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
//        [YXUtils showHUD:self.view title:@"网络错误!"];
//        return;
//    }
//    __weak YXBindPhoneVC *weakSelf = self;
//    YXBindModel *bindModel = [[YXBindModel alloc]init];
//    bindModel.mobile = [_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    bindModel.code = _verifyCode.text;
//    [YXUtils showHUD:self.view];
//    [self.bindViewModel bindPhone:bindModel finish:^(id obj, BOOL result) {
//        if (result) {
//            [weakSelf.loginViewModel requestUserInfo:^(id obj, BOOL result1) {
//                if (result1) {
//                    YXLoginModel *model = obj;
//                    if (model.learning.bookid.length == 0) {
//                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                        [app showSelectVC];
//                    } else {
//                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                        [app showMainVC];
//                    }
//                } else {
//                    [YXUtils hideHUD:weakSelf.view];
//                }
//            }];
//        } else {
//            [YXUtils hideHUD:weakSelf.view];
//        }
//    }];
//}
