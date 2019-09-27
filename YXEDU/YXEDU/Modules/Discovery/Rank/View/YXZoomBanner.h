//
//  YXDescoverBanner.h
//  YXEDU
//
//  Created by yao on 2018/12/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <SDCycleScrollView/SDCycleScrollView.h>

@class YXZoomBanner;
@protocol YXZoomBannerDelegate <NSObject>
- (void)zoomBanner:(YXZoomBanner *)zoomBanner didScrollToIndex:(NSInteger)index;
- (void)zoomBanner:(YXZoomBanner *)zoomBanner didSelectItemAtIndex:(NSInteger)index;
@end

@interface YXZoomBanner : UIView
@property (nonatomic, weak) id<YXZoomBannerDelegate> delegate;
@property (nonatomic, readonly, strong) SDCycleScrollView *banner;
@property (nonatomic, copy) NSArray *imageLinks;
@property (nonatomic, copy) NSArray *localImageNames;

- (void)setupTimer;
- (void)invalidateTimer;
@end
