//
//  YXSetProgressView.h
//  YXEDU
//
//  Created by yao on 2018/11/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBookPlanModel.h"

typedef void(^YXSetPlanResultBlock)(void);
@class YXSetProgressView;
@protocol YXSetProgressViewDelegate <NSObject>
@optional
- (void)setProgressViewAffirmBtn:(YXSetProgressView *)pView;
- (void)setProgressViewSetPlan:(YXSetProgressView *)pView withHttpResponse:(YRHttpResponse *)response;
@end

@interface YXSetProgressView : UIView
@property (nonatomic, readonly, strong) YXBookPlanModel *planModel;
@property (nonatomic, weak)id <YXSetProgressViewDelegate> delegate;
@property (nonatomic, copy) YXSetPlanResultBlock setPlanResultBlock;

+ (YXSetProgressView *)setProgressViewWithPlanModel:(YXBookPlanModel *)planModel
                          withDelegate:(id<YXSetProgressViewDelegate>)delegate;
- (void)hideTipsLabel;
@end

