//
//  YXShareChallengeRankView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/15.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDescoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXShareChallengeRankView : UIView
@property (nonatomic, strong) YXDescoverModel *descoverModel;
- (void)showWithAnimate;
@end

NS_ASSUME_NONNULL_END
