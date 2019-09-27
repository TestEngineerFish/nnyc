//
//  YXComNaviView.m
//  YXEDU
//
//  Created by yao on 2018/10/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXComNaviView.h"

@implementation YXComNaviView
{
    UIButton *_leftButton;
    UIButton *_rightButton;
    UILabel *_titleLabel;
}

+ (instancetype)comNaviViewWithLeftButtonType:(YXNaviviewLeftButtonType)leftButtonType {
    return [[self alloc] initWithLeftButtonType:leftButtonType];
}

- (instancetype)initWithLeftButtonType:(YXNaviviewLeftButtonType)leftButtonType {
    if (self = [super init]) {
        [self setLeftButtonImage:leftButtonType];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self titleLabel];
        [self leftButton];
    }
    return self;
}

- (void)setLeftButtonImage:(YXNaviviewLeftButtonType)leftButtonType {
    if (leftButtonType == YXNaviviewLeftButtonWhite) {
        [self.leftButton setImage:[UIImage imageNamed:@"comNaviBack_white_normal"] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"comNaviBack_white_press"] forState:UIControlStateHighlighted];
    }else {
        [self.leftButton setImage:[UIImage imageNamed:@"comNaviBack_gray_normal"] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"comNaviBack_gray_press"] forState:UIControlStateHighlighted];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setRightButtonItem:(UIBarButtonItem *)rightButtonItem {
    _rightButtonItem = rightButtonItem;
    if (rightButtonItem) {
        self.rightButton.hidden = NO;
        [self.rightButton setImage:rightButtonItem.image forState:UIControlStateNormal];
        [self.rightButton addTarget:rightButtonItem.target action:rightButtonItem.action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setLeftButtonItem:(UIBarButtonItem *)leftButtonItem {
    _leftButtonItem = leftButtonItem;
    if (leftButtonItem) {
        self.leftButton.hidden = NO;
        [self.leftButton setImage:leftButtonItem.image forState:UIControlStateNormal];
        [self.leftButton setImage:leftButtonItem.image forState:UIControlStateHighlighted];
        [self.leftButton addTarget:leftButtonItem.target action:leftButtonItem.action forControlEvents:UIControlEventTouchUpInside];
        self.leftButton.imageEdgeInsets = UIEdgeInsetsZero;
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat top = kStatusBarHeight + 1;
    self.leftButton.frame = CGRectMake(0,top , 60, 40);
    
    if (self.arrowIcon) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).with.offset(-5);
            make.centerY.mas_equalTo(self.leftButton);
        }];
        [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(5);
            make.centerY.equalTo(self.titleLabel);
            make.size.mas_equalTo(CGSizeMake(13, 7));
        }];
        UITapGestureRecognizer *tapArrow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleView)];
        UITapGestureRecognizer *tapTitleLabel= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleView)];
        [self.titleLabel setUserInteractionEnabled: YES];
        [self.arrowIcon setUserInteractionEnabled: YES];
        [self.titleLabel addGestureRecognizer:tapTitleLabel];
        [self.arrowIcon addGestureRecognizer:tapArrow];
    } else {
        self.titleLabel.frame = CGRectMake((SCREEN_WIDTH - 200) * 0.5, top, 200, 40);
    }
    
    if (self.rightButton) {
        self.rightButton.frame = CGRectMake(SCREEN_WIDTH - 60,top, 60, 40);
    }
}

- (void)setArrowIcon:(UIImageView *)arrowIcon {
    if (!_arrowIcon) {
        [self addSubview:arrowIcon];
    }
    _arrowIcon = arrowIcon;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        UIButton *leftButton = [[UIButton alloc] init];
        [leftButton setImage:[UIImage imageNamed:@"comNaviBack_white_normal"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"comNaviBack_white_press"] forState:UIControlStateHighlighted];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [self addSubview:leftButton];
        _leftButton = leftButton;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        UIButton *rightButton = [[UIButton alloc] init];
//        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        rightButton.hidden = YES;
        [self addSubview:rightButton];
        _rightButton = rightButton;
    }
    return _rightButton;
}

- (void)setRightButtonNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightlightImage {
    [self.rightButton setImage:normalImage forState:UIControlStateNormal];
    [self.rightButton setImage:hightlightImage forState:UIControlStateHighlighted];
    self.rightButton.hidden = NO;
}

- (void)setRightButtonView:(UIView *)customView {
    self.rightButton.hidden = YES;
    [self addSubview:customView];
}

- (void)setLeftButtonNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightlightImage {
    [self.leftButton setImage:normalImage forState:UIControlStateNormal];
    [self.leftButton setImage:hightlightImage forState:UIControlStateHighlighted];
    self.leftButton.hidden = NO;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = UIColorOfHex(0x485461);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:19];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)clickTitleView {
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end
