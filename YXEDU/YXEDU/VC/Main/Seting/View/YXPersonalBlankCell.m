//
//  YXPersonalBlankCell.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalBlankCell.h"
#import "BSCommon.h"

@implementation YXPersonalBlankCell

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
        self.backgroundColor = UIColorOfHex(0xF6F6F6);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}



@end
