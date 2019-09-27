//
//  YXExerciseFloatView.h
//  YXEDU
//
//  Created by shiji on 2018/6/4.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXExerciseFloatView;
@protocol YXExerciseFloatViewDelegate <NSObject>

@optional
- (void)submitBtnClicked:(id)sender;
- (void)exerciseFloatViewSubmmit:(YXExerciseFloatView *)floatView;
@end

@interface YXExerciseFloatView : UIView
@property (nonatomic, assign) id<YXExerciseFloatViewDelegate> delegate;
@property (nonatomic, strong) UIImage *snapShoptImage;
@end
