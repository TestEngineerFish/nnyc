//
//  YXPersonalViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPersonalViewModel.h"
#import "YXConfigure.h"
#import "YXHttpService.h"
#import "YXAPI.h"
#import "YXLogoutModel.h"
#import "NSObject+YR.h"
#import "YXPersonalBindModel.h"

@interface YXPersonalViewModel ()
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation YXPersonalViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr = [NSMutableArray array];
        [self configure];
    }
    return self;
}

- (void)configure {
    [self.dataArr removeAllObjects];
    [self.dataArr addObject:@(PersonalCellBlank)];
    [self.dataArr addObject:@(PersonalCellPlain)];
    [self.dataArr addObject:@(PersonalCellPlain)];
    [self.dataArr addObject:@(PersonalCellPlain)];
    
    [self.dataArr addObject:@(PersonalCellBlank)];
    
    [self.dataArr addObject:@(PersonalCellPlain)];
    [self.dataArr addObject:@(PersonalCellPlain)];
    [self.dataArr addObject:@(PersonalCellBlank)];
    
    [self.dataArr addObject:@(PersonalCellPlain)];
    [self.dataArr addObject:@(PersonalCellPlain)];
    [self.dataArr addObject:@(PersonalCellBlank)];
    
    [self.dataArr addObject:@(PersonalCellLogout)];
}

- (NSInteger)rowCount {
    return self.dataArr.count;
}

- (PersonalCellType)rowType:(NSInteger)idx {
    return [self.dataArr[idx] integerValue];
}

- (float)rowHeight:(NSInteger)idx {
    PersonalCellType cellType = [self rowType:idx];
    switch (cellType) {
        case PersonalCellPlain:
            return 60;
        case PersonalCellBlank:
            return 10;
        case PersonalCellLogout:
            return 60;
        default:
            break;
    }
}

- (void)logout:(YXLogoutModel *)model finish:(finishBlock)block {
    NSDictionary *dic = [model yrModelToDictionary];
    [[YXHttpService shared]POST:DOMAIN_LOGOUT parameters:dic finshedBlock:^(id obj, BOOL result) {
        [[YXConfigure shared] saveToken:@""];
        [YXConfigure shared].mobile = @"";
        block(obj, result);
    }];
}

- (void)bindSO:(YXPersonalBindModel *)bindModel complete:(finishBlock)block {
    NSDictionary *dic = [bindModel yrModelToDictionary];
    [[YXHttpService shared] POST:DOMAIN_BINDSO parameters:dic finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (void)unbindSO:(NSString *)unbind complete:(finishBlock)block {
    [[YXHttpService shared] POST:DOMAIN_UNBINDSO parameters:@{@"unbind_pf":unbind} finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

//- (void)requestUserInfo:(finishBlock)block {
//    [[YXComHttpService shared]requestUserInfo:^(id obj, BOOL result) {
//        block(obj, result);
//    }];
//}

@end
