//
//  YXSquareView.h
//  YXEDU
//
//  Created by yao on 2019/1/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXGameDetailModel.h"
#define kLotusInsertMargin AdaptSize(22)
#define kLotusTopMargin AdaptSize(32)
#define kLotusVerMargin (AdaptSize(24) + (kIsIPhoneXSerious ? AdaptSize(10) : 0))

@class YXSquareView;
@protocol YXSquareViewDelegate <NSObject>
- (void)squareViewEnterNextQuestion:(YXSquareView *)squareView;
@end

@interface YXSquareView : UIView
@property (nonatomic, weak) id <YXSquareViewDelegate> delegate;
@property (nonatomic, strong) YXGameContent *gameQuesModel;
- (void)resetLotusViews;
- (void)cancleFlashCorrectLotusViews;
- (void)doOpenAnimation;
- (void)doCloseAnimationWith:(void(^)(void))completion;
@end

