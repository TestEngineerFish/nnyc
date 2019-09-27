//
//  YXDescoverModel.h
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoverBannerModel.h"
#import "YXUserRankModel.h"
#import "YXGameModel.h"
#import "YXMyGradeModel.h"

@interface YXDescoverModel : NSObject
/* 1：正常状态 2：版本过低 3：游戏暂未开放 */
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) BOOL preState;
@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, strong) NSMutableArray *currentRankings;
@property (nonatomic, strong) YXGameModel *game;
@property (nonatomic, strong) YXMyGradeModel *myGrades;

@property (nonatomic, copy) NSArray *bannerImageLinks;
@property (nonatomic, copy) NSArray <YXUserRankModel *> *topThreeUsers;
@property (nonatomic, copy) NSArray <YXUserRankModel *> *leftSevenUsers;
//- (NSArray *)filterDataSource;
@end

