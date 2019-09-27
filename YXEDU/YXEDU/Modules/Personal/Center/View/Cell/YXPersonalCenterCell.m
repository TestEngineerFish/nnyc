//
//  YXPersonalCenterCell.m
//  YXEDU
//
//  Created by Jake To on 10/13/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXPersonalCenterCell.h"
#import "BSCommon.h"

@implementation YXPersonalCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.accessoryImage = [[UIImageView alloc] init];
        self.accessoryImage.tintColor = UIColorOfHex(0x849EC5);
        self.accessoryImage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.titleLabel = [[UILabel alloc] init];
        self.rightDetailLabel = [[UILabel alloc] init];
        self.lineView = [[UIView alloc] init];
        
        self.titleLabel.textColor = UIColorOfHex(0x485461);
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.rightDetailLabel.textColor = UIColorOfHex(0x849EC5);
        self.rightDetailLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.accessoryImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightDetailLabel];
        [self.contentView addSubview:self.lineView];
        
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(16);
        }];
        
        [self.accessoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(12);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-16);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.iconImage.mas_right).offset(16);
        }];
        
        [self.rightDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.accessoryImage).offset(-16);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setModel:(YXPersonalCenterCellModel *)model {
    _model = model;
    self.iconImage.image = [UIImage imageNamed:model.imageName];
    self.titleLabel.text = model.title;
    self.rightDetailLabel.text = model.rightDetail;
    
    if (model.isShowAccessory) {
        self.accessoryImage.image = [UIImage imageNamed:@"圆角矩形"];
    }
    
    if (model.isShowBottomLine) {
        self.lineView.backgroundColor = UIColorOfHex(0xEAF4FC);
    } else {
        self.lineView.backgroundColor = [UIColor whiteColor];
    }
}

@end
