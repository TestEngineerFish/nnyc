//
//  YXLotusView.m
//  YXEDU
//
//  Created by yao on 2019/1/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXLotusView.h"

@implementation YXCenterLabel
//- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
//    _edgeInsets = edgeInsets;
//    NSString *tempString = self.text;
//    self.text = @"";
//    self.text = tempString;
//
//}
//- (void)drawTextInRect:(CGRect)rect {
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
//}
@end


@implementation YXLotusView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self lotusIcon];
    }
    return self;
}

- (void)setCharacter:(NSString *)character {
    _character = character;
    CGFloat baseLine = 0;
    NSString *str = @"qypg";
    if ([str containsString:character]) {
        baseLine = AdaptSize(5);
    }
    NSDictionary *attributes = @{   NSBaselineOffsetAttributeName : @(baseLine)   };
    self.characterLabel.attributedText = [[NSAttributedString alloc] initWithString:character attributes:attributes];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
    
    if (self.state == YXLotusStateNormal) {
        self.lotusIcon.frame = CGRectMake(0, 0, kNormalLotusSize.width, kNormalLotusSize.height);
    }else {
        self.lotusIcon.frame = CGRectMake(0, 0, kUnNormalLotusSize.width, kUnNormalLotusSize.height);
    }
    self.lotusIcon.center = center;
    
    CGFloat wh = AdaptSize(50);
    self.characterLabel.frame = CGRectMake(0, 0, wh, wh);
    self.characterLabel.center = CGPointMake(size.width * 0.5, size.height * 0.5);
    
}

- (UIImageView *)lotusIcon {
    if (!_lotusIcon) {
        UIImageView *lotusIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normalLotusLeaf"]];
        lotusIcon.userInteractionEnabled = YES;
        [self addSubview:lotusIcon];
        _lotusIcon = lotusIcon;
    }
    return _lotusIcon;
}

- (YXCenterLabel *)characterLabel {
    if (!_characterLabel) {
        YXCenterLabel *characterLabel = [[YXCenterLabel alloc] init];
        characterLabel.edgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        characterLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(40)];
        characterLabel.textColor = UIColorOfHex(0xD8FFF8);
        characterLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:characterLabel];
        _characterLabel = characterLabel;
    }
    return _characterLabel;
}

- (void)setState:(YXLotusState)state {
    YXLotusState preState = _state;
    _state = state;
    
    NSString *lotusName = nil;
    if (state == YXLotusStateNormal) {
        lotusName = @"normalLotusLeaf";
    }else if(state == YXLotusStateSelect) {
        lotusName = @"selectedLotusLeaf";
    }else if(state == YXLotusStateCorrect) {
        lotusName = @"correctLotusLeaf";
    }else {
        lotusName = @"errorlLotusLeaf";
    }
    self.lotusIcon.image = [UIImage imageNamed:lotusName];
    if (preState != state) {
        [self setNeedsLayout];
    }
}
@end
