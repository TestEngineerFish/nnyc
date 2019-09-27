//
//  YXMaterialCell.m
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalMaterialCell.h"
#import "BSCommon.h"

@interface YXPersonalMaterialCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation YXPersonalMaterialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.textColor = UIColorOfHex(0x485461);
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        
        self.sizeLabel = [[UILabel alloc] init];
        self.sizeLabel.textColor = UIColorOfHex(0x849EC5);
        self.sizeLabel.textAlignment = NSTextAlignmentRight;
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.deleteButton setFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 40, 40)];
//        [self.deleteButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorOfHex(0xEAF4FC);
        
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.sizeLabel];
        [self.contentView addSubview:self.deleteButton];
        [self.contentView addSubview:self.lineView];
        
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(44);
            make.right.equalTo(self.contentView);
        }];
        
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.deleteButton.mas_left);
        }];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.sizeLabel.mas_left).offset(-8);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
            make.right.left.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)delBtnClicked:(id)sender {
    self.deleteBlock(self);
}

@end
