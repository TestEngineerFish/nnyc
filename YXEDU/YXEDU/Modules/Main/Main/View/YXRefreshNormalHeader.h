//
//  YXRefreshNormalHeader.h
//  YXEDU
//
//  Created by yao on 2018/10/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
@class YXRefreshNormalHeader;
@protocol YXRefreshNormalHeaderDelegate <NSObject>
- (void)refreshNormalHeaderStateChanged:(MJRefreshState)state;
@end

@interface YXRefreshNormalHeader : MJRefreshNormalHeader
@property (nonatomic, weak)id<YXRefreshNormalHeaderDelegate> delegate;
@end

