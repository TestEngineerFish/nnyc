//
//  YXStudyResultCell.m
//  YXEDU
//
//  Created by Jake To on 11/2/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXStudyResultCell.h"

@implementation YXStudyResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.wordLabel = [[UILabel alloc] init];
        self.wordLabel.font = [UIFont systemFontOfSize:16];
        self.wordLabel.textColor = UIColorOfHex(0x60B6F8);
        
        self.phoneticLabel = [[UILabel alloc] init];
        self.phoneticLabel.textColor = UIColorOfHex(0x60B6F8);

        self.meanLabel = [[UILabel alloc] init];
        self.meanLabel.font = [UIFont systemFontOfSize:14];
        self.meanLabel.textColor = UIColorOfHex(0x888888);

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorOfHex(0xE1EBF0);
        
        [self.contentView addSubview:self.wordLabel];
        [self.contentView addSubview:self.phoneticLabel];
        [self.contentView addSubview:self.meanLabel];
        [self.contentView addSubview:lineView];
        
        self.markLabel = [[UILabel alloc] init];
        self.markLabel.font = [UIFont iconFontWithSize:20];
        [self.contentView addSubview:self.markLabel];
        
        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(12);
        }];
        
        [self.phoneticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wordLabel.mas_right).offset(16);
            make.top.equalTo(self.contentView).offset(12);
        }];
        
        [self.meanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-16);
            make.bottom.equalTo(self.contentView).offset(-16);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-16);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(self.contentView);
        }];
        
        [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-16);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}

- (void)setSwbInfo:(YXStudiedWordBrefInfo *)swbInfo {
    _swbInfo = swbInfo;
    YXWordDetailModel *wdm = self.swbInfo.wordDetailModel;
    self.wordLabel.text = wdm.word;
    self.meanLabel.text = [NSString stringWithFormat:@"%@%@",wdm.property,wdm.paraphrase];
    if (swbInfo.right) {
        self.markLabel.textColor = [UIColor greenColor];
        self.markLabel.text = kIconFont_right;
    }else {
        self.markLabel.textColor = [UIColor redColor];
        self.markLabel.text = kIconFont_close;
    }
}
@end
