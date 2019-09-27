//
//  YXBeansAnimateView.h
//  YXEDU
//
//  Created by yao on 2019/1/15.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBeansAnimateView : UIView
+ (instancetype)showBeansAnimateViewWithBeanCount:(NSInteger)beanCount
                                        fromPoint:(CGPoint)fromPoint
                                          toPoint:(CGPoint)toPoint
                                      finishBlock:(void(^)(void))finishBlock;
@end

