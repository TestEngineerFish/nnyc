//
//  YXBadgeView.h
//  YXEDU
//
//  Created by yao on 2018/11/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBadgeListModelOld.h"
#import "YXShareLinkModel.h"

@interface YXBadgeView : UIView
@property (nonatomic, strong)YXBadgeModelOld *badgeModel;
//+ (YXBadgeView *)showBadgeViewWithModel:(YXBadgeModelOld *)badgeModel
//                             shareModel:(YXShareLinkModel *)shareModel
//                            finishBlock:(ActionFinishBlock)finishBlock;

+ (YXBadgeView *)showBadgeViewTo:(UIView *)view
                       WithModel:(YXBadgeModelOld *)badgeModel
                      shareModel:(YXShareLinkModel *)shareModel
                     finishBlock:(ActionFinishBlock)finishBlock;
@end

