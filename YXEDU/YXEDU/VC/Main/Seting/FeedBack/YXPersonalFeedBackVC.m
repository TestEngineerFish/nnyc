//
//  YXPersonalFeedBackVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalFeedBackVC.h"
#import "BSCommon.h"
#import "YXFeedBackSelectImageView.h"
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

@interface YXPersonalFeedBackVC () <UITextViewDelegate, YXFeedBackSelectImageViewDelegate, TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextView *feedBackTextView;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) YXFeedBackSelectImageView *selectImageView;
@property (nonatomic, strong) YXFeedBackViewModel *feedViewModel;
@end

@implementation YXPersonalFeedBackVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.feedViewModel = [[YXFeedBackViewModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    self.backType = BackWhite;
    [super viewDidLoad];
    self.view.backgroundColor = UIColorOfHex(0x4DB3FE);
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    self.backView.backgroundColor = UIColorOfHex(0xffffff);
    [self.view addSubview:self.backView];

    self.title = @"意见反馈";
    self.feedBackTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 180)];
    self.feedBackTextView.backgroundColor = [UIColor whiteColor];
    self.feedBackTextView.delegate = self;
    self.feedBackTextView.font = [UIFont systemFontOfSize:14];
    [self.feedBackTextView setPlaceholder:@"请输入您的宝贵意见，我们将认真对待每一条反馈。" placeholdColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.feedBackTextView];

    self.numLab = [[UILabel alloc]init];
    [self.numLab setFrame:CGRectMake(SCREEN_WIDTH-60, 150 + NavHeight, 50, 10)];
    [self.numLab setTextColor:UIColorOfHex(0x999999)];
    [self.numLab setText:@"0/140"];
    [self.numLab setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:self.numLab];

    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 179.5, SCREEN_WIDTH, 0.5)];
    self.lineView.backgroundColor = UIColorOfHex(0xf6f6f6);
    self.lineView.alpha = 0.5;
    [self.feedBackTextView addSubview:self.lineView];

    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.exclusiveTouch = YES;
    [self.rightBtn setFrame:CGRectMake(SCREEN_WIDTH-60, 14, 38, 25)];
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
    [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self disableSubmitBtn];

    self.selectImageView = [[YXFeedBackSelectImageView alloc]init];
    [self.selectImageView setFrame:CGRectMake(0, CGRectGetMaxY(self.feedBackTextView.frame)+20, SCREEN_WIDTH, 100)];
    [self.selectImageView setDelegate:self];
    [self.view addSubview:self.selectImageView];

    UIImage *image = [UIImage imageWithContentsOfFile:[YXUtils screenShoutPath]];
    if (image) {
        self.selectImageView.imageArr = [NSMutableArray arrayWithObject:image];
    }
}

- (void)rightBtnClicked:(id)sender {
    NSMutableArray *imageArr = [NSMutableArray array];
    for (UIImage *image in _selectImageView.imageArr) {
        [imageArr addObject:image];
    }
    if (self.feedBackTextView.text.length == 0) {
        [YXUtils showHUD:self.navigationController.view title:@"请填写反馈内容!"];
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
            [YXUtils showHUD:self.view title:@"网络错误!"];
        }
    }];
}

- (void)enableSubmitBtn {
    [self.rightBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
    self.rightBtn.enabled = YES;
}

- (void)disableSubmitBtn {
    [self.rightBtn setTitleColor:UIColorOfHex(0x91D0FF) forState:UIControlStateNormal];
    self.rightBtn.enabled = NO;
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
    
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (result.length > 0) {
        [self enableSubmitBtn];
    } else {
        [self disableSubmitBtn];
    }
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







- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    self.numLab.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)textView.text.length];
}

- (void)viewWillAppear:(BOOL)animated {
    self.textColorType = TextColorWhite;
    [super viewWillAppear:animated];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -YXFeedBackSelectImageViewDelegate-
- (void)didClickedAddImage:(id)sender {
    TZImagePickerController *pickerCtrl = [[TZImagePickerController alloc]initWithMaxImagesCount:3-_selectImageView.imageArr.count delegate:self];
    [pickerCtrl setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_selectImageView.imageArr];
        [arr addObjectsFromArray:photos];
        _selectImageView.imageArr = [NSMutableArray arrayWithArray:arr];
    }];
    [self presentViewController:pickerCtrl animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
