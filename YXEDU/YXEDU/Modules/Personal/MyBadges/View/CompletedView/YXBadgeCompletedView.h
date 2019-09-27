//
//  YXBadgeCompletedView.h
//  YXEDU
//
//  Created by Jake To on 10/26/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPersonalBadgeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXBadgeCompletedView : UIView

+ (YXBadgeCompletedView *)showCompletedViewWithBadge:(YXPersonalBadgeModel *)badge;

@end

NS_ASSUME_NONNULL_END
