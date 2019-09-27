//
//  YXCareerBigNaviModel.m
//  YXEDU
//
//  Created by yixue on 2019/2/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerModel.h"

@implementation YXCareerModel

- (id)initWithItem:(NSString *)item bookId:(NSInteger)bookId sort:(NSInteger)sort {
    self = [super init];
    if (self != nil) {
        self.item = item;
        self.bookId = bookId;
        self.sort = sort;
    }
    return self;
}

- (void)setBookId:(NSInteger)bookId {
    _bookId = bookId;
    //
    NSString *bookIdStr = [NSString stringWithFormat:@"%zd",_bookId];
    if ([bookIdStr isEqualToString:@"0"]){
        _bookName = @"全部词书";
        _itemTitles = @[@"已学词",@"收藏夹",@"错词本"];
    } else {
        _bookName = [[YXConfigure shared].confModel getBookNameWithId:bookIdStr];
        _itemTitles = @[@"已学词",@"未学词",@"收藏夹",@"错词本"];
    }
}

@end
