//
//  YXStudyProgressView.h
//  YXEDU
//
//  Created by shiji on 2018/9/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBookPlanModel.h"
#import "YXBaseMaskView.h"
#import "YXSetProgressView.h"

@interface YXStudyProgressView : YXBaseMaskView
@property (nonatomic, readonly, strong) YXSetProgressView *setProgressView;
@property (nonatomic, readonly, strong) YXBookPlanModel *planModel;

+ (YXStudyProgressView *)showProgressInView:(UIView *)view
                              withPlanModel:(YXBookPlanModel *)planModel
                               WithDelegate:(id<YXSetProgressViewDelegate>)delegate;
- (void)hide;
@end
