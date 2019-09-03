//
//  YXFeedBackSelectImageView.m
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXFeedBackSelectImageView.h"
#import "BSCommon.h"

@interface YXFeedBackSelectImageView ()
@end

@implementation YXFeedBackSelectImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxImageCount = 3;
        self.imageArr = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray <UIImage *>*)getImageArray {
    return _imageArr;
}


- (void)setImageArr:(NSMutableArray *)imageArr {
    _imageArr = imageArr;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    for (int i =0; i < imageArr.count + 1; i++) {
        if (i == _maxImageCount) {
            return;
        }
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setFrame:CGRectMake(((SCREEN_WIDTH-300)/4.0)*(i+1)+i*100, 0, 100, 100)];
        [imageView setTag:i];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        if (i == imageArr.count) {
            [imageView setImage:[UIImage imageNamed:@"personal_feedback_add"]];
        } else {
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [closeBtn setBackgroundImage:[UIImage imageNamed:@"personal_feedback_close"] forState:UIControlStateNormal];
            [closeBtn setTag:i];
            [closeBtn setFrame:CGRectMake(75, 0, 25, 25)];
            [imageView addSubview:closeBtn];
            [imageView setImage:imageArr[i]];
        }
    }
}

- (void)closeBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    [_imageArr removeObjectAtIndex:button.tag];
    [self setImageArr:_imageArr];
}

- (void)tapAction:(UIGestureRecognizer *)getsure {
    UIImageView *imageView = (UIImageView *)getsure.view;
    if (imageView.tag == _imageArr.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAddImage:)]) {
            [self.delegate didClickedAddImage:_imageArr];
        }
    }
}

@end
