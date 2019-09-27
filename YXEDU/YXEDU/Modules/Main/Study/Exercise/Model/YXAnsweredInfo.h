//
//  YXAnsweredInfo.h
//  YXEDU
//
//  Created by yao on 2018/11/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXPerAnswer : NSObject
@property (nonatomic, assign)  int  questionTip;
@property (nonatomic, assign)  NSInteger  learnTime ;
@property (nonatomic, assign)  NSInteger  scanTime ;//单词详情页浏览时长 单位s
@property (nonatomic, assign)  int  isRight;
@property (nonatomic, copy)    NSString  *result;
+ (YXPerAnswer *)anwerWithQuestionTip:(int)questionTip
                            learnTime:(NSInteger)learnTime
                             scanTime:(NSInteger)scanTime
                              isRight:(int)isRight;
@end



@interface YXAnsweredInfo : NSObject
@property (nonatomic, copy)    NSString *bookId;
@property (nonatomic, copy)    NSString *wordId;
@property (nonatomic, copy)    NSString *questionId;
@property (nonatomic, copy)    NSString *questionType;
@property (nonatomic, assign)  int isAnswer;
@property (nonatomic, copy)    NSString *learnStart;
@property (nonatomic, copy)    NSString *learnFinish;
@property (nonatomic, strong) NSMutableArray *question;
- (NSMutableDictionary *)answerInfoDic;
//- (NSMutableDictionary *)answerInfoJson;
@end

