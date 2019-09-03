//
//  YXMaterialViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMaterialViewModel.h"
#import "YXFMDBManager.h"
#import "YXFileDBManager.h"
#import "YXUtils.h"
#import "NSString+YX.h"

@interface YXMaterialViewModel ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation YXMaterialViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr = [NSMutableArray array];
    }
    return self;
}

- (void)requestAllDB:(finishBlock)block {
    [self.dataArr removeAllObjects];
    [[YXFMDBManager shared]queryMaterial:^(id obj, BOOL result) {
        self.dataArr = [NSMutableArray arrayWithArray:obj];
        block(obj, result);
    }];
}

- (id)model:(NSInteger)idx {
    return self.dataArr[idx];
}

- (NSInteger)rowCount {
    return self.dataArr.count;
}

- (NSInteger)getAllSize {
    NSNumber *sum = [self.dataArr valueForKeyPath:@"@sum.size"];
    return sum.integerValue;
}

- (void)deleteDB:(NSInteger)idx finished:(finishBlock)block {
    YXMaterialModel *model = [self model:idx];
    [[YXFMDBManager shared]deleteRow:model completeBlock:^(id obj, BOOL result) {
        [self.dataArr removeObjectAtIndex:idx];
        [YXUtils removeFile:[[[YXUtils docPath]DIR:@"RESOURCE"]DIR:model.path]];
        block(obj, result);
    }];
}

- (void)deleteAll:(finishBlock)block {
    [[YXFMDBManager shared]deleteAll:^(id obj, BOOL result) {
        [self.dataArr removeAllObjects];
        [YXUtils removeFile:[[YXUtils docPath]DIR:@"RESOURCE"]];
        block(obj, result);
    }];
}

@end
