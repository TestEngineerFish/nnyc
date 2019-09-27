//
//  YXGameModel.m
//  YXEDU
//
//  Created by yao on 2019/1/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXGameDetailModel.h"

@implementation YXGameConfig

@end

@implementation YXGameContent
- (NSArray *)errorCharacters {
    if (!_errorCharacters) {
        NSMutableArray *characters = [NSMutableArray array];
        for (NSInteger i = 0; i < _error.length; i++) {
            [characters addObject:[_error substringWithRange:NSMakeRange(i, 1)]];
        }
        _errorCharacters = [characters copy];
    }
    return _errorCharacters;
}

- (YXGameAnswer *)answerRecord {
    if (!_answerRecord) {
        _answerRecord = [[YXGameAnswer alloc] init];
        _answerRecord.encryptKey = _encryptKey;
        _answerRecord.wordId = _wordId;
        _answerRecord.word = _word;
        _answerRecord.nature = _nature;
        _answerRecord.answer = @"";
    }
    return _answerRecord;
}
@end

@implementation YXGameDetailModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"gameContent" : [YXGameContent class]
             };
}


@end
