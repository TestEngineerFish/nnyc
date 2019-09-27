//
//  YXGraphIllustationCell.m
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGraphIllustationCell.h"
#import "BSCommon.h"
#import "NSString+YR.h"

@interface YXGraphIllustationCell ()


@end

@implementation YXGraphIllustationCell

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
        
        self.exampleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(32.5, 7, 160, 160)];
        self.exampleImageView.image = [UIImage imageNamed:@"study_speak"];
        [self.contentView addSubview:self.exampleImageView];
        self.exampleImageView.layer.borderColor = UIColorOfHex(0xDCDCDC).CGColor;
        self.exampleImageView.layer.borderWidth = 1.5f;
        self.exampleImageView.layer.cornerRadius = 8.0f;
        self.exampleImageView.clipsToBounds = YES;
    }
    return self;
}





@end
