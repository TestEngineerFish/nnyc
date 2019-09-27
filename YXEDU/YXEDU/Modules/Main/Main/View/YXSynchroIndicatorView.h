//
//  YXSynchroIndicatorView.h
//  YXEDU
//
//  Created by yao on 2019/1/10.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXSynchroIndicatorView : UIView
@property (nonatomic, readonly, strong) UILabel *tipsLabel;
+ (instancetype)synchroIndicatorShowToView:(UIView *)view;
- (void)hide;
@end

