//
//  YXReportErrorView.m
//  YXEDU
//
//  Created by yao on 2018/10/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReportErrorView.h"
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

static const NSInteger MAX_NAME_LENGTH = 50;
@interface YXReportErrorView ()<UITextViewDelegate>
@property (nonatomic, weak)UIView *contentView;
@property (nonatomic, copy)NSArray *markTitles;
@property (nonatomic, assign)CGSize contentSize;
@property (nonatomic, weak)UIView *maskView;
@property (nonatomic, strong)NSMutableArray *selTitles;
@property (nonatomic, strong) UILabel *textNumberLabel;
@property (nonatomic, strong) UITextView *feedBackTextView;
@property (nonatomic, weak) UIButton *submit;

@property (nonatomic, copy)NSString *questionId;
@property (nonatomic, strong)UIImage *image;
@end
@implementation YXReportErrorView
+ (YXReportErrorView *)showToView:(UIView *)view {
//    YXReportErrorView *errorView = [[YXReportErrorView alloc] initWithFrame:view.bounds];
//    [view addSubview:errorView];
//
//    // 弹框动画有必要时添加
//    CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    animater.values = @[@1,@1.1,@1.0];
//    animater.duration = 0.25;
//    animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    errorView.maskView.alpha = 0;
//    [UIView animateWithDuration:0.25 animations:^{
//        errorView.maskView.alpha = 0.6;
//    }];
//    [errorView.contentView.layer addAnimation:animater forKey:nil];
////    [self.verifyCodeField becomeFirstResponder];
//    errorView.image = [view snapShot];
//    return errorView;
    return [self showToView:view withQuestionId:nil];
}

+ (YXReportErrorView *)showToView:(UIView *)view withQuestionId:(NSString *)questionId {
    YXReportErrorView *errorView = [[YXReportErrorView alloc] initWithFrame:view.bounds];
    errorView.questionId = questionId;
    [view addSubview:errorView];
    
    // 弹框动画有必要时添加
    CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animater.values = @[@1,@1.1,@1.0];
    animater.duration = 0.25;
    animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    errorView.maskView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        errorView.maskView.alpha = 0.6;
    }];
    [errorView.contentView.layer addAnimation:animater forKey:nil];
    //    [self.verifyCodeField becomeFirstResponder];
    errorView.image = [view snapShot];
    return errorView;
}

- (NSMutableArray *)selTitles {
    if (!_selTitles) {
        _selTitles = [NSMutableArray array];
    }
    return _selTitles;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.feedBackTextView];
        self.markTitles = @[@"单词发音",@"单词拼写",@"单词释义",@"例句",@"图片不对",@"答案有误"];
        UIView *maskView = [[UIView alloc] init];
        [self addSubview:maskView];
        maskView.backgroundColor = [UIColor blackColor];
        _maskView = maskView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
        [maskView addGestureRecognizer:tap];
        
        CGFloat margin = 25;
        CGSize contentSize = CGSizeMake(SCREEN_WIDTH - 2 * margin, 346);
        self.contentSize = contentSize;
        self.contentView.frame = CGRectMake(margin, 0, contentSize.width, contentSize.height);
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat contentlrMargin = 22;
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentlrMargin, 27, 250, 17)];
        tipsLabel.font = [UIFont boldSystemFontOfSize:15];
        tipsLabel.textColor = UIColorOfHex(0x000000);
        tipsLabel.text = @"请选择报错原因：（可多选）";
        [self.contentView addSubview:tipsLabel];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:[UIImage imageNamed:@"closeBtn"] forState:UIControlStateNormal];
        [self.contentView addSubview:closeBtn];
        closeBtn.frame = CGRectMake(contentSize.width - 5 - 26, 5, 26, 26);
        
        CGFloat top = 65;
        CGSize marksize = iPhone5 ? CGSizeMake(73 , 30) : CGSizeMake(88 , 30);
        NSInteger colum = 3;
        CGFloat gapMargin = (contentSize.width - 3 * marksize.width - 2 * contentlrMargin) * 0.5;
        for (NSInteger i = 0; i < self.markTitles.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = UIColorOfHex(0xC0C0C0).CGColor;
            btn.layer.borderWidth = 1;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:UIColorOfHex(0x323232) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self.contentView addSubview:btn];
            [btn addTarget:self action:@selector(selectMark:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:self.markTitles[i] forState:UIControlStateNormal];
            
            NSInteger line = i / colum;
            NSInteger colu = i % colum;
            CGFloat x = contentlrMargin + (marksize.width + gapMargin) * colu;
            CGFloat y = top + (marksize.height + 16) * line;
            btn.frame = CGRectMake(x, y, marksize.width, marksize.height);
        }
        
        self.feedBackTextView = [[UITextView alloc] initWithFrame:CGRectMake(contentlrMargin, 160, contentSize.width - 2 * contentlrMargin, 90)];
        self.feedBackTextView.backgroundColor = UIColorOfHex(0xF2F2F2);//[UIColor whiteColor ];
        //    self.feedBackTextView.delegate = self;
        
        self.feedBackTextView.font = [UIFont systemFontOfSize:14];
        self.feedBackTextView.layer.cornerRadius = 8;
        self.feedBackTextView.delegate = self;
        self.feedBackTextView.layer.masksToBounds = YES;
        self.feedBackTextView.layer.borderWidth = 1;
        self.feedBackTextView.layer.borderColor = UIColorOfHex(0xF2F2F2).CGColor;
        self.feedBackTextView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8);
        [self.feedBackTextView setPlaceholder:@"  若有其他原因，请轻点编辑" placeholdColor:UIColorOfHex(0xC0C0C0)];
        [self.contentView addSubview:self.feedBackTextView];
        self.textNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentSize.width- 32 - 60, 228, 60, 14)];
        self.textNumberLabel.textAlignment = NSTextAlignmentRight;
        [self.textNumberLabel setTextColor:UIColorOfHex(0x323232)];
        [self.textNumberLabel setText:@"0/50"];
        [self.textNumberLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.textNumberLabel];
    
        YXCustomButton *submit = [YXCustomButton commonBlueWithCornerRadius: 20];
        submit.disableColor = UIColorOfHex(0xFFF4E9);
        [submit setTitle:@"提交" forState:UIControlStateNormal];
        submit.userInteractionEnabled = NO;
        [submit setTitleColor:UIColorOfHex(0xFFFFFF) forState:UIControlStateNormal];
        submit.frame = CGRectMake((contentSize.width - 196) * 0.5, 276, 196, 44);
        [self.contentView addSubview:submit];
        [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        self.submit = submit;
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    NSLog(@"------%@",text);
//    if (!textView.text.length && text) {
//        return NO;
//    }else {
//
//    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *lang = [textView.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textView.text.length > MAX_NAME_LENGTH) {
                NSString *text = [textView.text substringToIndex:MAX_NAME_LENGTH];
                textView.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                [textView.undoManager removeAllActions];
            }else {
                textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        } else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        NSString *legalText = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (legalText.length > MAX_NAME_LENGTH) {
            legalText = [legalText substringToIndex:MAX_NAME_LENGTH];
        }
        textView.text = legalText;
        [textView.undoManager removeAllActions];
    }
    
    [self checkSubmitState];
    if (textView.text.length <= 50) {
        self.textNumberLabel.text = [NSString stringWithFormat:@"%zd/50", textView.text.length];
    }
}

- (void)submitAction {//当前question_id: 单词发音;好多好多简单就
    NSString *markStr = [self.selTitles componentsJoinedByString:@";"];
    NSString *feed = [NSString stringWithFormat:@"当前question_id:%@%@;%@",self.questionId,markStr,self.feedBackTextView.text];
    NSString *env = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@", [YXUtils machineName], [YXUtils systemVersion],[YXUtils appVersion],[YXUtils carrierName],[YXUtils networkType],[YXUtils screenInch],[YXUtils screenResolution]];
    UIImage *image = self.image;
    NSArray *files = @[image];
    NSDictionary *param = @{
                            @"feed" : feed,
                            @"env"  : env
                            };
    [YXDataProcessCenter UPLOAD:DOMAIN_FEEDBACK parameters:param datas:files finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            [self close];
            [YXUtils showHUD:[UIApplication sharedApplication].keyWindow title:@"提交成功"];
        }
    }];

//    NSMutableArray *imageArr = [NSMutableArray array];
//    for (UIImage *image in _selectImageView.imageArr) {
//        [imageArr addObject:image];
//    }
//    __weak YXPersonalFeedBackVC *weakSelf = self;
//    [YXUtils showHUD:self.view];
//    YXFeedSendModel *sendModel = [[YXFeedSendModel alloc]init];
//
//    sendModel.feed = self.feedBackTextView.text;
//    sendModel.files = imageArr;
//    sendModel.env = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@", [YXUtils machineName], [YXUtils systemVersion],[YXUtils appVersion],[YXUtils carrierName],[YXUtils networkType],[YXUtils screenInch],[YXUtils screenResolution]];
//
//    [self.feedViewModel submitFeedBack:sendModel finish:^(id obj, BOOL result) {
//        [YXUtils hideHUD:weakSelf.view];
//        if (result) {
//            [YXUtils showHUD:[UIApplication sharedApplication].keyWindow title:@"提交成功"];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        } else {
//            [YXUtils showHUD:self.view title:@"网络错误!"];
//        }
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.center = CGPointMake(self.center.x, self.center.y - 30);//self.center;
    self.maskView.frame = self.bounds;
}
- (void)selectMark:(UIButton *)button {
    button.selected = !button.selected;
    NSString *title = button.titleLabel.text;
    button.selected ? [self.selTitles addObject:title] : [self.selTitles removeObject:title];
    button.backgroundColor = button.selected ? UIColorOfHex(0xFBA217) : [UIColor whiteColor];
    button.layer.borderColor = button.selected ? UIColorOfHex(0xFBA217).CGColor : UIColorOfHex(0xC0C0C0).CGColor;
    [self checkSubmitState];
}

- (void)checkSubmitState {
    self.submit.userInteractionEnabled = (self.selTitles.count || self.feedBackTextView.text.length);
    UIColor *textColor = self.submit.userInteractionEnabled ? [UIColor whiteColor] : UIColorOfHex(0xEAD2BA);
    [self.submit setTitleColor:textColor forState:UIControlStateNormal];
}


- (void)close {
    [self removeFromSuperview];
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [[UIView alloc] init];
        contentView.layer.cornerRadius = 8;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (void)addMarkView {
    
}

- (void)textViewEditChanged:(NSNotification *)notification
{
    UITextView *textView = notification.object;
    int maxInputLength = 50;
    NSString *feedbackString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        // 系统的UITextRange，有两个变量，一个是start，一个是end，这是对于的高亮区域
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (feedbackString.length > maxInputLength) {
                textView.text = [feedbackString substringToIndex:maxInputLength];
            }
        } else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
            
        }
    }
    else{
        if (feedbackString.length > maxInputLength) {// 表情之类的，中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            textView.text = [feedbackString substringToIndex:maxInputLength];
        }
    }
    [self checkSubmitState];
    self.textNumberLabel.text = [NSString stringWithFormat:@"%lu/50", (unsigned long)textView.text.length];
}
@end
