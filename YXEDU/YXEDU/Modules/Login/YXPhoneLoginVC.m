//
//  YXPhoneLoginVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/23.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPhoneLoginVC.h"
#import "BSCommon.h"


@interface YXPhoneLoginVC () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneNum;
@property (nonatomic, strong) UITextField *passField;

@end

@implementation YXPhoneLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(30, 370 + 20, SCREEN_WIDTH - 60, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:UIColorOfHex(0xffe244)];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [loginBtn addTarget:self
                 action:@selector(loginBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 20.0f;
    [self.view addSubview:loginBtn];
    
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(30, 370 + 20, SCREEN_WIDTH - 60, 40)];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:UIColorOfHex(0xffe244)];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.layer.cornerRadius = 20.0f;
    [self.view addSubview:registerBtn];
    
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setFrame:CGRectMake(30, 370 + 20, SCREEN_WIDTH - 60, 40)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetBtn setBackgroundColor:UIColorOfHex(0xffe244)];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [forgetBtn addTarget:self action:@selector(forgetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.layer.cornerRadius = 20.0f;
    [self.view addSubview:forgetBtn];
}

- (void)loginBtnClicked:(id)sender {
    
}

- (void)registerBtnClicked:(id)sender {
    
}

- (void)forgetBtnClicked:(id)sender {
    
}




- (UITextField* )phoneNum{
    if(!_phoneNum) {
        _phoneNum = [[UITextField alloc]init];
        _phoneNum.font = [UIFont systemFontOfSize:14];
        _phoneNum.placeholder = @"请输入用户名";
        _phoneNum.textColor = [UIColor blackColor];
        _phoneNum.keyboardType = UIKeyboardTypeDefault;
        _phoneNum.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _phoneNum.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNum.returnKeyType = UIReturnKeyNext;
        _phoneNum.delegate = self;
        [self.view addSubview:_phoneNum];
    }
    return _phoneNum;
}


- (UITextField* )passField{
    if(!_passField) {
        _passField = [[UITextField alloc]init];
        _passField.leftView = [[UIView alloc]init];
        _passField.font = [UIFont systemFontOfSize:14];
        _passField.placeholder = @"请输入密码";
        _passField.textColor = [UIColor blackColor];
        _passField.secureTextEntry = YES;
        _passField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passField.returnKeyType = UIReturnKeyDone;
        _passField.delegate = self;
        [self.view addSubview:_passField];
    }
    return _passField;
}

- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
