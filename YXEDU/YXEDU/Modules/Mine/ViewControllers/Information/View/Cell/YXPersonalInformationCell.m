//
//  YXPersonalInformationCell.m
//  YXEDU
//
//  Created by Jake To on 10/12/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXPersonalInformationCell.h"
#import "BSCommon.h"

@implementation YXPersonalInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = UIColorOfHex(0x8095AB);

        self.rightDetailLabel = [[UILabel alloc] init];
        self.rightDetailLabel.font = [UIFont systemFontOfSize:15];
        if ([self.rightDetailLabel.text isEqual: @"未设置"]) {
            self.rightDetailLabel.textColor = UIColorOfHex(0x8095AB);
        } else {
            self.rightDetailLabel.textColor = UIColorOfHex(0x485461);
        }

        self.accessoryImage = [[UIImageView alloc] init];
        self.accessoryImage.tintColor = UIColorOfHex(0xCCCCCC);
        self.accessoryImage.contentMode = UIViewContentModeScaleAspectFit;

        self.lineView = [[UIView alloc] init];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rightDetailLabel];
        [self.contentView addSubview:self.accessoryImage];
        [self.contentView addSubview:self.lineView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        [self.rightDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.accessoryImage).offset(-16);
        }];

        [self.accessoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(12);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-16);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-16);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setModel:(YXPersonalInformationModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.rightDetailLabel.text = model.rightDetail;
    
    if (model.isShowAccessory) {
        self.accessoryImage.image = [UIImage imageNamed:@"圆角矩形"];
    }
    
    if (model.isShowBottomLine) {
        self.lineView.backgroundColor = UIColorOfHex(0xEAF4FC);
    }
    
    if ([self.rightDetailLabel.text isEqual: @"未设置"]) {
        self.rightDetailLabel.textColor = UIColorOfHex(0x8095AB);
    } else {
        self.rightDetailLabel.textColor = UIColorOfHex(0x485461);
    }
}

@end
