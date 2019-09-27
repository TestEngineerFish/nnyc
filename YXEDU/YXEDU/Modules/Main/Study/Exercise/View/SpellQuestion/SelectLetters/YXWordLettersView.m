//
//  YXWordLettersView.m
//  YXEDU
//
//  Created by yao on 2019/1/23.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXWordLettersView.h"

@implementation YXWordLettersView
{
    UILabel *_lettersLabel;
    CALayer *_indicator;
}

- (instancetype)initWithLettersModel:(YXLettersModel *)lettersModel {
    if (self = [super init]) {
        self.lettersModel = lettersModel;
        if (lettersModel.isBlank) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reverseSelect:)];
            [self addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)reverseSelect:(UITapGestureRecognizer *)tap {
    if (self.lettersLabel.text.length) {
        if ([self.delegate respondsToSelector:@selector(wordLettersViewReverseSelected:)]) {
            [self.delegate wordLettersViewReverseSelected:self];
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGFloat indicatorH = 1;
    self.lettersLabel.frame = CGRectMake(0, 0, size.width, size.height - indicatorH - 3);
    self.indicator.frame = CGRectMake(2, size.height - 1, size.width - 4, indicatorH);
}

- (void)setLettersModel:(YXLettersModel *)lettersModel {
    _lettersModel = lettersModel;
    self.lettersLabel.text = lettersModel.curCharacters;
    self.indicator.hidden = !lettersModel.isBlank;
}

- (void)setCharacterType:(YXCharacterType)characterType {
    _characterType = characterType;
    if (characterType == YXCharacterNormal) {
        self.lettersLabel.textColor = kLetterNormalColor;
        self.indicator.backgroundColor = kLetterNormalColor.CGColor;
    }else if (characterType == YXCharacterHighlight) {
        self.lettersLabel.textColor = kLetterHighLightColor;
        self.indicator.backgroundColor = kLetterHighLightColor.CGColor;
    }else {
        self.lettersLabel.textColor = kLetterErrorColor;
    }
}


- (void)setCurCharacter:(NSString *)curCharacter {
    _curCharacter = curCharacter;
    self.lettersLabel.text = curCharacter;
    self.lettersModel.curCharacters = curCharacter;
}

- (CALayer *)indicator {
    if (!_indicator) {
        CALayer *indicator = [CALayer layer];
        indicator.backgroundColor = kLetterNormalColor.CGColor;
        [self.layer addSublayer:indicator];
        _indicator = indicator;
    }
    return _indicator;
}

- (UILabel *)lettersLabel {
    if (!_lettersLabel) {
        UILabel *lettersLabel = [[UILabel alloc] init];
        lettersLabel.textAlignment = NSTextAlignmentCenter;
        lettersLabel.textColor = kLetterNormalColor;
        lettersLabel.font = [UIFont pfSCSemiboldFontWithSize:kDefaultCharacterFont];
        [self addSubview:lettersLabel];
        _lettersLabel = lettersLabel;
    }
    return _lettersLabel;
}
@end
