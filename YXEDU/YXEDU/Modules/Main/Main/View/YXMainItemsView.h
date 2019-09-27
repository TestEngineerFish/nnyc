//
//  YXMainItemsView.h
//  YXEDU
//
//  Created by jukai on 2019/6/5.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXLearnReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemBannerButton : YXNoHightButton

@end

@interface YXMainItemsView : UIView

@property (nonatomic, copy)void(^checkReportBlock)(NSInteger index);
@property (nonatomic, assign)BOOL hasReport;
@property (nonatomic, strong)YXLearnReportModel *reportModel;
@property (nonatomic, copy) NSString *taskStatusString;
@property (nonatomic, assign) BOOL isTodayCheckin;
@property (nonatomic, strong) ItemBannerButton *markBtn;
@property (nonatomic, strong) ItemBannerButton *reportBtn;

- (void)updateConstraints:(BOOL)showArticleView;

@end

NS_ASSUME_NONNULL_END
