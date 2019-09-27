//
//  YXChangeWordlistNameView.m
//  YXEDU
//
//  Created by yao on 2019/3/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXChangeWordlistNameView.h"

static NSInteger const KNameMaxLength = 20;
@interface YXChangeWordlistNameView ()
@property (nonatomic, weak) UILabel *countLabel;
@end

@implementation YXChangeWordlistNameView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textField);
            make.top.equalTo(self.textField.mas_bottom).offset(AdaptSize(7));
        }];
    }
    return self;
}


- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(13)];
        countLabel.textColor = UIColorOfHex(0x849EC5);
        [self.contenView addSubview:countLabel];
        _countLabel = countLabel;
    }
    return _countLabel;
}

- (void)textFieldChanged:(UITextField *)tf {
    [super textFieldChanged:tf];
    
    if (tf.markedTextRange == nil) {
        if (tf.text.length > KNameMaxLength) {
            tf.text = [tf.text substringToIndex:KNameMaxLength];
            self.countLabel.text = [NSString stringWithFormat:@"%zd/%zd",tf.text.length,KNameMaxLength];
            self.countLabel.textColor = [UIColor redColor];
        }else {
            self.countLabel.text = [NSString stringWithFormat:@"%zd/%zd",tf.text.length,KNameMaxLength];
            self.countLabel.textColor = (tf.text.length == KNameMaxLength) ? [UIColor redColor] : UIColorOfHex(0x849EC5);
        }
    }
    
}

- (void)manageButtonClick:(UIButton *)btn {
    [super manageButtonClick:btn];
    [self maskViewWasTapped];
}

@end
