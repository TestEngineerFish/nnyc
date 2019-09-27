//
//  YXTostView.h
//  YXEDU
//
//  Created by yao on 2018/11/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YXVoiceRecordState)
{
    YXVoiceRecordState_Normal,          //初始状态
    YXVoiceRecordState_Recording,       //正在录音
    YXVoiceRecordState_ReleaseToCancel, //上滑取消（也在录音状态，UI显示有区别）
    YXVoiceRecordState_RecordCounting,  //最后10s倒计时（也在录音状态，UI显示有区别）
    YXBVoiceRecordState_RecordTooShort,  //录音时间太短（录音结束了）
};

@interface YXTostView : UIView
@property (nonatomic, assign) YXVoiceRecordState currentRecordState;
@property (nonatomic, weak)UILabel *countLabel;
@property (nonatomic, weak)UILabel *countingTips;
//- (void)recodTooShort;
-(void)showRecordCounting:(CGFloat)count;
- (void)delayHide:(BOOL)isDelay;
@end

