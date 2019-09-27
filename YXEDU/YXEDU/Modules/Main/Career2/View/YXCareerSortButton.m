//
//  YXCareerSortButton.m
//  YXEDU
//
//  Created by yixue on 2019/2/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerSortButton.h"

@implementation YXCareerSortButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColorOfHex(0x849EC5).CGColor;
        self.layer.cornerRadius = 12.5;
        
        self.titleLabel.font = [UIFont pfSCRegularFontWithSize:13];
        [self setImage:[UIImage imageNamed:@"timeDown_gray"] forState:UIControlStateNormal];
        [self setTitle:@"时间倒序" forState:UIControlStateNormal];
        [self setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width - 1,
                                                  0, self.imageView.image.size.width + 1)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.intrinsicContentSize.width + 1,
                                                  0, -self.titleLabel.intrinsicContentSize.width - 1)];
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        [self setImage:[UIImage imageNamed:@"timeDown_blue"] forState:UIControlStateNormal];
        [self setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateNormal];
        self.layer.borderColor = UIColorOfHex(0x55A7FD).CGColor;
    } else {
        [self setImage:[UIImage imageNamed:@"timeDown_gray"] forState:UIControlStateNormal];
        [self setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
        self.layer.borderColor = UIColorOfHex(0x849EC5).CGColor;
    }
}

- (void)setCareerModel:(YXCareerModel *)careerModel {
    _careerModel = careerModel;
    NSString *titleStr = nil;
    switch (_careerModel.sort) {
        case 1:
            titleStr = @"时间倒序"; break;
        case 2:
            titleStr = @"时间正序"; break;
        case 3:
            titleStr = @"字母A-Z"; break;
        case 4:
            titleStr = @"字母Z-A"; break;
        case 5:
            titleStr = @"默认排序"; break;
        default:
            break;
    }
    [self setTitle:titleStr forState:UIControlStateNormal];
}

@end
