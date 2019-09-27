//
//  YXDataSituationView.h
//  YXEDU
//
//  Created by yao on 2018/12/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReoprtEleView.h"
@interface YXDataSituationView : YXReoprtEleView
- (void)refreshWith:(NSArray *)learnedQues
    correctPercents:(NSArray *)corPercents
          learnDays:(NSArray *)learnDays;
@end

