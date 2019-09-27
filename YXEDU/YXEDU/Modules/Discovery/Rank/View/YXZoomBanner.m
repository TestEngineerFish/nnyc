
//
//  YXDescoverBanner.m
//  YXEDU
//
//  Created by yao on 2018/12/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXZoomBanner.h"
@interface YXZoomBanner () <SDCycleScrollViewDelegate>
@end

@implementation YXZoomBanner
{
    SDCycleScrollView *_banner;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.banner.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.banner.frame = self.bounds;
}

- (void)setImageLinks:(NSArray *)imageLinks {
    _imageLinks = [imageLinks copy];
    self.banner.imageURLStringsGroup = imageLinks;
}

- (void)setLocalImageNames:(NSArray *)localImageNames {
    _localImageNames = [localImageNames copy];
    self.banner.localizationImageNamesGroup = _localImageNames;
}

#pragma mark - subViews
- (SDCycleScrollView *)banner {
    if (!_banner) {
        SDCycleScrollView *banner = [[SDCycleScrollView alloc] init];
        banner.placeholderImage = [UIImage imageNamed:@"bannerPlaceHolder"];
        banner.delegate = self;
        banner.backgroundColor = UIColorOfHex(0xDCF2FF);
        banner.autoScrollTimeInterval = 4.f;
        [banner setValue:@(UIViewContentModeScaleToFill) forKeyPath:@"backgroundImageView.contentMode"];
        banner.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        banner.showPageControl = NO;
        [self addSubview:banner];
        _banner = banner;
    }
    return _banner;
}

- (void)setupTimer {
    if ([self.banner respondsToSelector:@selector(setupTimer)]) {
        [self.banner performSelector:@selector(setupTimer)];
    }
}

- (void)invalidateTimer {
    if ([self.banner respondsToSelector:@selector(invalidateTimer)]) {
        [self.banner performSelector:@selector(invalidateTimer)];
    }
}

#pragma mark - <SDCycleScrollViewDelegate>
- (void)cycleScrollView:(SDCycleScrollView *)zoomBanner didScrollToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(zoomBanner:didScrollToIndex:)]) {
        [self.delegate zoomBanner:self didScrollToIndex:index];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)zoomBanner didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(zoomBanner:didSelectItemAtIndex:)]) {
        [self.delegate zoomBanner:self didSelectItemAtIndex:index];
    }
}

@end
