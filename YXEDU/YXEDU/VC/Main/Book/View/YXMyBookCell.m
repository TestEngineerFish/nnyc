//
//  YXStudyingBookCell.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMyBookCell.h"
#import "BSCommon.h"

@interface YXMyBookCell ()


@end

@implementation YXMyBookCell

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
        
        self.bookImageView = [[UIImageView alloc]init];
        self.bookImageView.backgroundColor = UIColorOfHex(0xF97E73);
        self.bookImageView.frame = CGRectMake(28, 10, 80, 106);
        [self.contentView addSubview:self.bookImageView];
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.bookImageView.frame)+20, 10, 200, 22);
        self.titleLab.font = [UIFont boldSystemFontOfSize:16];
        self.titleLab.textColor = UIColorOfHex(0x535353);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.text = @"我是词书名称";
        [self.contentView addSubview:self.titleLab];
        
        self.totalVocabularyLab = [[UILabel alloc]init];
        self.totalVocabularyLab.frame = CGRectMake(CGRectGetMaxX(self.bookImageView.frame)+20, CGRectGetMaxY(self.titleLab.frame)+15, 80, 20);
        self.totalVocabularyLab.font = [UIFont systemFontOfSize:12];
        self.totalVocabularyLab.textColor = UIColorOfHex(0x999999);
        self.totalVocabularyLab.textAlignment = NSTextAlignmentLeft;
        self.totalVocabularyLab.text = @"总词汇:250";
        [self.contentView addSubview:self.totalVocabularyLab];
        
        self.haveLearnedLab = [[UILabel alloc]initWithFrame:CGRectMake(225, 54, 60, 54)];
        self.haveLearnedLab.frame = CGRectMake(CGRectGetMaxX(self.totalVocabularyLab.frame)+10, CGRectGetMaxY(self.titleLab.frame)+15, 80, 20);
        self.haveLearnedLab.font = [UIFont systemFontOfSize:12];
        self.haveLearnedLab.textColor = UIColorOfHex(0x999999);
        self.haveLearnedLab.textAlignment = NSTextAlignmentLeft;
        self.haveLearnedLab.text = @"已学词汇：233";
        [self.contentView addSubview:self.haveLearnedLab];
        
        self.manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.manageBtn setFrame:CGRectMake(CGRectGetMaxX(self.bookImageView.frame)+20, CGRectGetMaxY(self.totalVocabularyLab.frame)+22, 84, 28)];
        [self.manageBtn setTitle:@"换本书背" forState:UIControlStateNormal];
        [self.manageBtn setBackgroundImage:[UIImage imageNamed:@"personal_manage_btn"] forState:UIControlStateNormal];
        [self.manageBtn setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
        [self.manageBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.manageBtn addTarget:self action:@selector(manageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.manageBtn.layer.cornerRadius = 14.0f;
        [self.contentView addSubview:self.manageBtn];
    }
    return self;
}

- (void)manageBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(manageBtnDidClicked:)]) {
        [self.delegate manageBtnDidClicked:self];
    }
}



@end
