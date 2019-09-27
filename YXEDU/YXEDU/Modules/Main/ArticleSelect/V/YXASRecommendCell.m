//
//  YXASRecommendCell.m
//  YXEDU
//
//  Created by jukai on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXASRecommendCell.h"

@implementation YXASRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17.0);
            make.right.equalTo(self.contentView).offset(-17.0);
            make.top.equalTo(self.contentView).offset(0.0);
            make.bottom.equalTo(self.contentView).offset(-18.0);
        }];
        
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(40);
            make.right.equalTo(self.contentView).offset(-40);
            make.top.equalTo(self.contentView).offset(15.0);
        }];
        
        [self.bookL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleL);
            make.top.equalTo(self.titleL.mas_bottom).offset(12.0);
        }];
        
        [self.progressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleL);
            make.top.equalTo(self.bookL.mas_bottom).offset(12.0);
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
