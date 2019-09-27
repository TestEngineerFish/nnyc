//
//  YXGameAnswerModel.h
//  YXEDU
//
//  Created by yao on 2019/1/3.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXGameAnswer.h"
//"gameId":1  //游戏id
//"startTime":1465983112, //游戏开始时间
//"preloadTime":8,//引加导载时间
//"endTime":1465993112，//游戏结束时间
//"lastTime":34，//最后一个单词答对后的剩余时间
//"times":12,

//@interface YXGameAnswer : NSObject
//@property (nonatomic, copy) NSString *encryptKey;
//@property (nonatomic, assign) NSInteger wordId; ;
//@property (nonatomic, copy) NSString *word;
//@property (nonatomic, copy) NSString *nature;
//@property (nonatomic, copy) NSString *answer;
//@end

@interface YXGameAnswerModel : NSObject
@property (nonatomic, assign) NSInteger gameId;
@property (nonatomic, assign) NSInteger startTime;
/** 游戏次数*/
@property (nonatomic, assign) NSInteger times;
/** 引加导载时间 */
@property (nonatomic, assign) NSInteger preloadTime;
@property (nonatomic, assign) NSInteger endTime;
/** 最后一个单词答对后的剩余时间 */
@property (nonatomic, assign) NSInteger lastTime;
@property (nonatomic, strong) NSMutableArray *gameContent;
@end

