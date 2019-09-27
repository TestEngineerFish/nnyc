//
//  YXGameModel.h
//  YXEDU
//
//  Created by yao on 2019/1/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXGameAnswer.h"

@interface YXGameConfig : NSObject
@property (nonatomic, assign) NSInteger gameId;
/** 挑战总时长 秒 */
@property (nonatomic, assign) NSInteger totalTime;
/** 总题目数量 */
@property (nonatomic, assign) NSInteger totalNum;
/** 超过15秒可以跳过此题 */
@property (nonatomic, assign) NSInteger timeOut;
@end


@interface YXGameContent : NSObject
@property (nonatomic, copy) NSString *encryptKey;
@property (nonatomic, assign) NSInteger wordId;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *nature;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *meaning;

@property (nonatomic, assign) NSInteger questionIndex;
@property (nonatomic, copy) NSArray *errorCharacters;

@property (nonatomic, strong) YXGameAnswer *answerRecord;
@end


@interface YXGameDetailModel : NSObject
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, strong) YXGameConfig *gameConf;
@property (nonatomic, strong) NSMutableArray *gameContent;
@end

