//
//  YXBookBrefInfo.m
//  YXEDU
//
//  Created by yao on 2018/11/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookBrefInfo.h"

@implementation YXBookBrefInfo
- (instancetype)initWithBookId:(NSString *)bookId bookName:(NSString *)bookName wordNum:(NSString *)wordNum {
    if(self = [super init]) {
        self.bookId = bookId;
        self.bookName = bookName;
        self.wordNum = wordNum;
    }
    return self;
}
- (NSString *)bookName {
    if (!_bookName) {
        _bookName = [[YXConfigure shared].confModel getBookNameWithId:self.bookId];
    }
    return _bookName;
}

- (NSString *)bookId {
    return  _bookId ? _bookId : @"";
}
@end
