//
//  YXReadHistoryCell.m
//  YXEDU
//
//  Created by jukai on 2019/5/28.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXReadHistoryCell.h"

@implementation YXReadHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-17);
            make.top.equalTo(self.contentView).offset(20.0);
            make.bottom.equalTo(self.contentView).offset(0.0);
        }];
        
        [self.lastLearnL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.bgView);
            make.top.mas_equalTo(self.contentView).offset(20.0);
            make.height.mas_equalTo(29.0);
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(28);
            make.right.equalTo(self.contentView).offset(-28);
            make.top.mas_equalTo(self.lastLearnL.mas_bottom).offset(16.0);
        }];
        
        [self.bookL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleL);
            make.top.equalTo(self.titleL.mas_bottom).offset(9.0);
        }];
        
        [self.progressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleL);
            make.top.equalTo(self.bookL.mas_bottom).offset(9.0);
        }];
        
    }
    return self;
}

- (UILabel *)titleL {
    if (!_titleL) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = UIColorOfHex(0x55A7FD);
        titleL.numberOfLines = 0;
        titleL.font = [UIFont systemFontOfSize:16.0];
        titleL.text = @"Long,long ago there lived a king";
        [self.contentView addSubview:titleL];
        _titleL = titleL;
    }
    return _titleL;
}

- (UILabel *)bookL {
    if (!_bookL) {
        UILabel *bookL = [[UILabel alloc] init];
        bookL.textColor = UIColorOfHex(0x434A5D);
        bookL.numberOfLines = 0;
        bookL.font = [UIFont systemFontOfSize:13.0];
        bookL.text = @"from：G9 - U1 - Section A，人教版";
        [self.contentView addSubview:bookL];
        _bookL = bookL;
    }
    return _bookL;
}

- (UILabel *)progressL {
    if (!_progressL) {
        UILabel *progressL = [[UILabel alloc] init];
        progressL.textColor = UIColorOfHex(0x8095AB);
        progressL.numberOfLines = 0;
        progressL.font = [UIFont systemFontOfSize:14.0];
        progressL.text = @"已经跟读：40% ";
        [self.contentView addSubview:progressL];
        _progressL = progressL;
    }
    return _progressL;
}

- (UILabel *)lastLearnL {
    if (!_lastLearnL) {
        UILabel *lastLearnL = [[UILabel alloc] init];
        lastLearnL.textColor = UIColorOfHex(0x8095AB);
        [lastLearnL setBackgroundColor:UIColorOfHex(0xEEF7FF)];
        [lastLearnL setTextAlignment:NSTextAlignmentLeft];
        lastLearnL.numberOfLines = 0;
        lastLearnL.font = [UIFont systemFontOfSize:13.0];
        lastLearnL.text = @"  上次学习时间:";
        [self.contentView addSubview:lastLearnL];
        _lastLearnL = lastLearnL;
    }
    return _lastLearnL;
}



- (UIImageView *)bgView {
    if (!_bgView) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [bgView.layer setMasksToBounds:YES];
        [bgView.layer setCornerRadius:1];
        [bgView.layer setBorderWidth:1];
        [bgView.layer setBorderColor:UIColorOfHex(0xE9EFF4).CGColor];
        [self.contentView addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}



@end
