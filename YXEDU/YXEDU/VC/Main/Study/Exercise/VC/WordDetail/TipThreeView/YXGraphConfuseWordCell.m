//
//  YXGraphConfuseWordCell.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphConfuseWordCell.h"
#import "BSCommon.h"
#import "NSString+YR.h"
#import "YXCommHeader.h"

@interface YXGraphConfuseWordCell ()
@property (nonatomic, strong) UILabel *titleLab;


@end

@implementation YXGraphConfuseWordCell

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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, 25, 54, 24)];
        self.titleLab.font = [UIFont systemFontOfSize:12];
        self.titleLab.textColor = UIColorOfHex(0xffffff);
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.text = @"近义词";
        self.titleLab.clipsToBounds = YES;
        self.titleLab.layer.cornerRadius = 12.0f;
        self.titleLab.backgroundColor = UIColorOfHex(0xBBBBBB);
        [self.contentView addSubview:self.titleLab];
        
        self.sentenceLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, CGRectGetMaxY(self.titleLab.frame)+8, SCREEN_WIDTH-97, 22)];
        self.sentenceLab.font = [UIFont systemFontOfSize:16];
        self.sentenceLab.textColor = UIColorOfHex(0x1CB0F6);
        self.sentenceLab.textAlignment = NSTextAlignmentLeft;
        self.sentenceLab.text = @"coffee  boat  love";
        [self.contentView addSubview:self.sentenceLab];
        
    }
    return self;
}

@end
