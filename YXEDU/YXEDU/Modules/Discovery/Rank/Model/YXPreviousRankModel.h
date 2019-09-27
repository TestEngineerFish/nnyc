//
//  YXPreviousRankModel.h
//  YXEDU
//
//  Created by yao on 2018/12/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXMyPreGradeModel.h"
#import "YXUserRankModel.h"
@interface YXPreviousRankModel : NSObject
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) YXMyPreGradeModel *myGrades;
@property (nonatomic, strong) NSMutableArray *currentRankings;
@end

