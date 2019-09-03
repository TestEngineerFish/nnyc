//
//  YXFMDBManager.m
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXFMDBManager.h"
#import "YXMaterialModel.h"
#import "NSObject+YR.h"
#import "FMDB.h"

@interface YXFMDBManager ()
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

static YXFMDBManager *_manager = nil;
@implementation YXFMDBManager
// 单例使用
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [YXFMDBManager new];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/YX.sqlite"];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        [self createMaterialTable];
        [self createStudyRecordTable];
    }
    return self;
}

/* path:
 * resname:
 * size:
 * resid:
 * date:
 */
- (void)createMaterialTable {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS MATERIAL_INFO (id INTEGER PRIMARY KEY autoincrement, path TEXT NOT NULL, resname TEXT NOT NULL, size TEXT NOT NULL, resid TEXT NOT NULL, date DATE NOT NULL, UNIQUE(resid))"];
    }];
}

- (void)insertMaterial:(YXMaterialModel *)model completeBlock:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isOk = [db executeUpdate:@"INSERT INTO MATERIAL_INFO (path, resname, size, resid, date) VALUES (?, ?, ?, ?, ?)",
                     model.path,
                     model.resname,
                     model.size,
                     model.resid,
                     model.date];
        if (isOk) {
            block(model, YES);
        } else {
            block(model, NO);
        }
    }];
}

- (void)queryMaterial:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM MATERIAL_INFO ORDER BY resid ASC"];
        NSMutableArray *accountArr = [NSMutableArray array];
        while ([result next]) {
            NSString *path = [result stringForColumn:@"path"];
            NSString *resname = [result stringForColumn:@"resname"];
            NSString *size = [result stringForColumn:@"size"];
            NSString *resid = [result stringForColumn:@"resid"];
            NSDate *date = [result dateForColumn:@"date"];
            NSDictionary *dic = @{@"path": path,
                                  @"resname":resname,
                                  @"size":size,
                                  @"resid":resid,
                                  @"date": date};
            YXMaterialModel *model = [YXMaterialModel yrModelWithJSON:dic];
            [accountArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [accountArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                YXMaterialModel *model1 = obj1;
                YXMaterialModel *model2 = obj2;
                if (model1.resid.integerValue > model2.resid.integerValue) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }];
            block(accountArr, YES);
        });
    }];
}

- (void)deleteRow:(YXMaterialModel *)model completeBlock:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"DELETE FROM MATERIAL_INFO WHERE date = ?", model.date];
        block(model, YES);
    }];
}

- (void)deleteAll:(finishBlock)block  {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"DELETE FROM MATERIAL_INFO"];
        block(nil, YES);
    }];
}


/*
 * recordid
 * bookid
 * unitid
 * questionidx
 * questionid
 * uuid
 * log
 */
- (void)createStudyRecordTable {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS STUDYPROGRESS_INFO (id INTEGER PRIMARY KEY autoincrement, bookid TEXT NOT NULL, unitid TEXT NOT NULL, questionidx TEXT NOT NULL, questionid TEXT NOT NULL, uuid TEXT NOT NULL, learn_status TEXT NOT NULL, recordid TEXT NOT NULL, log TEXT NOT NULL, UNIQUE(recordid))"];
    }];
}


- (void)insertRecord:(YXStudyRecordModel *)model completeBlock:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isOk = [db executeUpdate:@"INSERT INTO STUDYPROGRESS_INFO (recordid, bookid, unitid, questionidx, questionid, learn_status, uuid, log) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                     model.recordid,
                     model.bookid,
                     model.unitid,
                     model.questionidx,
                     model.questionid,
                     model.learn_status,
                     model.uuid,
                     model.log];
        if (isOk) {
            block(model, YES);
        } else {
            block(model, NO);
        }
    }];
}

- (void)replaceRecord:(YXStudyRecordModel *)model completeBlock:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isOk = [db executeUpdate:@"REPLACE INTO STUDYPROGRESS_INFO (recordid, bookid, unitid, questionidx, questionid, learn_status, uuid, log) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                     model.recordid,
                     model.bookid,
                     model.unitid,
                     model.questionidx,
                     model.questionid,
                     model.learn_status,
                     model.uuid,
                     model.log];
        if (isOk) {
            block(model, YES);
        } else {
            block(model, NO);
        }
    }];
}


- (void)queryRecord:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM STUDYPROGRESS_INFO"];
        NSMutableArray *accountArr = [NSMutableArray array];
        while ([result next]) {
            NSString *recordid = [result stringForColumn:@"recordid"];
            NSString *bookid = [result stringForColumn:@"bookid"];
            NSString *unitid = [result stringForColumn:@"unitid"];
            NSString *questionidx = [result stringForColumn:@"questionidx"];
            NSString *questionid = [result stringForColumn:@"questionid"];
            NSString *learn_status = [result stringForColumn:@"learn_status"];
            NSString *uuid = [result stringForColumn:@"uuid"];
            NSString *log = [result stringForColumn:@"log"];
            NSDictionary *dic = @{@"recordid": recordid,
                                  @"bookid":bookid,
                                  @"unitid":unitid,
                                  @"questionidx":questionidx,
                                  @"questionid":questionid,
                                  @"learn_status":learn_status,
                                  @"uuid": uuid,
                                  @"log": log};
            YXStudyRecordModel *model = [YXStudyRecordModel yrModelWithJSON:dic];
            [accountArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (accountArr.count) {
                block(accountArr, YES);
            } else {
                block(nil, NO);
            }
        });
    }];
}

- (void)queryRecordByRecordId:(NSString *)recordId completeBlock:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM STUDYPROGRESS_INFO WHERE recordid = ?", recordId];
        NSMutableArray *accountArr = [NSMutableArray array];
        while ([result next]) {
            NSString *recordid = [result stringForColumn:@"recordid"];
            NSString *bookid = [result stringForColumn:@"bookid"];
            NSString *unitid = [result stringForColumn:@"unitid"];
            NSString *questionidx = [result stringForColumn:@"questionidx"];
            NSString *questionid = [result stringForColumn:@"questionid"];
            NSString *learn_status = [result stringForColumn:@"learn_status"];
            NSString *uuid = [result stringForColumn:@"uuid"];
            NSString *log = [result stringForColumn:@"log"];
            NSDictionary *dic = @{@"recordid": recordid,
                                  @"bookid":bookid,
                                  @"unitid":unitid,
                                  @"questionidx":questionidx,
                                  @"questionid":questionid,
                                  @"learn_status":learn_status,
                                  @"uuid": uuid,
                                  @"log": log};
            YXStudyRecordModel *model = [YXStudyRecordModel yrModelWithJSON:dic];
            [accountArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(accountArr, YES);
        });
    }];
}

- (void)deleteRecordRow:(YXStudyRecordModel *)model completeBlock:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"DELETE FROM STUDYPROGRESS_INFO WHERE recordid = ?", model.recordid];
        block(model, YES);
    }];
}

- (void)deleteRecordAll:(finishBlock)block  {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@"DELETE FROM STUDYPROGRESS_INFO"];
        block(nil, YES);
    }];
}

- (void)batchDeleteRecord:(NSMutableArray *)recordArr completeBlock:(finishBlock)block {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if ([db open]) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (YXStudyRecordModel *recordModel in recordArr) {
                    [db executeUpdate:@"DELETE FROM STUDYPROGRESS_INFO WHERE recordid = ?", recordModel.recordid];
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
                block(nil, NO);
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                    block(nil, YES);
                }
            }
        }
    }];
}

@end
