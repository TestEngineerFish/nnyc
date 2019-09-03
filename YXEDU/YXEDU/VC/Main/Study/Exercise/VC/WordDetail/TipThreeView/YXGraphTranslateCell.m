//
//  YXGraphTranslateCell.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphTranslateCell.h"
#import "BSCommon.h"
#import "NSString+YR.h"


@interface YXGraphTranslateCell ()

@end

@implementation YXGraphTranslateCell

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
        
        self.translateLab = [[UILabel alloc]initWithFrame:CGRectMake(32.5f, 24, SCREEN_WIDTH-97, 40)];
        self.translateLab.font = [UIFont systemFontOfSize:16];
        self.translateLab.textColor = UIColorOfHex(0x333333);
        self.translateLab.textAlignment = NSTextAlignmentLeft;
        self.translateLab.lineBreakMode = NSLineBreakByWordWrapping;
        self.translateLab.text = @"n.一种交通工具;\nvi.沉船\nvt.用船运输;";
        self.translateLab.numberOfLines = 0;
        [self.contentView addSubview:self.translateLab];
        
    }
    return self;
}



@end
