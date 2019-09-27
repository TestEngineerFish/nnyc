//
//  YXSelectBookCell.m
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSelectBookCell.h"
@interface YXSelectBookCell ()
@property (nonatomic, weak)UIView *iconBG;
@end
@implementation YXSelectBookCell
{
    UIImageView *_bookIcon;
    UIView *_bookContent;
    UILabel *_bookNameL;
    UILabel *_totolWordL;
    UILabel *_studyStatusL;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorOfHex(0xF3F8FB);//[UIColor mRGBColor:241 :247 :250];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    UIView *bookContent = [[UIView alloc] init];
    bookContent.layer.cornerRadius = 6;
    bookContent.layer.shadowRadius = 5;
    bookContent.layer.shadowOpacity = 0.7;
    bookContent.layer.shadowOffset = CGSizeMake(0, 3);
    bookContent.layer.shadowColor = UIColorOfHex(0xD8E1E9).CGColor;
    bookContent.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bookContent];
    _bookContent = bookContent;
    
    CGFloat iconWidth = iPhone5 ? 85 : 100;
    
    [self.bookIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(iconWidth,1.25 * iconWidth));//
    }];
//    [self bookIcon];
    CGFloat contentHeight = iPhone5 ? 80 : 96;
    [bookContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookIcon).offset(20);
        make.centerY.equalTo(self.bookIcon);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(contentHeight);
    }];
    
    CGFloat fonSize = iPhone5 ? 14 : 16;
    UILabel *bookNameL = [[UILabel alloc] init];
    bookNameL.text = @"";
    bookNameL.textColor = [UIColor mainTitleColor];
    bookNameL.font = [UIFont boldSystemFontOfSize:fonSize];
    [bookContent addSubview:bookNameL];
    _bookNameL = bookNameL;
    
    CGFloat tbMargin = iPhone5 ? 20 : 25;
    CGFloat lrMargin =   10;
    [bookNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bookContent).offset(tbMargin);
        make.left.equalTo(self.bookIcon.mas_right).offset(lrMargin);
    }];
    
    UILabel *totolWordL = [[UILabel alloc] init];
//    totolWordL.text = @"总词汇：808";
    totolWordL.textColor = [UIColor secondTitleColor];
    totolWordL.font = [UIFont systemFontOfSize:fonSize - 2];
    [bookContent addSubview:totolWordL];
    _totolWordL = totolWordL;
    
    [totolWordL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bookContent).offset(-tbMargin);
        make.left.equalTo(bookNameL);
    }];
    
    UILabel *studyStatusL = [[UILabel alloc] init];
    studyStatusL.text = @"正在学习";
    studyStatusL.textColor = [UIColor secondTitleColor];
    studyStatusL.font = [UIFont systemFontOfSize:fonSize-2];
    [bookContent addSubview:studyStatusL];
    _studyStatusL = studyStatusL;
    
    [studyStatusL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bookContent).offset(-lrMargin -5);
        make.centerY.equalTo(bookNameL);
    }];

    UIImageView *selImageView = [[UIImageView alloc] init];
    selImageView.image = [UIImage imageNamed:@"selectedBookSuccess"];
    selImageView.hidden = YES;
    [bookContent addSubview:selImageView];
    _selImageView = selImageView;
    [selImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(studyStatusL);
        make.bottom.equalTo(bookContent).offset(-10);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}

- (UIImageView *)bookIcon {
    if (!_bookIcon) {
        UIImageView *bookIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:bookIcon];
        bookIcon.layer.cornerRadius = iPhone5 ? 3 : 5;
        bookIcon.layer.shadowRadius = 5;
        bookIcon.layer.shadowOpacity = 0.6;
        bookIcon.layer.shadowOffset = CGSizeMake(2, 2);
        bookIcon.layer.shadowColor = UIColorOfHex(0x8DADD7).CGColor;//[UIColor redColor].CGColor;
        _bookIcon = bookIcon;
    }
    return _bookIcon;
}


@end
