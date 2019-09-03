//
//  YXSelectBookCell.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSelectBookCell.h"
#import "BSCommon.h"

@implementation YXSelectBookCell

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
        
        self.resultLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 53, 50, 20)];
        self.resultLab.font = [UIFont systemFontOfSize:12];
        self.resultLab.textColor = UIColorOfHex(0xBCBCBC);
        self.resultLab.textAlignment = NSTextAlignmentRight;
        self.resultLab.text = @"正在学习";
        [self.contentView addSubview:self.resultLab];
        
        self.selectIconImageView = [[UIImageView alloc]init];
        self.selectIconImageView.frame = CGRectMake(SCREEN_WIDTH-50, 39, 22, 22);
        self.selectIconImageView.image = [UIImage imageNamed:@"select_book_right"];
        [self.contentView addSubview:self.selectIconImageView];
        self.selectIconImageView.hidden = YES;
    }
    return self;
}

@end
