//
//  YXAudioAnimation.h
//  YXEDU
//
//  Created by Jake To on 11/1/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXAudioAnimations : UIButton
@property (nonatomic, strong) UIImageView *gifImageView;
+ (YXAudioAnimations *)playAudioAnimation;
/**
 创建麦克风按钮

 @param immediately 是否立即执行动画
 @return 麦克风按钮
 */
+ (YXAudioAnimations *)playAudioAnimation:(BOOL)immediately;

+ (YXAudioAnimations *)playSpeakerAnimation;
+ (YXAudioAnimations *)playSpeakerAnimation:(BOOL)immediately;

+ (YXAudioAnimations *)uploadAudioAnimation;

+ (YXAudioAnimations *)playRecordAnimation;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
