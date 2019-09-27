//
//  YXMyChallengeCell.h
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXChallengeUserCell.h"
#import "YXMyGradeModel.h"
#import "YXMyPreGradeModel.h"

typedef void (^shareBlock) (void);
@interface YXMyChallengeCell : YXChallengeUserCell
@property (nonatomic, strong) YXMyGradeModel *myRankModel;
@property (nonatomic, strong) YXMyPreGradeModel *preRankModel;
@property (nonatomic, strong) shareBlock shareBlock;
@end

