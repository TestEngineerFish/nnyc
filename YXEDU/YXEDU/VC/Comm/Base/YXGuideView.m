//
//  YXGuideView.m
//  YXEDU
//
//  Created by shiji on 2018/4/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGuideView.h"
#import "BSCommon.h"
#import "YXConfigure.h"

@interface YXGuideView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *welcomeScroll;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@end

@implementation YXGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.welcomeScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.welcomeScroll.delegate = self;
        self.welcomeScroll.pagingEnabled = YES;
        self.welcomeScroll.scrollEnabled = YES;
        self.welcomeScroll.bounces = NO;
        self.welcomeScroll.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:self.welcomeScroll];
        
        self.pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 20)];
        self.pageCtrl.numberOfPages = 3;
        self.pageCtrl.currentPage = 0;
        [self addSubview:self.pageCtrl];
        
        for (int i = 0; i < 3; i ++) {
            UIImageView *pageImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            if (i==0) {
                if (iPhone4) {
                    pageImage.image = [UIImage imageNamed:@"guide_320x480_1"];
                } else if (iPhone5) {
                    pageImage.image = [UIImage imageNamed:@"guide_640x960_1"];
                } else if (iPhone6) {
                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_1"];
                } else if (iPhone6P) {
                    pageImage.image = [UIImage imageNamed:@"guide_1242x2208_1"];
                } else if (iPhoneX) {
                    pageImage.image = [UIImage imageNamed:@"guide_1125x2436_1"];
                } else {
                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_1"];
                }
            } else if (i==1) {
                if (iPhone4) {
                    pageImage.image = [UIImage imageNamed:@"guide_320x480_2"];
                } else if (iPhone5) {
                    pageImage.image = [UIImage imageNamed:@"guide_640x960_2"];
                } else if (iPhone6) {
                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_2"];
                } else if (iPhone6P) {
                    pageImage.image = [UIImage imageNamed:@"guide_1242x2208_2"];
                } else if (iPhoneX) {
                    pageImage.image = [UIImage imageNamed:@"guide_1125x2436_2"];
                } else {
                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_2"];
                }
            } else if (i==2) {
                _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (iPhone4) {
                    UIImage *image = [UIImage imageNamed:@"guide_btn_320"];
                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
                    CGFloat w = image.size.width * 60 / image.size.height;
                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 60)];
                    pageImage.image = [UIImage imageNamed:@"guide_320x480_3"];
                } else if (iPhone5) {
                    UIImage *image = [UIImage imageNamed:@"guide_btn_640"];
                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
                    CGFloat w = image.size.width * 60 / image.size.height;
                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 60)];
                    pageImage.image = [UIImage imageNamed:@"guide_640x960_3"];
                } else if (iPhone6) {
                    UIImage *image = [UIImage imageNamed:@"guide_btn_750"];
                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
                    CGFloat w = image.size.width * 80 / image.size.height;
                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_3"];
                } else if (iPhone6P) {
                    UIImage *image = [UIImage imageNamed:@"guide_btn_1242"];
                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
                    CGFloat w = image.size.width * 80 / image.size.height;
                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
                    pageImage.image = [UIImage imageNamed:@"guide_1242x2208_3"];
                } else if (iPhoneX) {
                    UIImage *image = [UIImage imageNamed:@"guide_btn_1125"];
                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
                    CGFloat w = image.size.width * 80 / image.size.height;
                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
                    pageImage.image = [UIImage imageNamed:@"guide_1125x2436_3"];
                } else {
                    UIImage *image = [UIImage imageNamed:@"guide_btn_750"];
                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
                    CGFloat w = image.size.width * 80 / image.size.height;
                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_3"];
                }
                [_enterBtn addTarget:self action:@selector(enterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.welcomeScroll addSubview:pageImage];
            if (_enterBtn) {
                [self.welcomeScroll addSubview:_enterBtn];
            }
        }
    }
    return self;
}

- (void)enterBtnClicked:(id)sender {
    [YXConfigure shared].isShowGuideView = YES;
    [self removeFromSuperview];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 0) {
        self.pageCtrl.currentPage = 0;
    } else if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 1) {
        self.pageCtrl.currentPage = 1;
    } else if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 2) {
        self.pageCtrl.currentPage = 2;
    }
}

@end
