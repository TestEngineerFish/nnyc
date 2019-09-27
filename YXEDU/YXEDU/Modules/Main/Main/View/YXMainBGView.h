//
//  YXMainBGView.h
//  YXEDU
//
//  Created by yao on 2018/11/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMainModel.h"
@interface YXMainBGView : UIImageView
@property (nonatomic, strong)YXMainModel *mainModel;
//@property (nonatomic, assign)BOOL hasPlanRemains;
@property (nonatomic, readonly, weak)UIButton *shareBtn;
@property (nonatomic, readonly, weak)UIButton *rightBtn;
@property (nonatomic, readonly, strong) UIButton *beginReciteBtn;

- (void)animateSwitch:(BOOL)isOn;

- (void)noNetworkState;
@end

