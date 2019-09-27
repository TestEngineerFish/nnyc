//
//  YXNinePalaceKeyBoardButton.m
//  YXEDU
//
//  Created by yixue on 2019/1/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXNinePalaceKeyBoardButton.h"
#import "YXSpellQuestionCommon.h"

@implementation YXNinePalaceKeyBoardButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont pfSCSemiboldFontWithSize:AdaptSize(20)];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.layer.cornerRadius = 6;
    }
    return self;
}

- (void)setStatus:(YXNinePalaceKeyBoardButtonStatus)status {
    _status = status;
    switch (_status) {
        case Normal:
            [self setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
            self.backgroundColor = UIColorOfHex(0xEDF3F8);
            break;
        case Selected:
            [self setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
            self.backgroundColor = UIColorOfHex(0xD0DBE5);
            break;
        case Wrong:
            [self setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
            self.backgroundColor = kLetterErrorColor;
            break;
    }
}

- (void)setLetters:(NSString *)letters {
    _letters = letters;
    [self setTitle:letters forState:UIControlStateNormal];
}

@end
