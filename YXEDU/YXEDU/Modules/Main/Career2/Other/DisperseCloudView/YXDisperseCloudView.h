//
//  YXDisperseCloudView.h
//  YXEDU
//
//  Created by yixue on 2019/2/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXStudyModulHeader.h"

NS_ASSUME_NONNULL_BEGIN


@class YXDisperseCloudView;

//@protocol YXDisperseCloudViewDelegate <NSObject>
//- (void)disperseCloudViewOpenAnimationFinished:(YXDisperseCloudView *)disperseCloudView;
//- (void)disperseCloudViewClosedAnimationFinished:(YXDisperseCloudView *)disperseCloudView;
//@end

@interface YXDisperseCloudView : UIView

// 云开启
- (void)doOpenAnimate;
- (void)doOpenAnimateFinishBlock:(void(^)(void))finishBlock;
- (void)doOpenAnimateWithDelay:(NSInteger)delay finishBlock:(nullable void(^)(void))finishBlock;

// 云关闭
- (void)doCloseAnimate;
- (void)doCloseAnimateShowProgress:(BOOL)show closedFinishBlock:(nullable void(^)(void))finishBlock openFinishBlock:(nullable void(^)(void))openFinishBlock doOpenWithDelay:(NSInteger)openDelay;

//@property (nonatomic, weak) id<YXDisperseCloudViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, assign) YXExerciseType type;
@property (nonatomic, assign) NSInteger numberOfWords;
@property (nonatomic, assign) NSInteger numberOfSection;
@property (nonatomic, assign) BOOL isShowView;

@end



@interface YXCloudWindow : UIWindow
@property (nonatomic, weak) YXDisperseCloudView *cloudView;
- (void)doOpenAnimate;

- (void)doCloseAnimate;

- (void)doCloseAnimateShowProgress:(BOOL)show closedFinishBlock:(nullable void(^)(void))finishBlock openFinishBlock:(nullable void(^)(void))openFinishBlock;

@property (nonatomic, assign) YXExerciseType type;
@property (nonatomic, assign) NSInteger numberOfWords;
@property (nonatomic, assign) NSInteger numberOfSection;
@end
NS_ASSUME_NONNULL_END
