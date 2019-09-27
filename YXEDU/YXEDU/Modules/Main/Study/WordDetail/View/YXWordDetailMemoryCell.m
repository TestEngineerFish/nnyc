//
//  YXWordDetailMemoryCell.m
//  YXEDU
//
//  Created by jukai on 2019/5/14.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXWordDetailMemoryCell.h"

@implementation YXWordDetailMemoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-17);
            make.top.bottom.equalTo(self.contentView).offset(0.0);
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(40);
            make.right.equalTo(self.contentView).offset(-40);
            make.top.equalTo(self.contentView).offset(15.0);
        }];
        
        [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleL);
            make.top.equalTo(self.titleL.mas_bottom).offset(12.0);
        }];
        
    }
    return self;
}

- (UILabel *)titleL {
    if (!_titleL) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = UIColorOfHex(0x485461);
        titleL.numberOfLines = 0;
        titleL.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:titleL];
        _titleL = titleL;
    }
    return _titleL;
}

- (UILabel *)contentL {
    if (!_contentL) {
        UILabel *contentL = [[UILabel alloc] init];
        contentL.textColor = UIColorOfHex(0x8095AB);
        contentL.numberOfLines = 0;
        contentL.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:contentL];
        _contentL = contentL;
    }
    return _contentL;
}


- (UIImageView *)bgView {
    if (!_bgView) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-34, 100)];
        [bgView setImage:[UIImage imageNamed:@"WordDetail背景"]];
//        [bgView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}


@end
