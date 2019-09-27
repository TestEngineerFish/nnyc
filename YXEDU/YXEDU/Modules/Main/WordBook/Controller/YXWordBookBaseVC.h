//
//  YXWordBookBaseVC.h
//  YXEDU
//
//  Created by yao on 2019/3/1.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXStudyModulHeader.h"
#import "YXMyWordBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXWordBookBaseVC : BSRootVC
- (void)myWordBookEnterProcess:(YXMyWordBookModel *)myWordBookModel
                  exerciseType:(YXExerciseType)exerciseType;
- (void)refreshData;
@end

NS_ASSUME_NONNULL_END
