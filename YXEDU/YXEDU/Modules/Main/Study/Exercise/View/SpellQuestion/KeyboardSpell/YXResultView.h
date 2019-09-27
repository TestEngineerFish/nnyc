//
//  YXResultView.h
//  YXEDU
//
//  Created by yao on 2018/11/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YXReultStateType) {
    YXReultStateNone,
    YXReultStateCorrect,
    YXReultStateWrong,
};

@interface YXResultView : UIView
@property (nonatomic, assign) YXReultStateType resultType;
@end

