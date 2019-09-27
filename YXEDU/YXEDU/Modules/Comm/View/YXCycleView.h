//
//  YXCycleView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/18.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishBlock)(void);
@interface YXCycleView : UIView
@property(strong,nonatomic)CAShapeLayer *shapeLayer;

+ (YXCycleView *)showCycleViewWith:(CGRect)frame;
- (void)startProgressAnimate:(CGFloat)second finishBlock:(FinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
