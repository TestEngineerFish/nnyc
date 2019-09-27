//
//  YXMyWordDetailCell.m
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordDetailCell.h"

@interface YXMyWordDetailCell ()
@property (nonatomic, weak) UIView *seprateLine;
@property (nonatomic, weak) UIImageView *penIcon;
@property (nonatomic, weak) UIImageView *headphoneIcon;
@end
@implementation YXMyWordDetailCell
- (void)setUpSubviews {
    [super setUpSubviews];
    [self.seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
    }];
    
    UIImageView *headphoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headphoneIcon_def"]];
    [self.contentView addSubview:headphoneIcon];
    _headphoneIcon = headphoneIcon;
    CGFloat length = AdaptSize(15);
    [headphoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-AdaptSize(18));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(length, length));
    }];
    
    UIImageView *penIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"penIcon_def"]];
    [self.contentView addSubview:penIcon];
    _penIcon = penIcon;
    [penIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headphoneIcon.mas_left).offset(-AdaptSize(25));
        make.centerY.equalTo(headphoneIcon);
        make.size.equalTo(headphoneIcon);
    }];
    
    
    [self.wordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(AdaptSize(11));
        make.width.mas_equalTo(AdaptSize(100));
    }];
    
    CGFloat minMargin = AdaptSize(5);
    [self.explanationL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wordL.mas_right).offset(minMargin);
        make.centerY.equalTo(self.wordL);
        make.right.equalTo(penIcon.mas_left).offset(- minMargin);
    }];
}

- (UIView *)seprateLine {
    if (!_seprateLine) {
        UIView *seprateLine = [[UIView alloc] init];
        seprateLine.backgroundColor = UIColorOfHex(0xEAF4FC);
        [self.contentView addSubview:seprateLine];
        _seprateLine = seprateLine;
    }
    return _seprateLine;
}

- (void)setWordModel:(YXMyWordCellBaseModel *)wordModel {
    [super setWordModel:wordModel];
    if ([wordModel isKindOfClass:[YXMyWordListCellModel class]]) {
        YXMyWordListCellModel *model = (YXMyWordListCellModel *)wordModel;
        NSString *name = (model.learnState == 3) ? @"penIcon_doing" : @"penIcon_def" ;
        self.penIcon.image = [UIImage imageNamed:name];
        
        name = (model.listenState == 3) ? @"headphoneIcon_doing" : @"headphoneIcon_def" ;
        self.headphoneIcon.image = [UIImage imageNamed:name];
    }
}
@end
