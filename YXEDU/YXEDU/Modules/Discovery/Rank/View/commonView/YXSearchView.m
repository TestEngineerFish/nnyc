//
//  YXSearchView.m
//  YXEDU
//
//  Created by jukai on 2019/4/11.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXSearchView.h"

@implementation YXSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self bgImgView];
        [self searchImgView];
        [self noteLabel];
    }
    return self;
}

- (UIImageView *)searchImgView {
    if (!_searchImgView) {
        
        UIImageView *searchImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search_discover"]];
        CGFloat searchImageH = AdaptSize(15);
        CGFloat searchImageX = AdaptSize(15);
        CGFloat searchImageY = AdaptSize(9);
        searchImgView.frame = CGRectMake(searchImageX, searchImageY, searchImageH, searchImageH);
        [self addSubview:searchImgView];
        _searchImgView = searchImgView;
    }
    return _searchImgView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchFiled_discover"]];
        CGFloat searchImageH = AdaptSize(37);
        CGFloat searchImageX = AdaptSize(0);
        CGFloat searchImageY = AdaptSize(0);
        bgImgView.frame = CGRectMake(searchImageX, searchImageY, self.width, searchImageH);
        [self addSubview:bgImgView];
        _bgImgView = bgImgView;
    }
    return _bgImgView;
}


- (UILabel *)noteLabel {
    if (!_noteLabel) {
        UILabel *noteLabel = [[UILabel alloc] init];
        noteLabel.text = @"查单词";
        noteLabel.font = [UIFont pfSCRegularFontWithSize:15];
        noteLabel.textColor = [UIColor secondTitleColor];
        CGFloat searchImageW = AdaptSize(100);
        CGFloat searchImageH = AdaptSize(15);
        CGFloat searchImageX = AdaptSize(35);
        CGFloat searchImageY = AdaptSize(9);
        noteLabel.frame = CGRectMake(searchImageX, searchImageY, searchImageW, searchImageH);
        [self addSubview:noteLabel];
        _noteLabel = noteLabel;
    }
    return _noteLabel;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
