//
//  YXRegisterVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRegisterVC.h"
#import "BSCommon.h"

@interface YXRegisterVC () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UITextField *verifyCode;
@property (nonatomic, strong) UITextField *passField;
@end

@implementation YXRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyBtn setFrame:CGRectMake(30, 370 + 20, SCREEN_WIDTH - 60, 40)];
//    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifyBtn setBackgroundColor:UIColorOfHex(0xffe244)];
    [verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [verifyBtn addTarget:self action:@selector(verifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    verifyBtn.layer.cornerRadius = 20.0f;
    [self.phoneNum addSubview:verifyBtn];
    
    
    UIButton *lookPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookPassBtn setFrame:CGRectMake(30, 370 + 20, SCREEN_WIDTH - 60, 40)];
//    [lookPassBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [lookPassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookPassBtn setBackgroundColor:UIColorOfHex(0xffe244)];
    [lookPassBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [lookPassBtn addTarget:self action:@selector(lookPassBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    lookPassBtn.layer.cornerRadius = 20.0f;
    [self.passField addSubview:lookPassBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(30, 370 + 20, SCREEN_WIDTH - 60, 40)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:UIColorOfHex(0xffe244)];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.layer.cornerRadius = 20.0f;
    [self.view addSubview:registerBtn];
}

- (void)verifyBtnClicked:(id)sender {
    
}

- (void)lookPassBtnClicked:(id)sender {
    
}


- (void)registerBtnClicked:(id)sender {
    
}

- (UITextField* )phoneNum{
    if(!_phoneNum) {
        _phoneNum = [[UITextField alloc]init];
        _phoneNum.font = [UIFont systemFontOfSize:14];
        _phoneNum.placeholder = @"请输入用户名";
        _phoneNum.textColor = [UIColor blackColor];
        _phoneNum.keyboardType = UIKeyboardTypeDefault;
        //        _userField.backgroundColor = UIColorOfHex(0xf9f9f9);
        _phoneNum.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phoneNum.autocorrectionType = UITextAutocorrectionTypeNo;
        //        _userField.text = @"sj921";
        _phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNum.returnKeyType = UIReturnKeyNext;
        _phoneNum.delegate = self;
        [self.view addSubview:_phoneNum];
    }
    return _phoneNum;
}


- (UITextField* )verifyCode{
    if(!_verifyCode) {
        _verifyCode = [[UITextField alloc]init];
        _verifyCode.font = [UIFont systemFontOfSize:14];
        _verifyCode.placeholder = @"请输入用户名";
        _verifyCode.textColor = [UIColor blackColor];
        _verifyCode.keyboardType = UIKeyboardTypeDefault;
        //        _userField.backgroundColor = UIColorOfHex(0xf9f9f9);
        _verifyCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _verifyCode.autocorrectionType = UITextAutocorrectionTypeNo;
        //        _userField.text = @"sj921";
        _verifyCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verifyCode.returnKeyType = UIReturnKeyNext;
        _verifyCode.delegate = self;
        [self.view addSubview:_verifyCode];
    }
    return _verifyCode;
}

- (UITextField* )passField{
    if(!_passField) {
        _passField = [[UITextField alloc]init];
        _passField.leftView = [[UIView alloc]init];
        _passField.font = [UIFont systemFontOfSize:14];
        _passField.placeholder = @"请输入密码";
        _passField.textColor = [UIColor blackColor];
        _passField.secureTextEntry = YES;
        //        _passField.text = @"888888";
        //        _passField.backgroundColor = UIColorOfHex(0xf9f9f9);
        _passField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passField.returnKeyType = UIReturnKeyDone;
        _passField.delegate = self;
        [self.view addSubview:_passField];
    }
    return _passField;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneNum) {
        [_verifyCode becomeFirstResponder];
    } else if (textField == _verifyCode) {
        [_passField becomeFirstResponder];
    } else if (textField == _passField) {
        [_passField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
