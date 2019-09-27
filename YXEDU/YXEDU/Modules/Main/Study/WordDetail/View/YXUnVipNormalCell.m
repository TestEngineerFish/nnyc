//
//  YXUnVipNormalCell.m
//  YXEDU
//
//  Created by jukai on 2019/5/16.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXUnVipNormalCell.h"

@implementation YXUnVipNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-17);
            make.top.equalTo(self.contentView).offset(19.0);
            make.bottom.equalTo(self.contentView).offset(0.0);
        }];
        
        [self.noteL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(10.0);
        }];
    }
    return self;
}

- (UILabel *)noteL {
    if (!_noteL) {
        UILabel *noteL = [[UILabel alloc] init];
        [noteL setTextColor: UIColorOfHex(0xFDA751)];
        noteL.numberOfLines = 0;
        noteL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:noteL];
        _noteL = noteL;
    }
    return _noteL;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [bgView setImage:[UIImage imageNamed:@"WordDetailNor背景"]];
//        [bgView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}


@end
