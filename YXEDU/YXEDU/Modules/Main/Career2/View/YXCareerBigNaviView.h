//
//  YXCareerBigNaviView.h
//  YXEDU
//
//  Created by yixue on 2019/2/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCareerModel.h"
#import "LGYSegmentView.h"

NS_ASSUME_NONNULL_BEGIN

@class YXCareerBigNaviView;

@protocol YXCareerBigNaviViewDelegate <LGYSegmentViewDelegate>

- (void)careerBigNaviViewDidClickedTitle:(YXCareerBigNaviView *)careerBigNaviView;
- (void)careerBigNaviViewDidClickedBack:(YXCareerBigNaviView *)careerBigNaviView;

@end

@interface YXCareerBigNaviView : UIView

@property (nonatomic, weak) id<YXCareerBigNaviViewDelegate> delegate;

- (id)initWithPosition:(CGPoint)position;

@property (nonatomic, strong) YXCareerModel *careerModel;

@property (nonatomic, strong) LGYSegmentView *segmentView;

@end

NS_ASSUME_NONNULL_END
