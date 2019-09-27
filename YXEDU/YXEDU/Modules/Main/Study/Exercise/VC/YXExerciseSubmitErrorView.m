//
//  YXExerciseSubmitErrorView.m
//  YXEDU
//
//  Created by shiji on 2018/6/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXExerciseSubmitErrorView.h"
#import "BSCommon.h"
#import "YXAPI.h"
#import "YXFeedBackViewModel.h"
#import "YXUtils.h"

@interface UITextView (Placeholder)
-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor;
@end

@implementation UITextView (Placeholder)

-(void)setPlaceholder:(NSString *)placeholdStr placeholdColor:(UIColor *)placeholdColor
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeholdStr;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = placeholdColor;
    placeHolderLabel.font = self.font;
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    
    /*
     [self setValue:(nullable id) forKey:(nonnull NSString *)]
     ps: KVC键值编码，对UITextView的私有属性进行修改
     */
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
@end

@interface YXExerciseSubmitErrorView () <UITextViewDelegate>
@property (nonatomic, strong) UIControl *maskView;
@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UITextView *feedBackTextView;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) YXFeedBackViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, copy) finishBlock completeBlock;
@end

@implementation YXExerciseSubmitErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = [[YXFeedBackViewModel alloc]init];
        self.dataArr = [NSMutableArray array];
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        [self removeAllSubViews];
    } else {
        [self recreateSubViews];
    }
}

- (void)recreateSubViews {
    self.maskView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    self.maskView.userInteractionEnabled = YES;
    self.maskView.exclusiveTouch = YES;
    [self.maskView addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.maskView];
    
    self.whiteBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-122, SCREEN_WIDTH, SCREEN_HEIGHT-122)];
    self.whiteBackView.backgroundColor = [UIColor whiteColor];
    self.whiteBackView.exclusiveTouch = YES;
    [self addSubview:self.whiteBackView];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 25)];
    self.titleLab.font = [UIFont boldSystemFontOfSize:18];
    self.titleLab.textColor = UIColorOfHex(0x535353);
    self.titleLab.clipsToBounds = NO;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.text = @"请选择报错原因";
    [self.whiteBackView addSubview:self.titleLab];
    
    self.btnView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame)+ 10, SCREEN_WIDTH, 80)];
    [self.whiteBackView addSubview:self.btnView];
    
    for (int i=0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake((i%3 + 1)*(SCREEN_WIDTH-270)/4.0 + (i%3)*90, 10+40*(i/3), 90, 30)];
        [btn setTag:i];
        [btn setBackgroundImage:[UIImage imageNamed:@"study_error_selected"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"study_error_unselected"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateSelected];
        [btn setTitleColor:UIColorOfHex(0x999999) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.btnView addSubview:btn];
        if (i==0) {
            [btn setTitle:@"单词发音" forState:UIControlStateNormal];
        } else if (i == 1) {
            [btn setTitle:@"单词拼写" forState:UIControlStateNormal];
        } else if (i == 2) {
            [btn setTitle:@"单词意译" forState:UIControlStateNormal];
        } else if (i == 3) {
            [btn setTitle:@"例句" forState:UIControlStateNormal];
        } else if (i == 4) {
            [btn setTitle:@"图片不对" forState:UIControlStateNormal];
        } else if (i == 5) {
            [btn setTitle:@"答案有误" forState:UIControlStateNormal];
        }
    }
    self.feedBackTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.btnView.frame) + 10, SCREEN_WIDTH-40, 100)];
    self.feedBackTextView.backgroundColor = UIColorOfHex(0xF8F8F8);
    self.feedBackTextView.delegate = self;
    self.feedBackTextView.font = [UIFont systemFontOfSize:14];
    [self.feedBackTextView setPlaceholder:@"欢迎吐槽，我们会努力变得更好~" placeholdColor:[UIColor lightGrayColor]];
    [self.whiteBackView addSubview:self.feedBackTextView];
    
    self.numLab = [[UILabel alloc]init];
    [self.numLab setFrame:CGRectMake(SCREEN_WIDTH-80, 80+CGRectGetMaxY(self.btnView.frame) + 10, 50, 10)];
    [self.numLab setTextColor:UIColorOfHex(0x999999)];
    [self.numLab setText:@"0/50"];
    [self.numLab setFont:[UIFont systemFontOfSize:12]];
    [self.whiteBackView addSubview:self.numLab];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setFrame:CGRectMake((SCREEN_WIDTH-240)/2.0, CGRectGetMaxY(self.feedBackTextView.frame) + 20, 240, 42)];
    [self.submitBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
    [self.submitBtn setBackgroundColor:[UIColor clearColor]];
    [self.submitBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [self.whiteBackView addSubview:self.submitBtn];
    [self disableSubmitBtn];
    //
    [UIView animateWithDuration:0.2 animations:^{
        self.whiteBackView.frame = CGRectMake(0, 122, SCREEN_WIDTH, SCREEN_HEIGHT-122);
        self.maskView.alpha = 0.3;
    } completion:^(BOOL finished) {
        [self.feedBackTextView becomeFirstResponder];
        self.completeBlock(nil, YES);
    }];
}

- (void)showSubmitView:(finishBlock)block {
    self.userInteractionEnabled = NO;
    self.completeBlock = block;
    self.hidden = NO;
}

- (void)removeAllSubViews {
    RELEASE(_maskView);
    RELEASE(_whiteBackView);
    RELEASE(_titleLab);
    RELEASE(_btnView);
    RELEASE(_feedBackTextView);
    RELEASE(_numLab);
    RELEASE(_submitBtn);
    [YXUtils removeScreenShout];
}

- (void)btnClicked:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
        [self.dataArr removeObject:sender.titleLabel.text];
    } else {
        [sender setSelected:YES];
        [self.dataArr addObject:sender.titleLabel.text];
    }
    if (self.dataArr.count == 0 && self.feedBackTextView.text.length == 0) {
        [self disableSubmitBtn];
    } else {
        [self enableSubmitBtn];
    }
}

- (void)submitBtnClicked:(UIButton *)sender {
    YXFeedSendModel *sendModel = [[YXFeedSendModel alloc]init];
    sendModel.feed = [NSString stringWithFormat:@"%@%@",[self.dataArr componentsJoinedByString:@""], _feedBackTextView.text];
    sendModel.files = @[[UIImage imageWithContentsOfFile:[YXUtils screenShoutPath]]];
    sendModel.env = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@", [YXUtils machineName], [YXUtils systemVersion],[YXUtils appVersion],[YXUtils carrierName],[YXUtils networkType],[YXUtils screenInch],[YXUtils screenResolution]];
    [YXUtils showHUD:self];
    [self.viewModel submitFeedBack:sendModel finish:^(id obj, BOOL result) {
        if (result) {
            [YXUtils showHUD:[UIApplication sharedApplication].keyWindow title:@"提交成功"];
            [YXUtils hideHUD:self];
            [self tapAction:nil];
        }
    }];
}

- (void)tapAction:(UIButton *)gesture {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.whiteBackView.frame = CGRectMake(0, SCREEN_HEIGHT-122, SCREEN_WIDTH, SCREEN_HEIGHT-122);
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.userInteractionEnabled = YES;
    }];
}

#pragma mark -UITextViewDelegate-
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length > 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (result.length == 0 && self.dataArr.count == 0) {
        [self disableSubmitBtn];
    } else {
        [self enableSubmitBtn];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    self.numLab.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)textView.text.length];
}

- (void)enableSubmitBtn {
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"]
                             forState:UIControlStateNormal];
    self.submitBtn.enabled = YES;
}

- (void)disableSubmitBtn {
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"login_gray_btn"]
                             forState:UIControlStateNormal];
    self.submitBtn.enabled = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
