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
@property (nonatomic, weak) UIScrollView *welcomeScroll;
@property (nonatomic, strong) UIButton *enterBtn;
@property (nonatomic, weak) UIPageControl *pageCtrl;
@end

@implementation YXGuideView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.welcomeScroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        NSArray *images = @[@"guid-1",@"guid-2",@"guid-3",@"guid-4"];
        for (int i = 0; i < images.count; i ++) {
            UIImageView *pageImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            pageImage.image = [UIImage imageNamed:images[i]];
            pageImage.contentMode = UIViewContentModeScaleAspectFill;
            pageImage.userInteractionEnabled = YES;
            pageImage.layer.masksToBounds = YES;
             [self.welcomeScroll addSubview:pageImage];
            if (i == (images.count - 1)) {
                UIImage *image = [UIImage imageNamed:@"guid-btn"];
                _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
                CGFloat btnWidth = AdaptSize(128.f);
                CGFloat btnHeight = AdaptSize(35.f);
                CGFloat btnX = (SCREEN_WIDTH - btnWidth) * 0.5 + i * SCREEN_WIDTH;
                CGFloat btnY = SCREEN_HEIGHT - AdaptSize(120.f) - kSafeBottomMargin;
                
                CGFloat bMargin = 0;//SCREEN_HEIGHT- (iPhoneX ? 170 : 140);
                if (kIsIPhoneXSerious) {
                    bMargin = 170;
                }else if (iPhone5) {
                    bMargin = 120;
                }else {
                    bMargin = 140;
                }
                [_enterBtn setFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
                [_enterBtn addTarget:self action:@selector(enterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.welcomeScroll addSubview:_enterBtn];
            }
            
           
//            if (i==0) {
//                if (iPhone4) {
//                    pageImage.image = [UIImage imageNamed:@"guide_320x480_1"];
//                } else if (iPhone5) {
//                    pageImage.image = [UIImage imageNamed:@"guide_640x960_1"];
//                } else if (iPhone6) {
//                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_1"];
//                } else if (iPhone6P) {
//                    pageImage.image = [UIImage imageNamed:@"guide_1242x2208_1"];
//                } else if (iPhoneX) {
//                    pageImage.image = [UIImage imageNamed:@"guide_1125x2436_1"];
//                } else {
//                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_1"];
//                }
//            } else if (i==1) {
//                if (iPhone4) {
//                    pageImage.image = [UIImage imageNamed:@"guide_320x480_2"];
//                } else if (iPhone5) {
//                    pageImage.image = [UIImage imageNamed:@"guide_640x960_2"];
//                } else if (iPhone6) {
//                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_2"];
//                } else if (iPhone6P) {
//                    pageImage.image = [UIImage imageNamed:@"guide_1242x2208_2"];
//                } else if (iPhoneX) {
//                    pageImage.image = [UIImage imageNamed:@"guide_1125x2436_2"];
//                } else {
//                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_2"];
//                }
//            } else if (i==2) {
//                _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                if (iPhone4) {
//                    UIImage *image = [UIImage imageNamed:@"guide_btn_320"];
//                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
//                    CGFloat w = image.size.width * 60 / image.size.height;
//                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
//                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 60)];
//                    pageImage.image = [UIImage imageNamed:@"guide_320x480_3"];
//                } else if (iPhone5) {
//                    UIImage *image = [UIImage imageNamed:@"guide_btn_640"];
//                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
//                    CGFloat w = image.size.width * 60 / image.size.height;
//                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
//                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 60)];
//                    pageImage.image = [UIImage imageNamed:@"guide_640x960_3"];
//                } else if (iPhone6) {
//                    UIImage *image = [UIImage imageNamed:@"guide_btn_750"];
//                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
//                    CGFloat w = image.size.width * 80 / image.size.height;
//                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
//                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
//                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_3"];
//                } else if (iPhone6P) {
//                    UIImage *image = [UIImage imageNamed:@"guide_btn_1242"];
//                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
//                    CGFloat w = image.size.width * 80 / image.size.height;
//                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
//                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
//                    pageImage.image = [UIImage imageNamed:@"guide_1242x2208_3"];
//                } else if (iPhoneX) {
//                    UIImage *image = [UIImage imageNamed:@"guide_btn_1125"];
//                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
//                    CGFloat w = image.size.width * 80 / image.size.height;
//                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
//                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
//                    pageImage.image = [UIImage imageNamed:@"guide_1125x2436_3"];
//                } else {
//                    UIImage *image = [UIImage imageNamed:@"guide_btn_750"];
//                    [_enterBtn setBackgroundImage:image forState:UIControlStateNormal];
//                    CGFloat w = image.size.width * 80 / image.size.height;
//                    CGFloat x = (SCREEN_WIDTH - w)/2.0;
//                    [_enterBtn setFrame:CGRectMake(x + i * SCREEN_WIDTH, SCREEN_HEIGHT-150, w, 80)];
//                    pageImage.image = [UIImage imageNamed:@"guide_750x1334_3"];
//                }
//                [_enterBtn addTarget:self action:@selector(enterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//            }

        }
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


- (void)enterBtnClicked:(id)sender {
    [YXConfigure shared].isShowGuideView = YES;
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(guideViewDidFinished:)]) {
        [self.delegate guideViewDidFinished:self];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 0) {
        self.pageCtrl.currentPage = 0;
    } else if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 1) {
        self.pageCtrl.currentPage = 1;
    } else if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 2) {
        self.pageCtrl.currentPage = 2;
    } else if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 3) {
        self.pageCtrl.currentPage = 3;
    }
}
#pragma mark - subviews
- (UIScrollView *)welcomeScroll {
    if (!_welcomeScroll) {
        UIScrollView *welcomeScroll = [[UIScrollView alloc] init];
        welcomeScroll.delegate = self;
        welcomeScroll.pagingEnabled = YES;
        welcomeScroll.scrollEnabled = YES;
        welcomeScroll.bounces = NO;
        welcomeScroll.showsHorizontalScrollIndicator = NO;
        welcomeScroll.contentSize = CGSizeMake(4*SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubview:welcomeScroll];
        _welcomeScroll = welcomeScroll;
    }
    return _welcomeScroll;
}
- (UIPageControl *)pageCtrl {
    if (!_pageCtrl) {
        UIPageControl *pageCtrl = [[UIPageControl alloc] init];
        pageCtrl.numberOfPages = 4;
        pageCtrl.currentPage = 0;
        [self addSubview:pageCtrl];
        _pageCtrl = pageCtrl;
    }
    return _pageCtrl ;
}

@end
