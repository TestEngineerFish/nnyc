//
//  YXMyGradeModel.h
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRankBaseInfo.h"
typedef NS_ENUM(NSInteger, YXChallengeResultType) {
    YXChallengeIneligible = 1,  // 未完成学习计划，不能挑战 （未完成挑战）
    YXChallengeUnDo,            // 学习计划完成可以挑战 （未完成挑战）
    YXChallengeFail,            // 挑战失败
    YXChallengeSuccess          // 挑战成功
};

@interface YXMyGradeModel : NSObject
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger userCredits;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) YXRankBaseInfo *desc;
@property (nonatomic, strong) UIImage *acrIcon;
@end
