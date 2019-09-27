//
//  YXLettersModel.m
//  YXEDU
//
//  Created by yao on 2019/1/23.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXLettersModel.h"

@implementation YXLettersModel
- (CGFloat)contentWidth {
    if (!_contentWidth) {
        if (self.curCharacters.length) {
            NSDictionary *attribute = @{NSFontAttributeName : [UIFont pfSCSemiboldFontWithSize:kDefaultCharacterFont]};
            _contentWidth = [self.curCharacters boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,AdaptSize(35))
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:attribute
                                                             context:nil].size.width + 5; // 左右预留间距
        }else {
            _contentWidth = kDefaultCharacterWith;
        }
    }
    return _contentWidth;
}

- (void)setCurCharacters:(NSString *)curCharacters {
    _curCharacters = curCharacters;
    _contentWidth = 0;
}

- (BOOL)isCorrect {
    return [_curCharacters isEqualToString:_oriCharacter];
}
@end
