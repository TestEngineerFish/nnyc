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
#import "YXUserSaveTool.h"
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
#import "YXAPI.h"
#import "UIImageView+YR.h"
#import "YXAPI.h"
#import "NSString+YX.h"
#import "NSObject+YR.h"
#import "YXComHttpService.h"
#import "YXRouteManager.h"
#import "Growing.h"
#import "BSUtils.h"

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
@property (nonatomic, weak) YXComAlertView *commAlert;
@property (nonatomic, assign) NSRange phoneRange;
@property (nonatomic, strong) UIButton *wxBtn;
@property (nonatomic, weak)UIView *agreementView;
@property (nonatomic, weak)UIView *thirdLoginTipsView;
@property (nonatomic, weak)UIView *inputArea;
@end

@implementation YXLoginVC
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];

}

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
            sendModel.pf = kPlatformWX;
            sendModel.code = obj;
            [weakSelf traceEvent:kTracePlatformLoginResult traceType:kTraceResult descributtion:kPlatformWX];
            if (sendModel.code.length) {
                [weakSelf requestUserInfo:sendModel];
            }
        }];
        
        [[QQApiManager shared]setFinishBlock:^(id obj1, id obj2, BOOL result) {
            [MobClick event:kTracePlatformLoginResult];
            YXLoginSendModel *sendModel = [[YXLoginSendModel alloc]init];
            sendModel.pf = kPlatformQQ;
            sendModel.code = obj1;
            sendModel.openid = obj2;
            [weakSelf traceEvent:kTracePlatformLoginResult traceType:kTraceResult descributtion:kPlatformQQ];
            [weakSelf requestUserInfo:sendModel];
        }];
    }
    return self;
}


/**
 v2.0登陆方法
 @param sendModel 登陆模型
 */
- (void)requestUserInfo:(YXLoginSendModel *)sendModel {
    __weak YXLoginVC *weakSelf = self;
    [YXUtils showHUD:self.view];
    NSDictionary *params = (NSDictionary *)[sendModel yrModelToDictionary];
    [YXDataProcessCenter POST:DOMAIN_LOGIN parameters:params finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            // TODO::存储code
            NSString *token = [response.responseObject objectForKey:@"token"];
            NSString *uuid = [response.responseObject objectForKey:@"uuid"];
            [YXConfigure shared].token = token;
            
            if (![BSUtils isBlankString:uuid]) {
                [Growing setUserId:uuid];
            }
            
            [weakSelf.viewModel reportDeviceStatistics:^(id obj, BOOL result) {
            }];

            
            [weakSelf geConfigWith:sendModel.pf];
        }else {
            [YXUtils hideHUD:weakSelf.view];
        }
    }];
}

- (void)geConfigWith:(NSString *)pf {
    __weak typeof(self) weakSelf = self;
    [[YXComHttpService shared] requestConfig:^(YRHttpResponse *response, BOOL result) { 
        [YXUtils hideHUD:weakSelf.view];
        if (result) {
            YXConfigModel *config = response.responseObject;
            if (config.baseConfig.bindMobile == 0) { // 显示绑定手机页面
                [weakSelf presentBindViewControllerWithPf:pf];
            } else {
                [[YXConfigure shared] saveCurrentToken];
                if (config.baseConfig.learning == 0) {
                    [weakSelf presentSelectBookViewController];
                } else {
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [app showMainVC];
                }
            }
        }
    }];
}

- (void)presentSelectBookViewController {
//    YXSelectBookVC *selectBookVC = [[YXSelectBookVC alloc]init];
//    selectBookVC.isFirstLogin = YES;
//    selectBookVC.selectedBookSuccessBlock = ^{
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        [app showMainVC];
//    };
//    YXNavigationController *selecNaviVC = [[YXNavigationController alloc] initWithRootViewController:selectBookVC];
//    [self presentViewController:selecNaviVC animated:YES completion:nil];
}

- (void)presentBindViewControllerWithPf:(NSString *)pf {
    YXBindPhoneVC *bindPhoneVC = [[YXBindPhoneVC alloc] init];
    bindPhoneVC.pf = pf;
    YXNavigationController *bindVC = [[YXNavigationController alloc] initWithRootViewController:bindPhoneVC];
    [self presentViewController:bindVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topNavImageView.hidden = YES;
    self.view.backgroundColor = UIColorOfHex(0xffffff);
    [kNotificationCenter addObserver:self selector:@selector(presentSelectBookViewController) name:kShowSelectedBookVCNotify object:nil];
    UIImageView *titleImgView = [[UIImageView alloc]init];
    CGFloat wh;
    CGFloat topMargin;
    if (iPhone5) {
        wh = 210;
        topMargin = 40;
    }else {
        wh = 245;
        topMargin = 30;
    }
    [titleImgView setFrame:CGRectMake((SCREEN_WIDTH-wh)/2.0, 45 + (kIsIPhoneXSerious ? kStatusBarHeight : 0), wh, wh)];
    titleImgView.image = [UIImage imageNamed:@"login_icon"];
    [self.view addSubview:titleImgView];
    _earchImageView = titleImgView;

    // 30 + 1 + 35 + 30 +1
    CGFloat inoputMargin = iPhone5 ? 25 : 35;
    CGFloat leftAligent = 50;
    CGFloat widthAligen = SCREEN_WIDTH - 2 * leftAligent;
    CGFloat inputAreaH = 30 + 1 + (iPhone5 ? 20 : 35) + 30 +1;
    self.inputArea.frame = CGRectMake(leftAligent, CGRectGetMaxY(titleImgView.frame)+inoputMargin, widthAligen, inputAreaH);
    
    CGFloat loginBtnMargin = iPhone5 ? 25 : 30;
    
    self.loginBtn = [YXCustomButton comBlueShadowBtnWithSize:CGSizeMake(widthAligen, 44) WithCornerRadius:22];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn setFrame:CGRectMake(leftAligent, CGRectGetMaxY(self.inputArea.frame)+loginBtnMargin, widthAligen, 44)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.enabled = NO;
    
    [self disableLoginBtn];
    
     [self agreementView];
    
    CGFloat margin = iPhone5 ? 20 : 40;
    CGFloat thirdLoginTipsViewH = 14 + (iPhone5 ? 10 : 17) + 46;
    self.thirdLoginTipsView.frame = CGRectMake(50, CGRectGetMinY(self.agreementView.frame) - thirdLoginTipsViewH
                                               - margin , widthAligen, thirdLoginTipsViewH);//CGRectGetMaxY(self.loginBtn.frame)+20
    
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Growing clearUserId];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    [YXUtils showHUD:self.view];
    YXSendSMSModel *smsModel = [[YXSendSMSModel alloc]init];
    smsModel.mobile = [_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    smsModel.captcha = verifyCode;
    smsModel.type = @"login";

    // 统计
    [self traceEvent:kTraceIdentifyCode descributtion:kTraceCount];
    [Growing track:kGrowingTraceIdentifyCode withVariable:@{@"identify_code_type":@"login"}];

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
//                                                               [alertView updateVerifyCodeImage:[UIImage imageWithData:obj]];
                                                           }];
                                                       }];
                if (alert) {
                    weakSelf.commAlert = alert;
                }
                [weakSelf requestImage:^(id obj, BOOL result) {
//                    [weakSelf.commAlert updateVerifyCodeImage:[UIImage imageWithData:obj]];
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
        [self traceEvent:kTracePlatformLogin traceType:kTraceCount descributtion:kPlatformWX];
        [Growing track:kGrowingTraceLogin withVariable:@{@"login_type":@"wechat"}];
        [[WXApiManager shared]wxLogin];
    }
}

- (void)qqBtnClicked:(id)sender {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络错误!"];
        return;
    }
    [self traceEvent:kTracePlatformLogin traceType:kTraceCount descributtion:kPlatformQQ];
    [Growing track:kGrowingTraceLogin withVariable:@{@"login_type":@"qq"}];
    [[QQApiManager shared]qqLogin];
}

- (void)loginBtnClicked:(id)sender {
    YXLoginSendModel *sendModel = [[YXLoginSendModel alloc]init];
    sendModel.pf = @"mobile";
    sendModel.code = _verifyCode.text;
    sendModel.openid = @"";
    sendModel.mobile = [_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self traceEvent:kTraceLogin descributtion:kTraceCount];
    [Growing track:kGrowingTraceLogin withVariable:@{@"login_type":@"Moblie"}];
    [self requestUserInfo:sendModel];
}

- (void)policyBtnClicked:(id)sender {
//    YXPolicyVC *policyVC = [[YXPolicyVC alloc]init];
//    [self.navigationController pushViewController:policyVC animated:YES];
    [[YXRouteManager shared] openUrl:DOMAIN_AGREEMENT title:@"用户条款"];
}

#pragma mark - behavier
- (void)keyboardAction:(NSNotification*)sender{
     // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [value CGRectValue].size.height;
     // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    if ([sender.name isEqualToString:UIKeyboardWillShowNotification]) {
        CGFloat dy = SCREEN_HEIGHT - height - 15 - self.loginBtn.frame.size.height - self.loginBtn.frame.origin.y;
        CGFloat picX = self.inputArea.frame.origin.y - (self.inputArea.frame.origin.y - kStatusBarHeight - self.earchImageView.frame.size.height) - kStatusBarHeight + dy;
        CGFloat detlaRatio = picX/self.earchImageView.frame.size.height/1.0;
        CGFloat deltaX = self.earchImageView.frame.size.height - picX;
        if (dy != 0) {
            self.loginBtn.transform = CGAffineTransformMakeTranslation(0, dy);
            self.inputArea.transform = CGAffineTransformMakeTranslation(0, dy);
            self.earchImageView.transform = CGAffineTransformMakeScale(detlaRatio, detlaRatio);
            self.earchImageView.transform = CGAffineTransformTranslate(self.earchImageView.transform , 0, -deltaX);
        }
    } else {
        self.loginBtn.transform = CGAffineTransformIdentity;
        self.inputArea.transform = CGAffineTransformIdentity;
        self.earchImageView.transform = CGAffineTransformIdentity;
    }
}

- (void)enableLoginBtn {
    self.loginBtn.enabled = YES;
}

- (void)disableLoginBtn {
    self.loginBtn.enabled = NO;
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
    //修复 “先输入验证码、后手机号码、按钮不能点击的”bug
    if (textField == _phoneNum) {
        if (range.location>12) {
            [YXUtils showHUD:self.view title:@"手机号过长!"];
            return NO;
        }
        self.phoneRange = range;
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([[result stringByReplacingOccurrencesOfString:@" " withString:@""] MobileNumber] && _verifyCode.text.length == 6) {
            [self enableLoginBtn];
        } else {
            [self disableLoginBtn];
        }
        
    } else if (textField == _verifyCode) {
        NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (result.length > 6) {
            [YXUtils showHUD:self.view title:@"验证码过长!"];
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([[_phoneNum.text stringByReplacingOccurrencesOfString:@" " withString:@""] MobileNumber] && _verifyCode.text.length == 6) {
        [self enableLoginBtn];
    } else {
        [self disableLoginBtn];
    }
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;//白色
}


- (void)dealloc {
    [kNotificationCenter removeObserver:self];
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
        
        CGFloat margin = iPhone5 ? 25 : 30;
        [self.verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneNum);
            make.top.equalTo(phoneIcon.mas_bottom).offset(margin);
            make.right.equalTo(inputArea);
            make.height.mas_equalTo(30.f);
        }];
        
        [self.verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(self.verifyCode);
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        UIView *verifyLine = [[UIView alloc]init];
        verifyLine.backgroundColor = UIColorOfHex(0xD9E6EE);
        [inputArea addSubview:verifyLine];
        [verifyLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(inputArea);
            make.top.equalTo(self.verifyCode.mas_bottom);
            make.height.mas_equalTo(1.f);
        }];

    }
    return _inputArea;
}

- (UIView *)thirdLoginTipsView {
    if (!_thirdLoginTipsView) {
        UIView *thirdLoginTipsView = [[UIView alloc] init];
        [self.view addSubview:thirdLoginTipsView];
        _thirdLoginTipsView = thirdLoginTipsView;
        
        UILabel *thirdPartLab = [[UILabel alloc]init];
        thirdPartLab.text = @"快捷登录"; //@"使用第三方登录";
        thirdPartLab.textColor = UIColorOfHex(0xB7C2D4);
        thirdPartLab.font = [UIFont systemFontOfSize:13];
        thirdPartLab.textAlignment = NSTextAlignmentCenter;
        [thirdLoginTipsView addSubview:thirdPartLab];
        [thirdPartLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(thirdLoginTipsView);
        }];
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = UIColorOfHex(0xEAF4FC);
        [thirdLoginTipsView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(thirdPartLab.mas_left).offset(-20);
            make.left.equalTo(thirdLoginTipsView);
            make.height.mas_equalTo(1.f);
            make.centerY.equalTo(thirdPartLab);
        }];

        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = UIColorOfHex(0xEAF4FC);
        [thirdLoginTipsView addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(thirdPartLab.mas_right).offset(20);
            make.right.equalTo(thirdLoginTipsView);
            make.height.mas_equalTo(1.f);
            make.centerY.equalTo(thirdPartLab);
        }];
        
        UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qqBtn.exclusiveTouch = YES;
        [qqBtn setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
        [qqBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qqBtn addTarget:self action:@selector(qqBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        qqBtn.layer.cornerRadius = 25.0f;
        [thirdLoginTipsView addSubview:qqBtn];
        CGFloat margin = iPhone5 ? 10 : 17;
        [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(46, 46));
            make.right.equalTo(thirdLoginTipsView.mas_centerX).offset(-30);
            make.top.equalTo(thirdPartLab.mas_bottom).offset(margin);
        }];
        
        self.wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.wxBtn.exclusiveTouch = YES;
        [self.wxBtn setImage:[UIImage imageNamed:@"login_weichat"] forState:UIControlStateNormal];
        [self.wxBtn addTarget:self action:@selector(wxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.wxBtn.layer.cornerRadius = 25.0f;
        [thirdLoginTipsView addSubview:self.wxBtn];
        [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.top.equalTo(qqBtn);
            make.left.equalTo(thirdLoginTipsView.mas_centerX).offset(30);
        }];

        if ([[WXApiManager shared] wxIsInstalled]) {
            self.wxBtn.hidden = NO;
        } else {
            self.wxBtn.hidden = YES;
        }
    }
    return _thirdLoginTipsView;
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

- (UIView *)agreementView {
    if (!_agreementView) {
        UIView *agreementView = [[UIView alloc]init];
        [self.view addSubview:agreementView];
        _agreementView = agreementView;
        
        UILabel *agreementLab = [[UILabel alloc]init];
        [agreementView addSubview:agreementLab];
        
        NSMutableAttributedString *tipsAttri = [[NSMutableAttributedString alloc]
                                                initWithString:@"登录或注册即同意 "
                                                attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                             NSForegroundColorAttributeName : UIColorOfHex(0xB7C2D4)
                                                             }];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:@"用户协议"
                                              attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                                           NSForegroundColorAttributeName : UIColorOfHex(0x55a7fd)
                                                           }];
        [tipsAttri appendAttributedString:attrStr];
        agreementLab.attributedText = tipsAttri;
        
        UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreementBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        [agreementBtn addTarget:self action:@selector(policyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [agreementView addSubview:agreementBtn];
        
        CGSize agreeLabSize = tipsAttri.size;
        CGSize agreeBtnSize = attrStr.size;
        agreementLab.frame = CGRectMake(0, 0, agreeLabSize.width, 14);
        agreementBtn.frame = CGRectMake(agreeLabSize.width - agreeBtnSize.width, 0, agreeBtnSize.width, 14);
        agreementView.frame = CGRectMake((SCREEN_WIDTH-agreeLabSize.width)/2.0, SCREEN_HEIGHT - 14 - 14 - kSafeBottomMargin, agreeLabSize.width, 14);
    }
    return _agreementView;
}

@end


/**
 v1.4.0及以前版本登陆逻辑

 @param sendModel 登陆模型
 */
//- (void)requestUserInfo:(YXLoginSendModel *)sendModel {
//    __weak YXLoginVC *weakSelf = self;
//    [YXUtils showHUD:self.view];
//    [self.viewModel login:sendModel finishedBlock:^(YRHttpResponse *response, BOOL result) {
//        [YXUtils hideHUD:weakSelf.view];
//        [weakSelf traceEvent:kTraceLogin traceType:kTraceResult descributtion:sendModel.pf];
//        if (result) {
//            [weakSelf.viewModel reportDeviceStatistics:^(id obj, BOOL result) {
//            }];
//            YXConfigModel *config = [YXConfigure shared].confModel;
//            if (config.baseConfig.bindMobile == 0) { // 显示绑定手机页面
//                [weakSelf presentBindViewControllerWithPf:sendModel.pf];
//            } else {
//                if (config.baseConfig.learning == 0) {
//                    [weakSelf presentSelectBookViewController];
//                } else {
//                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                    [app showMainVC];
//                }
//            }
//        }
//    }];
//}
