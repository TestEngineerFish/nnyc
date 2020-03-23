//
//  YXStudyProgressView.m
//  YXEDU
//
//  Created by shiji on 2018/9/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyProgressView.h"
#import "BSCommon.h"
#import "BSUtils.h"
#import "YXUtils.h"
#import "YXHttpService.h"
#import "YXAPI.h"
#import "YXCustomSlider.h"

@interface YXStudyProgressView ()
@property (nonatomic, weak) YXSetProgressView *progressView;
@end

@implementation YXStudyProgressView {
    YXSetProgressView *_setProgressView;
}

- (YXBookPlanModel *)planModel {
    return self.progressView.planModel;
}

- (void)maskViewWasTapped {
    [super maskViewWasTapped];
    [self hide];
}

- (void)hide {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        self.progressView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 420);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (YXSetProgressView *)setProgressView {
    return self.progressView;
}

+ (YXStudyProgressView *)showProgressInView:(UIView *)view
                              withPlanModel:(YXBookPlanModel *)planModel
                               WithDelegate:(id<YXSetProgressViewDelegate>)delegate
{
    YXStudyProgressView *studyProgressView = [[YXStudyProgressView alloc] initWithFrame:view.bounds];
    YXSetProgressView *progressView = [YXSetProgressView setProgressViewWithPlanModel:planModel withDelegate:delegate];
    progressView.setPlanResultBlock = ^{
        [studyProgressView removeFromSuperview];
    };
    progressView.frame = CGRectMake(0, studyProgressView.bottom, SCREEN_WIDTH, 420);
    studyProgressView.maskView.alpha = 0.0f;
    [studyProgressView addSubview:progressView];
    studyProgressView.progressView = progressView;
    [view addSubview:studyProgressView];
    [UIView animateWithDuration:0.25 animations:^{
        studyProgressView.maskView.alpha = 0.4;
        progressView.frame = CGRectMake(0, studyProgressView.height - 352 - kSafeBottomMargin, SCREEN_WIDTH, 420);
    }];
    return studyProgressView;
}
@end
