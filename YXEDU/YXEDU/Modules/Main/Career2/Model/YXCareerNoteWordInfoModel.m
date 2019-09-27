//
//  YXCareerNoteWordInfoModel.m
//  YXEDU
//
//  Created by yixue on 2019/2/25.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerNoteWordInfoModel.h"

@implementation YXCareerNoteWordInfoModel

- (void)setWord_id:(NSString *)word_id {
    _word_id = word_id;
    [YXWordModelManager quardWithWordId:_word_id completeBlock:^(id obj, BOOL result) {
        if (result) {
            _wordModel = (YXWordDetailModel *)obj;
        } else {
            _wordModel = [[YXWordDetailModel alloc] init];
        }
    }];
}

@end
