//
//  YXReportIndexView.h
//  YXEDU
//
//  Created by yao on 2018/12/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReoprtEleView.h"
#import "YXIndexModel.h"
@class YXReportIndexView;

@protocol YXReportIndexViewDelegate <NSObject>
- (void)reportIndexViewClikShowTips:(YXReportIndexView *)reportIndexView;
@end

@interface YXReportIndexView : YXReoprtEleView
@property (nonatomic, weak)id<YXReportIndexViewDelegate> delegate;
@property (nonatomic,readonly ,strong)UIButton *tipsButton;
@property (nonatomic, strong)NSArray *learnIndex;
@end

