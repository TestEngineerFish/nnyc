//
//  YXLoginVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXLoginVC.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "AVAudioPlayerManger.h"
#import "WXApiManager.h"
#import "QQApiManager.h"
#import "YXPolicyVC.h"

#import "UIImage+GIF.h"
#import "YXMediator.h"
#import "YXLoginViewModel.h"
#import "YXLoginSendModel.h"
#import "YXMediator.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import "NetWorkRechable.h"
#import "NSString+YR.h"
#import "YXBindPhoneVC.h"
#import "YXBindViewModel.h"
#import "HWWeakTimer.h"
#import "YXComAlertView.h"
#import "YXCommHeader.h"
#import "UIImageView+YR.h"
#import "YX_URL.h"
#import "NSString+YX.h"

@interface YXLoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *earchImageView;
@property (nonatomic, strong) YXLoginViewModel *viewModel;
@property (nonatomic, strong) YXBindViewModel *bindViewModel;
@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UITextField *verifyCode;
@property (nonatomic, strong) UIButton *verifyBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger tikCount;
@property (nonatomic, strong) YXComAlertView *commAlert;
@property (nonatomic, assign) NSRange phoneRange;
@property (nonatomic, strong) UIButton *wxBtn;
@end

@implementation YXLoginVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewModel = [[YXLoginViewModel alloc]init];
        self.bindViewModel = [[YXBindViewModel alloc]init];
        self.tikCount = 60;
        
        __weak YXLoginVC *weakSelf = self;
        [[WXApiManager shared]setFinishBlock:^(id obj, BOOL result) {
            YXLoginSendModel *sendModel = [[YXLoginSendModel alloc]init];
            sendModel.pf = @"wechat";
            sendModel.code = obj;
            if (sendModel.code.length) {
                [weakSelf requestUserInfo:sendModel];
            }
        }];
        
        [[QQApiManager shared]setFinishBlock:^(id obj1, id obj2, BOOL result) {
            YXLoginSendModel *sendModel = [[YXLoginSendModel alloc]init];
            sendModel.pf = @"qq";
            sendModel.code = obj1;
            sendModel.openid = obj2;
            [weakSelf requestUserInfo:sendModel];
        }];
        
    }
    return self;
}

- (void)requestUserInfo:(YXLoginSendModel *)sendModel {
    __weak YXLoginVC *weakSelf = self;
    [YXUtils showHUD:self.view];
    [self.viewModel login:sendModel finished:^(id obj, BOOL result) {
        [YXUtils hideHUD:weakSelf.view];
        if (result) {
            [weakSelf.viewModel reportDeviceStatistics:^(id obj, BOOL result) {
            }];
            
            if ([YXConfigure shared].mobile.length == 0) { // 显示绑定手机页面
                YXBindPhoneVC *bindVC = [[YXBindPhoneVC alloc]init];
                [weakSelf.navigationController pushViewController:bindVC animated:YES];
            } else {
                YXLoginModel *model = obj;
                if (model.learning.bookid.length == 0) {
                    [[YXMediator shared]showSelectVC];
                } else {
                    [[YXMediator shared]showMainVC];
                }
            }
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorOfHex(0xffffff);
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, 25)];
    titleLab.text = @"念念有词";
    titleLab.textColor = UIColorOfHex(0x3DA6F4);
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    [titleImgView setFrame:CGRectMake((SCREEN_WIDTH-114)/2.0, 108, 114, 114)];
    titleImgView.image = [UIImage imageNamed:@"login_icon"];
    [self.view addSubview:titleImgView];
    
    //
    [self.phoneNum setFrame:CGRectMake(50, CGRectGetMaxY(titleImgView.frame)+40, SCREEN_WIDTH-100, 30)];
    
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
    
    if (iPhone5) {
        [self.verifyCode setFrame:CGRectMake(50, CGRectGetMaxY(phoneLine.frame)+25, SCREEN_WIDTH-100, 30)];
        [self.verifyBtn setFrame:CGRectMake(SCREEN_WIDTH-130, CGRectGetMaxY(phoneLine.frame)+30, 80, 16)];
        [verifyLine setFrame:CGRectMake(50, CGRectGetMaxY(self.verifyCode.frame), SCREEN_WIDTH-100, 1)];
    }
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.exclusiveTouch = YES;
    [self.loginBtn setFrame:CGRectMake(68, CGRectGetMaxY(verifyLine.frame)+55, SCREEN_WIDTH-136, 42)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.cornerRadius = 4.0f;
    [self.view addSubview:self.loginBtn];
    [self disableLoginBtn];
    
    if (iPhone5) {
        [self.loginBtn setFrame:CGRectMake(68, CGRectGetMaxY(verifyLine.frame)+30, SCREEN_WIDTH-136, 42)];
    }
    
    UIView *agreementView = [[UIView alloc]init];
    [self.view addSubview:agreementView];
    
    UILabel *agreementLab = [[UILabel alloc]init];
    agreementLab.text = @"登录即同意";
    agreementLab.textColor = UIColorOfHex(0x535353);
    agreementLab.font = [UIFont systemFontOfSize:10];
    agreementLab.textAlignment = NSTextAlignmentCenter;
    [agreementView addSubview:agreementLab];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"用户协议"];
    [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attrStr.string.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, attrStr.string.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x535353) range:NSMakeRange(0, attrStr.string.length)];
    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreementBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(policyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [agreementView addSubview:agreementBtn];
    
    CGSize agreeLabSize = [agreementLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH, 20) font:agreementLab.font];
    CGSize agreeBtnSize = [attrStr.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH, 20) font:[UIFont systemFontOfSize:10]];
    agreementView.frame = CGRectMake((SCREEN_WIDTH-agreeLabSize.width-agreeBtnSize.width)/2.0, CGRectGetMaxY(self.loginBtn.frame)+20, agreeLabSize.width+agreeBtnSize.width, 14);
    agreementLab.frame = CGRectMake(0, 0, agreeLabSize.width, 14);
    agreementBtn.frame = CGRectMake(agreeLabSize.width, 0, agreeBtnSize.width, 14);
    
    if (iPhone5) {
        agreementView.frame = CGRectMake((SCREEN_WIDTH-agreeLabSize.width-agreeBtnSize.width)/2.0, CGRectGetMaxY(self.loginBtn.frame)+15, agreeLabSize.width+agreeBtnSize.width, 14);
    }
    
    UILabel *thirdPartLab = [[UILabel alloc]init];
    thirdPartLab.frame = CGRectMake(0, CGRectGetMaxY(agreementView.frame)+56, SCREEN_WIDTH, 14);
    thirdPartLab.text = @"使用第三方登录";
    thirdPartLab.textColor = UIColorOfHex(0x999999);
    thirdPartLab.font = [UIFont systemFontOfSize:10];
    thirdPartLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdPartLab];
    
    if (iPhone5) {
        thirdPartLab.frame = CGRectMake(0, CGRectGetMaxY(agreementView.frame)+26, SCREEN_WIDTH, 14);
    }
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.exclusiveTouch = YES;
    [qqBtn setFrame:CGRectMake((SCREEN_WIDTH-170)/2.0, CGRectGetMaxY(thirdPartLab.frame)+20, 50, 50)];
    [qqBtn setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
    [qqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(qqBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    qqBtn.layer.cornerRadius = 25.0f;
    [self.view addSubview:qqBtn];
    
    if (iPhone5) {
        [qqBtn setFrame:CGRectMake((SCREEN_WIDTH-170)/2.0, CGRectGetMaxY(thirdPartLab.frame)+10, 50, 50)];
    }
    
    self.wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.wxBtn.exclusiveTouch = YES;
    [self.wxBtn setFrame:CGRectMake(SCREEN_WIDTH/2.0+35, CGRectGetMaxY(thirdPartLab.frame)+20, 50, 50)];
    [self.wxBtn setImage:[UIImage imageNamed:@"login_weichat"] forState:UIControlStateNormal];
    [self.wxBtn addTarget:self action:@selector(wxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.wxBtn.layer.cornerRadius = 25.0f;
    [self.view addSubview:self.wxBtn];
    
    if (iPhone5) {
        [self.wxBtn setFrame:CGRectMake(SCREEN_WIDTH/2.0+35, CGRectGetMaxY(thirdPartLab.frame)+10, 50, 50)];
    }

    
    if ([[WXApiManager shared] wxIsInstalled]) {
        self.wxBtn.hidden = NO;
    } else {
        self.wxBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)verifyBtnClicked:(id)sender {
    [self.view endEditing:YES];
    [self sendSMS:@"" finish:^(id obj, BOOL result) {}];
}

- (void)sendSMS:(NSString *)verifyCode finish:(finishBlock)block{
    __weak YXLoginVC* weakSelf = self;
    
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


- (void)wxBtnClicked:(id)sender {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    if (TARGET_IPHONE_SIMULATOR) {
        YXLoginSendModel *sendModel = [[YXLoginSendModel alloc]init];
        sendModel.pf = @"wechat";
        sendModel.code = @"011uMXtD0kAswc2vBuvD0SMZtD0uMXty";
        [self requestUserInfo:sendModel];
    } else {
        [[WXApiManager shared]wxLogin];
    }
    
}


- (void)qqBtnClicked:(id)sender {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    [[QQApiManager shared]qqLogin];
}

- (void)loginBtnClicked:(id)sender {
    YXLoginSendModel *sendModel = [[YXLoginSendModel alloc]init];
    sendModel.pf = @"mobile";
    sendModel.code = _verifyCode.text;
    sendModel.openid = @"";
    sendModel.mobile = [_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self requestUserInfo:sendModel];
}

- (void)policyBtnClicked:(id)sender {
    YXPolicyVC *policyVC = [[YXPolicyVC alloc]init];
    [self.navigationController pushViewController:policyVC animated:YES];
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

- (void)enableLoginBtn {
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"]
                             forState:UIControlStateNormal];
    self.loginBtn.enabled = YES;
}

- (void)disableLoginBtn {
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_gray_btn"]
                             forState:UIControlStateNormal];
    self.loginBtn.enabled = NO;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
            [self enableLoginBtn];
        } else {
            [self disableLoginBtn];
        }
        
    } else if (textField == _verifyCode) {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (result.length > 6) {
            return NO;
        }
        if ([[_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""] MobileNumber] && [result trimString].length == 6) {
            [self enableLoginBtn];
        } else {
            [self disableLoginBtn];
        }
    }
    return YES;
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;//白色
}


- (void)dealloc {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
