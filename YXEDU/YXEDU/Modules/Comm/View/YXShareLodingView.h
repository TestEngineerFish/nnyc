//
//  YXShareLodingView.h
//  YXEDU
//
//  Created by jukai on 2019/5/6.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXShareLodingView : UIView

+ (YXShareLodingView *)showShareLodingInView:(UIView *)view;
-(void)showLoading;
-(void)hideLoading;

@end

NS_ASSUME_NONNULL_END
