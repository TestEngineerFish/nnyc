//
//  YXInterfaceCacheService.m
//  YXEDU
//
//  Created by shiji on 2018/6/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXInterfaceCacheService.h"
#import "YXModelArchiverManager.h"
#import "YXPersonalBookModel.h"
#import "YXConfigure.h"
#import "YXCommHeader.h"

@interface YXInterfaceCacheService ()

@end

@implementation YXInterfaceCacheService
+ (instancetype)shared {
    static YXInterfaceCacheService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXInterfaceCacheService new];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)read:(NSString *)key {
    return [[YXModelArchiverManager shared]readObject:key];
}

- (void)write:(id)obj key:(NSString *)key {
    if (obj != nil) {
        [[YXModelArchiverManager shared]writeObject:obj file:key];
    }
}

- (void)remove:(NSString *)key {
    [[YXModelArchiverManager shared]removeObject:key];
}

// 仅仅在无网络使用
- (id)setLearning:(NSString *)key {
    YXPersonalBookModel *bookModel = [[YXInterfaceCacheService shared]read:STRCAT(kGetBookList,userId)];
    if (bookModel) {
        NSMutableArray *booklistArr = [NSMutableArray arrayWithArray:bookModel.booklist];
        NSInteger idx = 0;
        for (YXBookModel *mybookList in booklistArr) {
            if ([mybookList.bookid isEqualToString:key]) {
                [booklistArr replaceObjectAtIndex:idx withObject:[YXConfigure shared].loginModel.learning];
                [self updateLearning:mybookList];
                [YXConfigure shared].learningModel = mybookList;
                break;
            }
            idx ++;
        }
        bookModel.booklist = booklistArr;
        [[YXInterfaceCacheService shared]write:bookModel key:STRCAT(kGetBookList,userId)];
    }
    return bookModel;
}

- (void)updateLearning:(id)learning {
    [YXConfigure shared].loginModel.learning = learning;
    // 存储
    YXLoginModel *model = [self read:kGetUserInfo];
    model.learning = learning;
    [self write:model key:kGetUserInfo];
}
@end
