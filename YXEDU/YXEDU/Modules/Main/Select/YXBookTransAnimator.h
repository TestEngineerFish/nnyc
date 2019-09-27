//
//  YXBookTransAnimator.h
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,YXTransAnimateType) {
    YXTransAnimatePresent = 0,
    YXTransAnimatePop
};

@interface YXBookTransModel : NSObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) CGRect originRect;
@property (nonatomic, assign) CGRect destionationRect;
@end






@interface YXBookTransAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) YXBookTransModel *transModel;
- (instancetype)initWithAnimateType:(YXTransAnimateType)animateType;
@end
