//
//  YXPersonalFeedBackVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalFeedBackVC.h"
#import "BSCommon.h"
#import "TZImagePickerController.h"
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

@interface YXPersonalFeedBackVC () <YXFeedBackSelectImageViewDelegate, TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextView *feedBackTextView;
@property (nonatomic, strong) UILabel *textNumberLabel;
@property (nonatomic, strong) UILabel *imageNumberLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIImageView *fullScreenImageView;
@property (nonatomic, strong) YXFeedBackViewModel *feedViewModel;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIView *dotView;
@end

@implementation YXPersonalFeedBackVC

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.feedViewModel = [[YXFeedBackViewModel alloc]init];
    }
    return self;
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        CGRect frame     = CGRectMake(0, 0, AdaptSize(22), AdaptSize(22));
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setImage:[UIImage imageNamed:@"feedbackIcon"] forState:UIControlStateNormal];
        UIView *customView = [[UIView alloc] initWithFrame:frame];
        [button addTarget:self action:@selector(feedbackAction) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:button];
        [customView addSubview:self.dotView];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    }
    return _rightItem;
}

- (void)feedbackAction {
    YXFeedbackListViewController *vc = [[YXFeedbackListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)dotView {
    if (!_dotView) {
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(AdaptSize(18), 0, AdaptSize(5), AdaptSize(5))];
        _dotView.layer.cornerRadius  = AdaptSize(2.5);
        _dotView.layer.masksToBounds = YES;
        _dotView.backgroundColor     = UIColorOfHex(0xFF532B);
    }
    return _dotView;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [YXLogManager.share report:NO];
    self.backType = BackWhite;
    [super viewDidLoad];
    self.feedViewModel = [[YXFeedBackViewModel alloc]init];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.feedBackTextView];

    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor     = UIColor.whiteColor;
    self.containerView.layer.borderWidth   = 1;
    self.containerView.layer.borderColor   = UIColor.whiteColor.CGColor;
    self.containerView.layer.cornerRadius  = 8;
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.shadowColor   = UIColorOfHex(0xD0E0EF).CGColor;
    self.containerView.layer.shadowRadius  = 3;
    self.containerView.layer.shadowOpacity = 0.5;
    self.containerView.layer.shadowOffset  = CGSizeMake(0, 2);
    
    self.feedBackTextView = [[UITextView alloc]init];
    self.feedBackTextView.backgroundColor = [UIColor whiteColor ];
//    self.feedBackTextView.delegate = self;
    self.feedBackTextView.font = [UIFont systemFontOfSize:16];
    [self.feedBackTextView setPlaceholder:@"请输入您的宝贵意见，我们将认真对待每一条反馈。(必填)" placeholdColor:[UIColor lightGrayColor]];

    self.textNumberLabel = [[UILabel alloc]init];
    self.textNumberLabel.textAlignment = NSTextAlignmentRight;
    [self.textNumberLabel setTextColor:UIColorOfHex(0xC0C0C0)];
    [self.textNumberLabel setText:@"0 / 140"];
    [self.textNumberLabel setFont:[UIFont systemFontOfSize:16]];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 180, self.containerView.frame.size.width, 0.5)];
    self.lineView.backgroundColor = UIColorOfHex(0xDCDCDC);
    
    self.imageNumberLabel = [[UILabel alloc]init];
    self.imageNumberLabel.textAlignment = NSTextAlignmentLeft;
    [self.imageNumberLabel setTextColor:UIColorOfHex(0x666666)];
    [self.imageNumberLabel setText:@"上传图片（ 0 / 3 ）"];
    [self.imageNumberLabel setFont:[UIFont systemFontOfSize:14]];

    self.submitButton = [YXCustomButton commonBlueWithCornerRadius:22];
    self.submitButton.backgroundColor = UIColorOfHex(0xFFF4E9);
    [self.submitButton setTitleColor:UIColorOfHex(0xEAD2BA) forState:UIControlStateDisabled];
    [self.submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.enabled = NO;

    self.selectImageView = [[YXFeedBackSelectImageView alloc]init];
    [self.selectImageView setDelegate:self];

    if (self.screenShotImage) {
        self.selectImageView.imageArr = [NSMutableArray arrayWithObject:self.screenShotImage];
        
        NSMutableArray *feedbackImages = [NSMutableArray arrayWithArray:self.selectImageView.imageArr];
        NSInteger imageNumber = feedbackImages.count;
        self.imageNumberLabel.text = [NSString stringWithFormat:@"上传图片（ %ld / 3 ）", (long)imageNumber];
    }
    
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.submitButton];
    [self.containerView addSubview:self.feedBackTextView];
    [self.containerView addSubview:self.textNumberLabel];
    [self.containerView addSubview:self.lineView];
    [self.containerView addSubview:self.imageNumberLabel];
    [self.containerView addSubview:self.selectImageView];
    
    [self.feedBackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(180);
    }];
    
    [self.textNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedBackTextView.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textNumberLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(1);
    }];
    
    [self.imageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(12);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageNumberLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(64);
    }];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(16);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(364);
        make.centerX.equalTo(self.view);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(24);
        make.left.equalTo(self.view).offset(86);
        make.right.equalTo(self.view).offset(-86);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger badgeNum = [YXBadgeManger.share getFeedbackReplyBadgeNum];
    [self.dotView setHidden:(badgeNum <= 0)];
    self.textColorType = TextColorWhite;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)submit:(id)sender {
    NSMutableArray *imageArr = [NSMutableArray array];
    for (UIImage *image in _selectImageView.imageArr) {
        [imageArr addObject:image];
    }
    if ([self.feedBackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [YXUtils showHUD:self.navigationController.view title:@"请填写反馈内容!"];
        return;
    }
    if (imageArr.count == 0) {
        [YXUtils showHUD:self.navigationController.view title:@"请上传您遇到问题时的屏幕截图!"];
        return;
    }
    __weak YXPersonalFeedBackVC *weakSelf = self;
    [YXUtils showHUD:self.view];
    YXFeedSendModel *sendModel = [[YXFeedSendModel alloc]init];
    
    sendModel.feed = self.feedBackTextView.text;
    sendModel.files = imageArr;
    sendModel.env = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@", [YXUtils machineName], [YXUtils systemVersion],[YXUtils appVersion],[YXUtils carrierName],[YXUtils networkType],[YXUtils screenInch],[YXUtils screenResolution]];
    
    [self.feedViewModel submitFeedBack:sendModel finish:^(id obj, BOOL result) {
        [YXUtils hideHUD:weakSelf.view];
        if (result) {
            [YXUtils showHUD:[UIApplication sharedApplication].keyWindow title:@"提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
//            [YXUtils showHUD:self.view title:@"网络错误!"];
        }
    }];
}

- (void)enableSubmitBtn {
    [self.submitButton setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
    self.submitButton.enabled = YES;
}

- (void)disableSubmitBtn {
    [self.submitButton setTitleColor:UIColorOfHex(0x91D0FF) forState:UIControlStateNormal];
    self.submitButton.enabled = NO;
}

#pragma mark -UITextViewDelegate-
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
        return NO;
    }
    if ([self isNineKeyBoard:text] ){
        return YES;
    } else {
        if ([self hasEmoji:text] || [self stringContainsEmoji:text]){
            return NO;
        }
    }
    
    if (textView.text.length > 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    
//    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    self.submitButton.enabled = textView.text.length;
//    if (textView.text.length > 0) {
//        [self enableSubmitBtn];
//    } else {
//        [self disableSubmitBtn];
//    }
    return YES;
}

-(BOOL)isNineKeyBoard:(NSString *)string {
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++) {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}



- (BOOL)hasEmoji:(NSString*)string {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

- (NSString *)filterEmoji:(NSString *)string {
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [string UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = utf8;
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8;
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8 encoding:NSUTF8StringEncoding];
    free( newUTF8 );
    return encrypted;
}

- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
    
}

//- (void)textViewDidChange:(UITextView *)textView {
//
//    UITextRange *selectedRange = [textView markedTextRange];
//    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
//
//    if(!position) {
//        if (textView.text.length > 140) {
//            textView.text = [textView.text substringToIndex:140];
//        }
//    }
//
////    if (textView.text.length > 140) {
////        textView.text = [textView.text substringToIndex:140];
////    }
//    self.textNumberLabel.text = [NSString stringWithFormat:@"%lu / 140", (unsigned long)textView.text.length];
//}

- (void)textViewEditChanged:(NSNotification *)notification
{
    UITextView *textView = notification.object;
    int maxInputLength = 140;
    NSString *feedbackString = textView.text;
    NSString *lang = [textView.textInputMode primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        // 系统的UITextRange，有两个变量，一个是start，一个是end，这是对于的高亮区域
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (!position) { // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (feedbackString.length > maxInputLength) {
                NSString *text = [feedbackString substringToIndex:maxInputLength];
                textView.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }else {
                 textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        } else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    } else {
         NSString *legalText = [feedbackString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (legalText.length > maxInputLength) {// 表情之类的，中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            legalText = [legalText substringToIndex:maxInputLength];
        }
        textView.text = legalText;
    }
    [textView.undoManager removeAllActions];
    self.textNumberLabel.text = [NSString stringWithFormat:@"%lu / 140", textView.text.length >= 140? 140:(unsigned long)textView.text.length ];
    self.submitButton.enabled = textView.text.length;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didClickedAddImage:(id)sender {
    TZImagePickerController *pickerCtrl = [[TZImagePickerController alloc] initWithMaxImagesCount:3-_selectImageView.imageArr.count delegate:self];
    
    __weak typeof(self)weakSelf = self;
    [pickerCtrl setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        
        NSMutableArray *feedbackImages = [NSMutableArray arrayWithArray:_selectImageView.imageArr];
        [feedbackImages addObjectsFromArray:photos];
        
        NSInteger imageNumber = feedbackImages.count;
        weakSelf.imageNumberLabel.text = [NSString stringWithFormat:@"上传图片（ %ld / 3 ）", (long)imageNumber];
        
        _selectImageView.imageArr = [NSMutableArray arrayWithArray:feedbackImages];
    }];
    [self presentViewController:pickerCtrl animated:YES completion:nil];
}

- (void)didShowAddedImage:(UIImage *)image {
    
    CGRect fullScreen = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.fullScreenImageView = [[UIImageView alloc] initWithFrame:fullScreen];
    self.fullScreenImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.fullScreenImageView.backgroundColor = UIColor.blackColor;
    self.fullScreenImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseFullScreenImage:)];
    [self.fullScreenImageView addGestureRecognizer:tap];
    
    self.fullScreenImageView.image = image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.fullScreenImageView];
    
    [self.view setUserInteractionEnabled:NO];
}

- (void)didTapedCloseImage:(id)sender {
    NSMutableArray *feedbackImages = [NSMutableArray arrayWithArray:_selectImageView.imageArr];
    
    NSInteger imageNumber = feedbackImages.count;
    self.imageNumberLabel.text = [NSString stringWithFormat:@"上传图片（ %ld / 3 ）", (long)imageNumber];
}

- (void)tapToCloseFullScreenImage:(UITapGestureRecognizer *)tap {
//    UIView *backgroundView = tap.view;
//    UIImageView *imageView=(UIImageView *)[tap.view viewWithTag:1];
//    [UIView animateWithDuration:0.2 animations:^{
//        imageView.frame = oldframe;
//        backgroundView.alpha = 0;
//    } completion:^(BOOL finished) {
    [self.fullScreenImageView removeFromSuperview];
    [self.view setUserInteractionEnabled:YES];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
