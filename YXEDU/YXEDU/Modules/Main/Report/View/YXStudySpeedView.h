//
//  YXStudySpeedView.h
//  YXEDU
//
//  Created by yao on 2018/12/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReoprtEleView.h"

@interface YXStudySpeedView : YXReoprtEleView
@property (nonatomic, copy)NSString *avatar;
- (void)refreshWith:(NSString *)mySpeed platform:(NSString *)ptSpeed;
@end

