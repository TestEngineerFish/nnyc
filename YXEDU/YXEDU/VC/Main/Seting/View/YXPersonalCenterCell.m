//
//  YXPersonalCenterCell.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalCenterCell.h"
#import "BSCommon.h"

@interface YXPersonalCenterCell ()

@end

@implementation YXPersonalCenterCell

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
        
        // icon
        self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17, 26, 26)];
        self.titleImageView.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:self.titleImageView];
        
        // nameLab
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(51, 20, 150, 20)];
        self.nameLab.font = [UIFont systemFontOfSize:16];
        self.nameLab.textColor = UIColorOfHex(0x535353);
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.text = @"人教版";
        [self.contentView addSubview:self.nameLab];
        
        self.resultLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH, 20)];
        self.resultLab.font = [UIFont systemFontOfSize:16];
        self.resultLab.textColor = UIColorOfHex(0x999999);
        self.resultLab.textAlignment = NSTextAlignmentRight;
        self.resultLab.text = @"微信";
        [self.contentView addSubview:self.resultLab];
        
        self.iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconImageView];
        
        self.bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bindBtn setBackgroundImage:[UIImage imageNamed:@"personal_bind_btn"] forState:UIControlStateNormal];
        [self.bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [self.bindBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
        self.bindBtn.userInteractionEnabled = NO;
        self.bindBtn.titleLabel.textColor = [UIColor blackColor];
        self.bindBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.bindBtn];
        [self.bindBtn setFrame:CGRectMake(SCREEN_WIDTH-100, 17, 80, 26)];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(50, 60, SCREEN_WIDTH-50, 0.5)];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        self.lineView.alpha = 0.5;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)setPersonalCenterCellType:(PersonalCenterCellType)personalCenterCellType {
    _personalCenterCellType = personalCenterCellType;
    switch (_personalCenterCellType) {
        case PersonalCenterCellBindIcon: {
            self.iconImageView.frame = CGRectMake(SCREEN_WIDTH-34, 21, 18, 18);
            self.resultLab.hidden = YES;
            self.iconImageView.hidden = NO;
            self.bindBtn.hidden = YES;
        }
            break;
        case PersonalCenterCellIcon: {
            self.iconImageView.frame = CGRectMake(SCREEN_WIDTH-44, 16, 28, 28);
            self.resultLab.hidden = YES;
            self.iconImageView.hidden = NO;
            self.bindBtn.hidden = YES;
        }
            break;
        case PersonalCenterCellText: {
            self.resultLab.frame = CGRectMake(120, 20, SCREEN_WIDTH-137, 20);
            self.resultLab.hidden = NO;
            self.iconImageView.hidden = YES;
            self.bindBtn.hidden = YES;
        }
            break;
        case PersonalCenterCellTextAndIcon: {
            self.resultLab.frame = CGRectMake(130, 20, SCREEN_WIDTH-160, 20);
            self.iconImageView.frame = CGRectMake(SCREEN_WIDTH-27, 20, 10, 20);
            self.iconImageView.image = [UIImage imageNamed:@"personal_arrow"];
            self.resultLab.hidden = NO;
            self.iconImageView.hidden = NO;
            self.bindBtn.hidden = YES;
        }
            break;
        case PersonalCenterCellIconAndText: {
            self.resultLab.frame = CGRectMake(SCREEN_WIDTH-117, 20, 100, 20);
            self.iconImageView.frame = CGRectMake(SCREEN_WIDTH-81, 14.5, 25, 25);
            self.resultLab.hidden = NO;
            self.iconImageView.hidden = NO;
            self.bindBtn.hidden = YES;
        }
            break;
        case PersonalCenterCellButton: {
            self.bindBtn.hidden = NO;
            self.resultLab.hidden = YES;
            self.iconImageView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

@end
