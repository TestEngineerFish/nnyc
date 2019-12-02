//
//  YXDeleteAnimateView.h
//  YXEDU
//
//  Created by yao on 2018/12/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

@interface YXDeleteAnimateView : UIView
@property (nonatomic, readonly ,strong)UIView *animateContentView;
@property (nonatomic, readonly ,strong)UIView *animateView;;
@property (nonatomic, assign)CGRect contentFrame;
+ (YXDeleteAnimateView *)showDeleteAnimateViewWithContentFrame:(CGRect)contentFrame;
- (void)doAnimationWithCompletion:(void (^)(void))completion;
@end

