
//
//  YXGameModel.m
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGameModel.h"
@interface YXGameModel ()
@end

@implementation YXGameModel
- (NSString *)gameId {
    return _gameId ? _gameId : @"";
}
- (NSDictionary *)timeStampAttributes {
    if (!_timeStampAttributes) {
        _timeStampAttributes = @{
                                 NSForegroundColorAttributeName : [UIColor secondTitleColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:12]
                                 };
    }
    return _timeStampAttributes;
}

- (NSAttributedString *)timeStampAttriString {
    if (!_timeStampAttributes) {
        
        if (self.isLessAnHour) {
            NSInteger leftSeconds = self.interverToGameEnd;
            NSInteger hour = leftSeconds / 3600;
            NSInteger minute = leftSeconds / 60;
            NSInteger second = leftSeconds % 60;
            NSString *countDownStr = [NSString stringWithFormat:@"剩余时间%02zd:%02zd:%02zd",hour,minute,second];
            
            NSString *descString = [NSString stringWithFormat:@"本期挑战%@",countDownStr];
            NSMutableAttributedString *desAttriString = [[NSMutableAttributedString alloc] initWithString:descString
                                                                                               attributes:self.timeStampAttributes];
            NSRange stampRange = [descString rangeOfString:countDownStr];
            [desAttriString addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFD9725) range:stampRange];
            _timeStampAttriString = [desAttriString copy];
        }else {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"YYYY.MM.dd HH:mm:ss";
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.endTime];
            NSString *timeStampStr = [format stringFromDate:date];
            NSString *oriString = [NSString stringWithFormat:@"本期挑战于%@结束",timeStampStr];
            NSMutableAttributedString *desAttriString = [[NSMutableAttributedString alloc] initWithString:oriString
                                                                                               attributes:self.timeStampAttributes];
            NSRange stampRange = [oriString rangeOfString:timeStampStr];
            [desAttriString addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFD9725) range:stampRange];
            _timeStampAttriString = [desAttriString copy];
        }

    }
    return _timeStampAttriString;
}

- (BOOL)isLessAnHour {
    if (!_isLessAnHour) {
        _isLessAnHour = (self.interverToGameEnd > 0 && self.interverToGameEnd <= 60 * 60);
    }
    return _isLessAnHour;
}

- (NSInteger)interverToGameEnd {
    if (!_interverToGameEnd) {
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        _interverToGameEnd = self.endTime - nowInterval;
    }
    return _interverToGameEnd;
}

- (void)updateTimeStampAttriString:(NSAttributedString *)timeStampAttriString {
    _timeStampAttriString = timeStampAttriString;
}
//- (NSString *)timeStampStr {
//    if (!_timeStampStr) {
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        format.dateFormat = @"YYYY.MM.dd HH:mm:ss";
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.endTime];
//        _timeStampStr = [format stringFromDate:date];
//    }
//    return _timeStampStr;
//}
@end
