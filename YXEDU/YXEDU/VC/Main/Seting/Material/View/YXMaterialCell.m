//
//  YXMaterialCell.m
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMaterialCell.h"
#import "BSCommon.h"

@interface YXMaterialCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *delBtn;
@end

@implementation YXMaterialCell

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
        
        // nameLab
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-130, 20)];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = UIColorOfHex(0x535353);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.text = @"人教版7年级上第1单元";
        [self.contentView addSubview:self.titleLab];
        
        self.resultLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 60, 20)];
        self.resultLab.font = [UIFont systemFontOfSize:14];
        self.resultLab.textColor = UIColorOfHex(0xBCBCBC);
        self.resultLab.textAlignment = NSTextAlignmentLeft;
        self.resultLab.text = @"50.00M";
        [self.contentView addSubview:self.resultLab];
        
        self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delBtn setImage:[UIImage imageNamed:@"personal_material_delete"] forState:UIControlStateNormal];
        [self.delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.delBtn];
        [self.delBtn setFrame:CGRectMake(SCREEN_WIDTH-50, 10, 40, 40)];
        [self.delBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.5)];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        self.lineView.alpha = 0.5;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)delBtnClicked:(id)sender {
    self.delBlock(self);
}

@end
