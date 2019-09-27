//
//  YXRecordView.h
//  YXEDU
//
//  Created by yao on 2018/12/17.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTostView.h"

@class YXRecordView;
@protocol YXRecordViewDelegate <NSObject>
- (void)recordViewSholdStartRecord:(YXRecordView *)recordView;
- (void)recodViewStateChanged:(YXRecordView *)recordView;
- (void)recordViewShouldEndRecord:(YXRecordView *)recordView;
@end

@interface YXRecordView : UIImageView
@property (nonatomic,readonly, assign) YXVoiceRecordState currentRecordState;
@property (nonatomic, weak)id<YXRecordViewDelegate> delegate;
- (void)recordViewState:(BOOL)isNormal;
@end

