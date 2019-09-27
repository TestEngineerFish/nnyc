//
//  YXIndicatorTableView.m
//  YXEDU
//
//  Created by yao on 2019/2/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXIndicatorTableView.h"
static NSString * const kIndicatorTableViewCelID = @"IndicatorTableViewCelID";
@interface YXIndicatorTableViewCell ()
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation YXIndicatorTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *indicatorView = [[UIView alloc] init];
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(5);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.indicatorView.mas_right).offset(15);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.adjustsFontSizeToFitWidth=YES;
        titleLabel.text = @"人教版七年级上册";
        titleLabel.textColor = UIColorOfHex(0x485461);
        titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(15)];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
@end

@implementation YXIndicatorTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.rowHeight = AdaptSize(40);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[YXIndicatorTableViewCell class] forCellReuseIdentifier:kIndicatorTableViewCelID];
    }
    return self;
}

- (YXIndicatorTableViewCell *)dequeueReusableIndicatorCellforIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:kIndicatorTableViewCelID forIndexPath:indexPath];
}
@end
