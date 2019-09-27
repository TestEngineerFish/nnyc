//
//  YXWordBookBaseManageView.m
//  YXEDU
//
//  Created by yao on 2019/3/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXWordBookBaseManageView.h"
@interface YXWordBookBaseManageView ()
@property (nonatomic, assign) BOOL replaceClearIcon;
@end

@implementation YXWordBookBaseManageView
+ (instancetype)wordBookBaseManageViewShowToView:(UIView *)view
                                           title:(NSString *)title
                                    inputDefText:(NSString *)defText
                                        delegate:(id<YXWordBookBaseManageViewDelegate>)delegate
{
    YXWordBookBaseManageView *manageView = [[self alloc] initWithFrame:view.bounds];
    manageView.titleLabel.text = title;
    manageView.textField.text = defText;
    [manageView textFieldChanged:manageView.textField];
    manageView.delegate = delegate;
    [view addSubview:manageView];

    [manageView layoutIfNeeded];
    [manageView.textField becomeFirstResponder];
    
    return manageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = kSCREEN_WIDTH - 15 * 2;
        [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(MakeAdaptCGSize(width, AdaptSize(210)));
        }];

        CGFloat margin = AdaptSize(16);

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contenView).offset(margin);
            make.right.equalTo(self.contenView).offset(-margin);
            make.top.equalTo(self.contenView).offset(AdaptSize(25));
        }];

        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.height.mas_equalTo(AdaptSize(50));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(AdaptSize(12));
        }];

        [self.canclebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(MakeAdaptCGSize(130, 41));
            make.bottom.equalTo(self.contenView).offset(-AdaptSize(20));
            make.right.equalTo(self.contenView.mas_centerX).offset(-margin);
        }];

        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.bottom.equalTo(self.canclebutton);
            make.left.equalTo(self.contenView.mas_centerX).offset(margin);
        }];

        [kNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

#pragma mark - 监听键盘
- (void)keyboardWillChangeFrame:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    CGFloat  animationDuration = [[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect finalFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect oriFrame = self.contenView.frame;
    if (finalFrame.origin.y < SCREEN_HEIGHT) { //  弹出
        oriFrame.origin.y = finalFrame.origin.y - oriFrame.size.height;
    }else {
        oriFrame.origin.y = (SCREEN_HEIGHT - oriFrame.size.height) * 0.5;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.contenView.frame = oriFrame;
    }];
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}

- (void)maskViewWasTapped {
    [self removeFromSuperview];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(18)];
        titleLabel.textColor = UIColorOfHex(0x485461);
        [self.contenView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIView *)contenView {
    if (!_contenView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.layer.cornerRadius = 5.0;
        contentView.layer.masksToBounds = YES;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        _contenView = contentView;
    }
    return _contenView;
}

- (UITextField *)textField {
    if (!_textField) {
        UITextField *textField = [[UITextField alloc] init];
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        textField.layer.cornerRadius = AdaptSize(7);
        textField.layer.borderWidth = 1.0;
        textField.backgroundColor = UIColorOfHex(0xF9FCFF);
        textField.layer.borderColor = UIColorOfHex(0xD2E0E8).CGColor;
        textField.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        textField.textColor = UIColorOfHex(0x485461);
        textField.leftViewMode =UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AdaptSize(7), 1)];
        [self.contenView addSubview:textField];
        _textField = textField;
    }
    return _textField;
}

- (YXSpringAnimateButton *)canclebutton {
    if (!_canclebutton) {
        YXSpringAnimateButton *canclebutton = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        canclebutton.tag = 0;
        [canclebutton addTarget:self action:@selector(manageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [canclebutton setTitle:@"取 消" forState:UIControlStateNormal];
        [canclebutton setTitleColor:UIColorOfHex(0x8095AB) forState:UIControlStateNormal];
        canclebutton.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(17)];
        [canclebutton setBackgroundImage:[UIImage imageNamed:@"alerCancleIcon"] forState:UIControlStateNormal];
        [self.contenView addSubview:canclebutton];
        _canclebutton = canclebutton;
    }
    return _canclebutton;
}

- (YXSpringAnimateButton *)confirmButton {
    if (!_confirmButton) {
        YXSpringAnimateButton *confirmButton = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        confirmButton.enabled = NO;
        confirmButton.tag = 1;
        [confirmButton addTarget:self action:@selector(manageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(17)];
        [confirmButton setBackgroundImage:[UIImage imageNamed:@"alerConfirmIcon"] forState:UIControlStateNormal];
        [self.contenView addSubview:confirmButton];
        _confirmButton = confirmButton;
    }
    return _confirmButton;
}

- (void)manageButtonClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(wordBookBaseManageView:clickedButonAtIndex:)]) {
        [self.delegate wordBookBaseManageView:self clickedButonAtIndex:btn.tag];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.replaceClearIcon) {
        self.replaceClearIcon = YES;
        UIButton *cleanBtn = [textField valueForKey:@"_clearButton"];
        [cleanBtn setImage:[UIImage imageNamed:@"clearBtnIcon"] forState:UIControlStateNormal];
        [cleanBtn setImage:[UIImage imageNamed:@"clearBtnIcon"] forState:UIControlStateHighlighted];
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)tf {
    self.confirmButton.enabled = tf.text.length;
}

- (NSString *)currentText {
    NSString *text = self.textField.text;
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [text stringByTrimmingCharactersInSet:set];
}
@end
