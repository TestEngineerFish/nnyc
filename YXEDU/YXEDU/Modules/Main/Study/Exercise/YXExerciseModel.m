//
//  YXExerciseModel.m
//  YXEDU
//
//  Created by yao on 2019/3/1.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXExerciseModel.h"

@implementation YXExerciseModel
- (BOOL)isNormalStudyProcess {
    return  self.exerciseType == YXExerciseNormal ||
            self.exerciseType == YXExerciseWordListStudy ||
            self.exerciseType == YXExerciseWordListListen;
}


@end
