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
        if (!self.imageArr) {
            self.imageArr = [NSMutableArray array];
        }
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
         [imageView setFrame:CGRectMake(i * 81, 0, 65, 65)];
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
        [imageView setTag:i];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tapGesture];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        if (i == imageArr.count) {
            [imageView setImage:[UIImage imageNamed:@"上传图片"]];
        } else {
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [closeBtn setBackgroundImage:[UIImage imageNamed:@"personal_feedback_close"] forState:UIControlStateNormal];
            [closeBtn setTag:i];
            [closeBtn setFrame:CGRectMake(45, 0, 20, 20)];
            [imageView addSubview:closeBtn];
            [imageView setImage:imageArr[i]];
        }
    }
}

- (void)closeBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    [_imageArr removeObjectAtIndex:button.tag];
    [self setImageArr:_imageArr];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapedCloseImage:)]) {
            [self.delegate didTapedCloseImage:_imageArr];
    }
}

- (void)tapAction:(UIGestureRecognizer *)getsure {
    UIImageView *imageView = (UIImageView *)getsure.view;
    if (imageView.tag == _imageArr.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAddImage:)]) {
            [self.delegate didClickedAddImage:_imageArr];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didShowAddedImage:)]) {
            [self.delegate didShowAddedImage:_imageArr[imageView.tag]];
        }
    }
}

@end
