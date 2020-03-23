//
//  YXChangeNameViewController.m
//  YXEDU
//
//  Created by Jake To on 10/14/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXPersonChangeNameVC.h"
#import "BSCommon.h"

@interface YXPersonChangeNameVC ()

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation YXPersonChangeNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorOfHex(0xF6F8FA);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    backgroundView.backgroundColor = UIColor.whiteColor;
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = UIColorOfHex(0xedf2f6);
    [backgroundView addSubview:sepLine];
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.textColor = UIColorOfHex(0x8095AB);
//    nameLabel.text = @"昵称";
//    self.countLabel.textAlignment = NSTextAlignmentLeft;
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = UIColorOfHex(0x8095AB);
    self.countLabel.text = self.userNameLength;
    [self.countLabel setFont:[UIFont systemFontOfSize:14]];
    self.countLabel.textAlignment = NSTextAlignmentRight;
    
    self.textField = [[UITextField alloc] init];
    self.textField.text = self.userName;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.textColor = UIColorOfHex(0x485461);
    
//    [backgroundView addSubview:nameLabel];
    [backgroundView addSubview:self.textField];
    [backgroundView addSubview:self.countLabel];
    [self.view addSubview:backgroundView];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(backgroundView);
        make.height.mas_equalTo(1.0);
    }];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(backgroundView).offset(16);
//        make.width.mas_equalTo(0);
//        make.centerY.equalTo(backgroundView);
//    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).offset(16);
        make.right.equalTo(self.countLabel.mas_left).offset(-16);
        make.centerY.equalTo(backgroundView);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView).offset(-16);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(backgroundView);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)textFiledEditChanged:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    int maxInputLength = 10;
    NSString *nameString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        // 系统的UITextRange，有两个变量，一个是start，一个是end，这是对于的高亮区域
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (nameString.length > maxInputLength) {
                textField.text = [nameString substringToIndex:maxInputLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    else{
        if (nameString.length > maxInputLength) {// 表情之类的，中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            textField.text = [nameString substringToIndex:maxInputLength];
        }
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu/10", (unsigned long)textField.text.length];
}

- (void) done {
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
        UITextRange *selectedRange = [self.textField markedTextRange];
        //获取高亮部分
        // 系统的UITextRange，有两个变量，一个是start，一个是end，这是对于的高亮区域
        UITextPosition *position = [self.textField positionFromPosition:selectedRange.start offset:0];
        if (position) { // 如果有高亮部分
            UITextRange *range = [self.textField textRangeFromPosition:self.textField.beginningOfDocument toPosition:position];
            self.textField.text = [self.textField textInRange:range];
            [self.textField resignFirstResponder];
        }
    }
    
    NSString *name = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([name isEqualToString:@""] || [name isEqual:[NSNull null]] || name.length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self postName:name];
    }
}

- (void)postName:(NSString *)name {
    NSDictionary *paramter = @{@"nick":name};
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter POST:DOMAIN_SETUP parameters:paramter finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            YXLog(@"_+_+_++_++_++_+_+_+");
            weakSelf.returnNameStringBlock(name);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSInteger code = [[response.responseObject objectForKey:@"code"]longValue];
            
            if (code == 13051) {
                NSString *msg = [response.responseObject objectForKey:@"msg"];
                [YXUtils showHUD:[UIApplication sharedApplication].keyWindow title:msg];
            }
        }
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//- (void)textFieldDidChanged:(UITextField *)textField {
//
//    UITextRange *selectedRange = [textField markedTextRange];
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//
//    if(!position) {
//        if (textField.text.length > 10) {
//            textField.text = [textField.text substringToIndex:10];
//        }
//    }
//
//    self.countLabel.text = [NSString stringWithFormat:@"%lu/10", (unsigned long)textField.text.length];
//}

@end
