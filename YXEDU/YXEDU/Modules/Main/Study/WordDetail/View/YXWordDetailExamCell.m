//
//  YXWordDetailExamCell.m
//  YXEDU
//
//  Created by jukai on 2019/5/14.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXWordDetailExamCell.h"

@implementation YXWordDetailExamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-17);
            make.top.equalTo(self.contentView).offset(12);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(11.5);
            make.top.equalTo(self.bgView).offset(18.0);
            make.right.equalTo(self.bgView).offset(-11.0);
        }];
        
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(8.0);
            make.left.equalTo(self.titleL);
            make.right.equalTo(self.titleL);
        }];
        
        [self.freL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView).offset(-12.5);
            make.left.equalTo(self.titleL);
            make.right.equalTo(self.titleL);
        }];
        
        [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView).offset(-12.0);
            make.right.equalTo(self.bgView).offset(-12.0);
            make.width.mas_equalTo(60.0);
        }];
    }
    return self;
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

- (UILabel *)titleL {
    if (!_titleL) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = UIColorOfHex(0x485461);
        titleL.numberOfLines = 0;
        titleL.font = [UIFont systemFontOfSize:15];
        [self.bgView addSubview:titleL];
        _titleL = titleL;
    }
    return _titleL;
}


- (UILabel *)contentL {
    if (!_contentL) {
        UILabel *contentL = [[UILabel alloc] init];
        contentL.textColor = UIColorOfHex(0x8095AB);
        contentL.numberOfLines = 0;
        contentL.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:contentL];
        _contentL = contentL;
    }
    return _contentL;
}

- (UILabel *)freL {
    if (!_freL) {
        UILabel *freL = [[UILabel alloc] init];
        freL.textColor = UIColorOfHex(0x485461);
        freL.numberOfLines = 0;
        freL.font = [UIFont systemFontOfSize:15];
        [self.bgView addSubview:freL];
        _freL = freL;
    }
    return _freL;
}


- (UIButton *)openBtn {
    
    if (!_openBtn) {
        UIButton *openBtn = [[UIButton alloc] init];
        
        [openBtn setTitleColor:UIColorOfHex(0x8095AB) forState:UIControlStateNormal];
        [openBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        
        [self.bgView addSubview:openBtn];
        _openBtn = openBtn;
    }
    return _openBtn;
}

@end
