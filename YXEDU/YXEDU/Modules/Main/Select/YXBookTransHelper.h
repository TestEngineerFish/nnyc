//
//  YXBookTransHelper.h
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBookTransAnimator.h"
//#define kYXSettingBookIconFrame CGRrct

@interface YXBookTransHelper : NSObject<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) YXBookTransModel *transModel;
@property (nonatomic, assign) YXTransAnimateType animateType;
@end

