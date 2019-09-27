//
//  YXCareerCommentButton.m
//  YXEDU
//
//  Created by yixue on 2019/2/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerCommentButton.h"

@implementation YXCareerCommentButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColorOfHex(0x849EC5).CGColor;
        self.layer.cornerRadius = 12.5;
        
        self.titleLabel.font = [UIFont pfSCRegularFontWithSize:13];
        [self setImage:[UIImage imageNamed:@"showComment_gray"] forState:UIControlStateNormal];
        [self setTitle:@"遮住注释" forState:UIControlStateNormal];
        [self setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
//        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width - 1,
//                                                           0, self.imageView.image.size.width + 1)];
//        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.intrinsicContentSize.width + 1,
//                                                           0, -self.titleLabel.intrinsicContentSize.width - 1)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        [self setImage:[UIImage imageNamed:@"showComment_blue"] forState:UIControlStateNormal];
        [self setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        self.layer.borderColor = UIColorOfHex(0x55A7FD).CGColor;
    } else {
        [self setImage:[UIImage imageNamed:@"showComment_gray"] forState:UIControlStateNormal];
        [self setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
        self.layer.borderColor = UIColorOfHex(0x849EC5).CGColor;
    }
}

@end
