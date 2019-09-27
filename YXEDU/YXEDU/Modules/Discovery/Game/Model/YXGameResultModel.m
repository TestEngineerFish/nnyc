
//
//  YXGameResultModel.m
//  YXEDU
//
//  Created by yao on 2019/1/4.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXGameResultModel.h"

@implementation YXGameResultModel
- (NSString *)answerTimeString {
    if (!_answerTimeString) {
        NSInteger minute = _answerTime / 60;
        NSInteger second = _answerTime % 60;
        _answerTimeString = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    }
    return _answerTimeString;
}

- (NSString *)rankingString {
    if (!_rankingString) {
        if (_ranking == 0) {
            _rankingString = @"未获得排名";
        }else {
            _rankingString = [NSString stringWithFormat:@"%zd",_ranking];
        }
    }
    return _rankingString;
}
@end
