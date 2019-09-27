//
//  YXMissionToReceiveView.h
//  YXEDU
//
//  Created by 吉乞悠 on 2019/1/1.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//领取积分页面
@interface YXMissionToReceiveView : UIView

@property (nonatomic, strong) NSArray *completedTaskModelAry;
@property (nonatomic, strong) UIButton *toCheckBtn;
 @property (nonatomic, copy) void(^getAllCreditsBlock)(NSArray *completedTaskModelAry);
 @property (nonatomic, weak) UIImageView *douzi;

@end

NS_ASSUME_NONNULL_END
