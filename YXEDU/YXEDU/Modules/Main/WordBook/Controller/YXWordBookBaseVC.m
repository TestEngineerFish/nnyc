//
//  YXWordBookBaseVC.m
//  YXEDU
//
//  Created by yao on 2019/3/1.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXWordBookBaseVC.h"
#import "YXExerciseVC.h"

@interface YXWordBookBaseVC ()

@end

@implementation YXWordBookBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [kNotificationCenter addObserver:self selector:@selector(refreshData) name:kWordListShouldRefreshDataNotify object:nil];
    [kNotificationCenter addObserver:self selector:@selector(refreshData) name:kUploadExericiseResultNotify object:nil];
}

-  (void)dealloc {
    [kNotificationCenter removeObserver:self];
}


- (void)refreshData {
    
}

- (void)myWordBookEnterProcess:(YXMyWordBookModel *)myWordBookModel
                  exerciseType:(YXExerciseType)exerciseType
{
    if (exerciseType == YXExerciseWordListStudy) {
        if (myWordBookModel.learnState == 3) {
            [self refreshWprdListProcess:myWordBookModel exerciseType:exerciseType];
        }else {
            [self goToProcess:myWordBookModel exerciseType:exerciseType];
        }
    }else if(exerciseType == YXExerciseWordListListen){
        if (myWordBookModel.listenState == 3) {
            [self refreshWprdListProcess:myWordBookModel exerciseType:exerciseType];
        }else {
            [self goToProcess:myWordBookModel exerciseType:exerciseType];
        }
    }
}

- (void)refreshWprdListProcess:(YXMyWordBookModel *)myWordBookModel
                  exerciseType:(YXExerciseType)exerciseType
{
    NSString *type = (exerciseType == YXExerciseWordListStudy) ? @"learn" : @"listen";
    NSDictionary *param = @{
                            @"wordListId" : myWordBookModel.wordListId,
                            @"type" : type
                            };
    
    [YXUtils showProgress:self.view];
    [YXDataProcessCenter POST:DOMAIN_WORDLISTREFRESHPROGRESS
                   parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
                       if (result) {
                           [self goToProcess:myWordBookModel exerciseType:exerciseType];
                       }
                       [YXUtils hidenProgress:self.view];
                   }];
}


- (void)goToProcess:(YXMyWordBookModel *)myWordBookModel exerciseType:(YXExerciseType)exerciseType {
    YXExerciseVC *exeriseVC = [YXExerciseVC exerciseVCWithType:exerciseType
                                                learningBookId:myWordBookModel.wordListId];
    exeriseVC.planRemain = myWordBookModel.total;
    [[NSUserDefaults standardUserDefaults] setObject:myWordBookModel.wordListId forKey:kCurrentLearnWordListIdKey];
    [[NSUserDefaults standardUserDefaults] setObject:myWordBookModel.wordListName forKey:kUnfinishedWordListNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    exeriseVC.learningBookId = myWordBookModel.wordListId;
    [self.navigationController pushViewController:exeriseVC animated:YES];
}
@end
