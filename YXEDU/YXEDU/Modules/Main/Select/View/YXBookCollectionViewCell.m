//
//  YXBookCollectionViewCell.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookCollectionViewCell.h"

@interface YXBookCollectionViewCell ()
@property (nonatomic, strong) UIImageView *bookIcon;
@property (nonatomic, strong) UIView *bookContent;
@property (nonatomic, strong) UILabel *bookNameL;
@property (nonatomic, strong) UILabel *totolWordL;
@property (nonatomic, strong) UILabel *studyStatusL;
@property (nonatomic, weak) UIImageView *selImageView;
@property (nonatomic, weak) UIImageView *studyStatusIcon;
@property (nonatomic, weak) UIImageView *maskImageView;
@property (nonatomic, weak)UIView *bottomView;
@end

@implementation YXBookCollectionViewCell
{
    UIImageView *_bookIcon;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setUpsubViews];
    }
    return self;
}

- (void)setBookModel:(YXBookInfoModel *)bookModel {
    _bookModel = bookModel;
    self.bookNameL.text = bookModel.bookName;
    self.totolWordL.text = [NSString stringWithFormat:@"总词汇：%@",bookModel.wordCount];
    [self.bookIcon sd_setImageWithURL:[NSURL URLWithString:bookModel.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.studyStatusIcon.hidden = !bookModel.isLearning;
    self.studyStatusL.text = [NSString stringWithFormat: @"%@人学习中",bookModel.totalLearning];
}

- (void)selectedSuccessed:(BOOL)isSuccess {
    self.selImageView.hidden = !isSuccess;
}

#pragma mark - subViews
- (void)setUpsubViews {
    [self bookIcon];
    [self studyStatusIcon];
    [self selImageView];
    [self maskImageView];
    [self studyStatusL];
    [self bookNameL];
    [self totolWordL];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.bookIcon addSubview:bottomView];
    self.bottomView = bottomView;
    [self.bottomView addSubview:self.maskImageView];
    [self.maskImageView addSubview:self.studyStatusL];
    self.bottomView.layer.cornerRadius = self.bookIcon.layer.cornerRadius;
    self.bottomView.layer.masksToBounds = YES;
    
    if (iPhone5) {
        CGFloat fontSize = 10;
        self.studyStatusL.font = [UIFont systemFontOfSize:fontSize];
        self.bookNameL.font = self.studyStatusL.font;//[UIFont systemFontOfSize:fontSize];
        self.totolWordL.font = [UIFont systemFontOfSize:fontSize - 1];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.bookIcon.frame = CGRectMake(0, 0, size.width, size.width * kYXBookIconHWScale);
    
    CGFloat ssIconWidth = iPhone5 ? 40 : 45;
    self.studyStatusIcon.frame = CGRectMake(size.width - ssIconWidth, 0, ssIconWidth, 1.1 * ssIconWidth);
    
    CGFloat selMarkWH = iPhone5 ? 25 : 30;
    self.selImageView.frame = CGRectMake(0, 0, selMarkWH, selMarkWH);
    self.selImageView.center = self.bookIcon.center;
    
    self.bottomView.frame = CGRectMake(0, self.bookIcon.height - 50, size.width, 50);
    self.maskImageView.frame = CGRectMake(0, self.bottomView.height - 36, size.width, 36);
    self.studyStatusL.frame = CGRectMake(10, 12, size.width - 16, 18);
    self.bookNameL.frame = CGRectMake(0, self.bookIcon.height + 15, size.width, 12);
    self.totolWordL.frame = CGRectMake(0, self.bookNameL.bottom + 6, size.width, 11);
}

- (UIImageView *)bookIcon {
    if (!_bookIcon) {
        UIImageView *bookIcon = [[UIImageView alloc] init];
//        bookIcon.image = [UIImage imageNamed:@"placeholder"];
        [self.contentView addSubview:bookIcon];
        bookIcon.layer.cornerRadius = iPhone5 ? 3 : 5;
        bookIcon.layer.shadowRadius = 2;
        bookIcon.layer.shadowOpacity = 0.6;
        bookIcon.layer.shadowOffset = CGSizeMake(2, 2);
        bookIcon.layer.shadowColor = UIColorOfHex(0x8DADD7).CGColor;//[UIColor redColor].CGColor;
        _bookIcon = bookIcon;
    }
    return _bookIcon;
}

- (UILabel *)bookNameL {
    if (!_bookNameL) {
        UILabel *bookNameL = [[UILabel alloc] init];
        bookNameL.text = @"";
        bookNameL.textColor = [UIColor mainTitleColor];
        bookNameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:bookNameL];
        _bookNameL = bookNameL;
    }
    return _bookNameL;
}

- (UILabel *)totolWordL {
    if (!_totolWordL) {
        UILabel *totolWordL = [[UILabel alloc] init];
        totolWordL.text = @"总词汇：808";
        totolWordL.textColor = [UIColor secondTitleColor];
        totolWordL.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:totolWordL];
        _totolWordL = totolWordL;
    }
    return _totolWordL;
}


- (UIImageView *)selImageView {
    if (!_selImageView) {
        UIImageView *selImageView = [[UIImageView alloc] init];
        selImageView.hidden = YES;
        selImageView.image = [UIImage imageNamed:@"bookSelectedMark"];
        [self.contentView addSubview:selImageView];
        _selImageView = selImageView;
    }
    return _selImageView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        UIImageView *maskImageView = [[UIImageView alloc] init];
//        maskImageView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeBottom |
//        maskImageView.alpha = 0.6;
//        maskImageView.layer.cornerRadius = self.bookIcon.layer.cornerRadius;
//        maskImageView.layer.masksToBounds = YES;
        maskImageView.image = [UIImage imageNamed:@"studyCountMaskImage"];
        [self.bookIcon addSubview:maskImageView];
        _maskImageView = maskImageView;
    }
    return _maskImageView;
}


- (UIImageView *)studyStatusIcon {
    if (!_studyStatusIcon) {
        UIImageView *studyStatusIcon = [[UIImageView alloc] init];
        studyStatusIcon.hidden = YES;
        studyStatusIcon.image = [UIImage imageNamed:@"studyStatusImage"];
        [self.bookIcon addSubview:studyStatusIcon];
        _studyStatusIcon = studyStatusIcon;
    }
    return _studyStatusIcon;
}

- (UILabel *)studyStatusL {
    if (!_studyStatusL) {
        UILabel *studyStatusL = [[UILabel alloc] init];
//        studyStatusL.text = @"2385人学习中";
        studyStatusL.textColor = [UIColor whiteColor];
        studyStatusL.font = [UIFont systemFontOfSize:12];
        [self.bookIcon addSubview:studyStatusL];
        _studyStatusL = studyStatusL;
    }
    return _studyStatusL;
}
@end
