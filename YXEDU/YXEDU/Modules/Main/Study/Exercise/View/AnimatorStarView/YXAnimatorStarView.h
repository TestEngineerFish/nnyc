//
//  YXAnimatorStarView.h
//  YXEDU
//
//  Created by yixue on 2019/1/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXAnimatorStarView : UIView

- (id)initWithRadius:(CGFloat)spreadRadius position:(CGPoint)position;
- (void)launchAnimations;

@property (nonatomic, assign) CGFloat spreadRadius;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGFloat starRadius;
@property (nonatomic, assign) NSInteger numberOfStars;

@end

NS_ASSUME_NONNULL_END
