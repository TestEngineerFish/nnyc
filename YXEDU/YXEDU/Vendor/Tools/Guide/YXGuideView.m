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
