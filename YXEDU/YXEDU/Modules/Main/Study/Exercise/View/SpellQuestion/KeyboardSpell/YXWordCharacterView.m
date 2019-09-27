//
//  YXWordCharacterView.m
//  1111
//
//  Created by yao on 2018/11/1.
//  Copyright © 2018年 yao. All rights reserved.
//

#import "YXWordCharacterView.h"
@implementation YXCharacterModel

@end



@interface YXCharacterTextField() <UIGestureRecognizerDelegate>
@end
@implementation YXCharacterTextField
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:kDefaultCharacterFont];
        self.textColor = kLetterNormalColor;
        self.tintColor = [UIColor clearColor];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.inputAccessoryView = [[UIView alloc] init];
        self.returnKeyType = UIReturnKeyDone;
    }
    return self;
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    if (self.attributedText.string.length) {
        NSDictionary *attDic = @{NSForegroundColorAttributeName : textColor,NSFontAttributeName : self.font};
        self.attributedText = [[NSAttributedString alloc] initWithString:self.attributedText.string attributes:attDic];
    }
}
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        gestureRecognizer.delegate = self;
    }
    [super addGestureRecognizer:gestureRecognizer];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)deleteBackward {
    if ([self.characterTFDelegate respondsToSelector:@selector(characterTextFieldDeleteBackward:)]) {
        [self.characterTFDelegate characterTextFieldDeleteBackward:self];
    }
    [super deleteBackward];
}

- (void)insertText:(NSString *)text {
    [super insertText:text];
}

//- (BOOL)becomeFirstResponder {
//    BOOL isb = [super becomeFirstResponder];
//    return isb;
//    
//}
//
//- (BOOL)resignFirstResponder {
//    return [super resignFirstResponder];
//}
@end








static NSString *const kSpellLeagelCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz .-'";
@interface YXWordCharacterView ()<UITextFieldDelegate,YXCharacterTextFieldDelegate>

@end

@implementation YXWordCharacterView
{
    CALayer *_indicator;
    YXCharacterTextField *_characterTF;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self indicator];
        [self characterTF];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSString *)curCharacter {
    return self.characterTF.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGFloat indicatorH = 1;
    self.characterTF.frame = CGRectMake(0, 0, size.width, size.height - indicatorH - 3);
    self.indicator.frame = CGRectMake(2, size.height - 1, size.width - 4, indicatorH);
}

- (BOOL)isCorrect {
    return [self.characterTF.text isEqual:self.chModel.oriCharacter];
}

- (BOOL)hasInput {
    return self.characterTF.text.length;
}

- (void)setChModel:(YXCharacterModel *)chModel {
    _chModel = chModel;
    self.characterTF.text = chModel.oriCharacter;
    self.indicator.hidden = !chModel.isBlank;
    // 如果为空不能编辑
    self.characterTF.userInteractionEnabled = chModel.isBlank;
}

- (void)setCharacterType:(YXCharacterType)characterType {
    _characterType = characterType;
    if (characterType == YXCharacterNormal) {
        self.characterTF.textColor = kLetterNormalColor;
        self.indicator.backgroundColor = kLetterNormalColor.CGColor;
    }else if (characterType == YXCharacterHighlight) {
        self.characterTF.textColor = kLetterHighLightColor;
        self.indicator.backgroundColor = kLetterHighLightColor.CGColor;
        [self.characterTF becomeFirstResponder];
    }else {
        self.characterTF.textColor = kLetterErrorColor;
    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length) {
//        NSLog(@"---------->%@",string);
        if([kSpellLeagelCharacters containsString:string]) { //去除非法字符
            textField.text = [string substringToIndex:1];
            if ([self.delegate respondsToSelector:@selector(wordCharacterViewHandoverToNextResponder:)]) {
                [self.delegate wordCharacterViewHandoverToNextResponder:self];
            }
        }

         return NO;
    }
    return YES;
}

- (void)characterTextFieldDeleteBackward:(YXCharacterTextField *)characterTF {
    if (characterTF.text.length) { // 删除当前字母
        characterTF.text = @"";
    }else {
        if ([self.delegate respondsToSelector:@selector(wordCharacterViewandoverToPreviousResponder:)]) {
            [self.delegate wordCharacterViewandoverToPreviousResponder:self];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(wordCharacterViewBecomeResponder:)]) {
        [self.delegate wordCharacterViewBecomeResponder:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if ([self.delegate respondsToSelector:@selector(wordCharacterViewResignResponder:)]) {
//        [self.delegate wordCharacterViewResignResponder:self];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(wordCharacterViewClickCheckResult:)]) {
        [self.delegate wordCharacterViewClickCheckResult:self];
    }
    return YES;
}
#pragma mark - subviews
- (void)setCharacterFont:(UIFont *)characterFont {
    _characterFont = characterFont;
    self.characterTF.font = characterFont;
}

- (CALayer *)indicator {
    if (!_indicator) {
        CALayer *indicator = [CALayer layer];
        indicator.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:indicator];
        _indicator = indicator;
    }
    return _indicator;
}

- (YXCharacterTextField *)characterTF {
    if (!_characterTF) {
        YXCharacterTextField *characterTF = [[YXCharacterTextField alloc] init];
        characterTF.delegate = self;
        characterTF.characterTFDelegate = self;
        [self addSubview:characterTF];
        _characterTF = characterTF;
    }
    return _characterTF;
}
@end
