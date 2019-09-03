//
//  YXAboutComCell.m
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXAboutComCell.h"
#import "BSCommon.h"

@interface YXAboutComCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YXAboutComCell

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
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 20)];
        self.titleLab.text = @"念念有词";
        self.titleLab.textColor = UIColorOfHex(0x535353);
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLab];
        if (iPhone6P) {
            self.titleLab.font = [UIFont systemFontOfSize:16];
        }
        
        self.iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.frame = CGRectMake(SCREEN_WIDTH-27, 20, 10, 20);
        self.iconImageView.image = [UIImage imageNamed:@"personal_arrow"];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.5)];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        self.lineView.alpha = 0.5;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

@end
