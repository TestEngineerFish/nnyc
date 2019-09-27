//
//  YXGameModel.h
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXGameModel : NSObject
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *maxCredits;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, assign) NSInteger needCredits;
@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, assign) BOOL isLessAnHour;
@property (nonatomic, assign) NSInteger interverToGameEnd;
@property (nonatomic, copy) NSDictionary *timeStampAttributes;
@property (nonatomic, copy) NSAttributedString *timeStampAttriString;
- (void)updateTimeStampAttriString:(NSAttributedString *)timeStampAttriString;
//@property (nonatomic, copy) NSString *timeStampStr;
//@property (nonatomic, copy) NSString *countDownString;
@end

