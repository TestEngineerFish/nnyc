//
//  YXASBookCell.m
//  YXEDU
//
//  Created by jukai on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXASBookCell.h"

@implementation YXASBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 6;
        
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOpacity = 0.32;
//        self.layer.shadowOffset = CGSizeMake(0, 2);
//        self.layer.shadowColor = UIColorOfHex(0xD8E1E9).CGColor;
        
        CGFloat leftMargin = iPhone5 ? 10 : 20;
        self.bookImageView = [[UIImageView alloc]init];
        self.bookImageView.layer.cornerRadius = 2;
        self.bookImageView.layer.shadowRadius = 2;
        self.bookImageView.layer.shadowOpacity = 0.6;
        //        [self.bookImageView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
        self.bookImageView.layer.shadowOffset = CGSizeMake(2, 2);
        self.bookImageView.layer.shadowColor = UIColorOfHex(0x8DADD7).CGColor;
        [self.contentView addSubview:self.bookImageView];
        [self.bookImageView setImage:[UIImage imageNamed:@"placeholder"]];
        
        [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(leftMargin);
            make.top.equalTo(self.contentView).offset(16);
            make.size.mas_equalTo(CGSizeMake(76, 96));
        }];

        self.studyFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"studyFlag"]];
        [self.studyFlag setHidden:YES];
        [self.bookImageView addSubview:self.studyFlag];
        [self.studyFlag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(45, 50));
            make.right.and.top.equalTo(self.bookImageView);
        }];
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.font = [UIFont boldSystemFontOfSize:16];
        self.titleLab.textColor = UIColorOfHex(0x434A5D);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.text = @"书名称";
        [self.contentView addSubview:self.titleLab];
        CGFloat titleLeftMargin = iPhone5 ? 10 : 20;
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bookImageView.mas_right).offset(titleLeftMargin);
            make.top.equalTo(self.contentView).offset(32);
        }];
        
        self.totalArticleLab = [[UILabel alloc]init];
        self.totalArticleLab.font = [UIFont systemFontOfSize:13];
        self.totalArticleLab.textColor = UIColorOfHex(0x8095AB);
        self.totalArticleLab.textAlignment = NSTextAlignmentLeft;
        self.totalArticleLab.text = @"共18篇课文";
        [self.contentView addSubview:self.totalArticleLab];
        [self.totalArticleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab);
            make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        }];
    }
    return self;
}


@end
