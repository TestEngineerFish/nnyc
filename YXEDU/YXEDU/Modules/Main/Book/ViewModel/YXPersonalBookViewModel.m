//
//  YXPersonalBookViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalBookViewModel.h"
#import "YXHttpService.h"
#import "YXAPI.h"
#import "YXPersonalBookModel.h"
#import "NSObject+YR.h"
#import "YXConfigure.h"
#import "YXInterfaceCacheService.h"
#import "YXPersonalBookDelModel.h"
#import "YXComHttpService.h"

@interface YXPersonalBookViewModel ()
@property (nonatomic, strong) NSMutableArray <YXBookModel *>*dataArr;
@end

@implementation YXPersonalBookViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr = [NSMutableArray array];
    }
    return self;
}

// 我的词书列表
- (void)getBookList:(finishBlock)block {
    [[YXHttpService shared]GET:DOMAIN_GETBOOKLIST parameters:nil finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXPersonalBookModel *bookModel = [YXPersonalBookModel yrModelWithJSON:obj];
            [YXConfigure shared].loginModel.booklist = bookModel.booklist;
            self.dataArr = [NSMutableArray arrayWithArray:bookModel.booklist];
            [[YXInterfaceCacheService shared]write:bookModel key:STRCAT(kGetBookList,userId)];
            block(obj, result);
        } else {
            YXPersonalBookModel *bookModel = [[YXInterfaceCacheService shared]read:STRCAT(kGetBookList,userId)];
            if (bookModel) {
                self.dataArr = [NSMutableArray arrayWithArray:bookModel.booklist];
                block(obj, YES);
            } else {
                block(obj, result);
            }
        }
    }];
}

// 设置学习的词书
- (void)setLearning:(NSString *)bookids finish:(finishBlock)block {
    [[YXComHttpService shared]setLearning:bookids finish:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (void)delBook:(id)bookDelModel finish:(finishBlock)block {
    YXPersonalBookDelModel *delModel = bookDelModel;
    NSDictionary *dic = [delModel yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_DELBOOK parameters:dic finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (NSInteger)rowCount {
    return self.dataArr.count;
}

- (id)rowModel:(NSInteger)idx {
    return self.dataArr[idx];
}


- (NSInteger)getAllWord {
    NSNumber *sum = [[YXConfigure shared].loginModel.learning.unit valueForKeyPath:@"@sum.word"];
    return sum.integerValue;
}

- (NSInteger)getAllLearned {
    NSNumber *sum = [[YXConfigure shared].loginModel.learning.unit valueForKeyPath:@"@sum.learned"];
    return sum.integerValue;
}


- (id)getLearningModel {
    return [YXConfigure shared].loginModel.learning;
}
- (NSString *)getLearnCoverUrl {
    return [YXConfigure shared].loginModel.learning.cover;
}

- (NSString *)getLearnBookName {
    return [YXConfigure shared].loginModel.learning.name;
}

- (NSString *)getImageUrl:(NSInteger)idx {
    return self.dataArr[idx].cover;
}

- (NSString *)getBookName:(NSInteger)idx {
    return self.dataArr[idx].name;
}

- (NSString *)getBookId:(NSInteger)idx {
    return self.dataArr[idx].bookid;
}

//
- (NSInteger)getAllOtherWord:(NSInteger)idx {
    NSNumber *sum = [self.dataArr[idx].unit valueForKeyPath:@"@sum.word"];
    return sum.integerValue;
}

- (NSInteger)getAllOtherLearned:(NSInteger)idx {
    NSNumber *sum = [self.dataArr[idx].unit valueForKeyPath:@"@sum.learned"];
    return sum.integerValue;
}

- (NSInteger)getAllOtherQuestioCount:(NSInteger)idx {
    NSNumber *sumquestion = [self.dataArr[idx].unit valueForKeyPath:@"@sum.q_idx"];
    NSNumber *sumlearnstatus = [self.dataArr[idx].unit valueForKeyPath:@"@sum.learn_status"];
    return sumquestion.integerValue + sumlearnstatus.integerValue;
}

@end
