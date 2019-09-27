//
//  YXExerciseVC.h
//  YXEDU
//
//  Created by shiji on 2018/4/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXStudyModulHeader.h"
#import "YXDisperseCloudView.h"


@interface YXExerciseVC : BSRootVC
//@property (nonatomic, assign) BOOL haveReviewWords;
@property (nonatomic, copy) NSString *learningBookId;// 词单或词书
@property (nonatomic, assign) YXExerciseType exerciseType;
@property (nonatomic, assign) NSInteger planRemain;
@property (nonatomic, strong) YXDisperseCloudView *disperseCloudView;
+ (YXExerciseVC *)exerciseVCWithType:(YXExerciseType)exerciseType learningBookId:(NSString *)bookId;
/**
 废弃借口
 @param model 模型
 */
- (void)insertModel:(id)model;
@end
