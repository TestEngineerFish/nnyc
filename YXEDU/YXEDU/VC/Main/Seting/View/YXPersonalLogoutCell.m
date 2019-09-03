//
//  YXPersonalLogoutCell.m
//  YXEDU
//
//  Created by shiji on 2018/6/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalLogoutCell.h"
#import "BSCommon.h"

@interface YXPersonalLogoutCell ()
@property (nonatomic, strong) UILabel *nameLab;
@end

@implementation YXPersonalLogoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColorOfHex(0xffffff);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // nameLab
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        self.nameLab.font = [UIFont systemFontOfSize:16];
        self.nameLab.textColor = UIColorOfHex(0x535353);
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.text = @"退出登录";
        [self.contentView addSubview:self.nameLab];
    }
    return self;
}


@end
