//
//  YXRefreshView.m
//  YXEDU
//
//  Created by yao on 2018/10/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRefreshView.h"

@interface YXRefreshView ()
@property (nonatomic, weak)UIImageView *gifImageView;
@property (nonatomic, weak)UILabel *tipsLabel;
@property (nonatomic, strong)NSArray *gifImages;
@end

@implementation YXRefreshView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *gifImageView = [[UIImageView alloc] init];
        gifImageView.image = [UIImage imageNamed:@"nnyc_refresh1"];
        [self addSubview:gifImageView];
        _gifImageView = gifImageView;
        gifImageView.animationImages = self.gifImages;
        gifImageView.animationDuration = 0.5;
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"下拉刷新";
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.font = [UIFont systemFontOfSize:13];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipsLabel];
        _tipsLabel = tipsLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.gifImageView.frame = CGRectMake((size.width - 34) * 0.5, 0, 34, 35);
    self.tipsLabel.frame = CGRectMake(0,35, size.width, 20);
}


- (void)refreshNormalHeaderStateChanged:(MJRefreshState)state {
    self.refreshState = state;
}


- (void)setRefreshState:(MJRefreshState)refreshState {
    _refreshState = refreshState;
    NSString *title = @"下拉刷新";
    if(refreshState == MJRefreshStatePulling) {
        title = @"松开立即刷新";
    }else if(refreshState == MJRefreshStateRefreshing) {
        title = @"正在刷新...";
        [self.gifImageView startAnimating];
    }else if(refreshState == MJRefreshStateIdle) {
        self.alpha = 0;
        [self.gifImageView stopAnimating];
    }
    self.tipsLabel.text = title;
}

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex {
    _currentImageIndex = currentImageIndex;
    if (currentImageIndex < self.gifImages.count && self.refreshState != MJRefreshStateRefreshing) {
        self.gifImageView.image = [self.gifImages objectAtIndex:currentImageIndex];
    }
}
- (NSArray *)gifImages {
    if (!_gifImages) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 1; i < 13; i++) {
            NSString *name = [NSString stringWithFormat:@"nnyc_refresh%zd",i];
            [images addObject:[UIImage imageNamed:name]];
        }
        _gifImages = [images copy];
    }
    return _gifImages;
}
@end
