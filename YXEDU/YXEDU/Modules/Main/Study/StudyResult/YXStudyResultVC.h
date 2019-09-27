//
//  YXStudyResultVC.h
//  YXEDU
//
//  Created by Jake To on 11/2/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXStudyModulHeader.h"
@interface YXStudyResultVC : UIViewController
@property (nonatomic, assign) YXExerciseType studyResultType;
@property (nonatomic, copy) NSString *wordListId;
- (instancetype)initWithStudyResultType:(YXExerciseType)studyResultType;
@end

