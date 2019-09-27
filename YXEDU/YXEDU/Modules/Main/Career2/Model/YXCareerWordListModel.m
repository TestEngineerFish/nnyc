//
//  YXCareerWordListModel.m
//  YXEDU
//
//  Created by yixue on 2019/2/20.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerWordListModel.h"

@implementation YXCareerWordListModel

- (void)setBookId:(NSInteger)bookId {
    _bookId = bookId;
    //
    NSString *bookIdStr = [NSString stringWithFormat:@"%zd",_bookId];
    if ([bookIdStr isEqualToString:@"0"]){
        _bookName = @"全部词书";
    } else {
        _bookName = [[YXConfigure shared].confModel getBookNameWithId:bookIdStr];
    }
}

@end
