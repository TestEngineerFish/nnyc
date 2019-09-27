//
//  YXMyWordBookModel.h
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXMyWordBookModel : NSObject
@property (nonatomic, copy) NSString *wordListName;
@property (nonatomic, copy) NSString *wordListId;
@property (nonatomic, copy) NSString *sharingPerson;
//@property (nonatomic, copy) NSString *words;
@property (nonatomic, copy) NSString *shareCode;
@property (nonatomic, copy) NSString *descShareCode;

@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger finishLearnTime;
@property (nonatomic, assign) NSInteger finishListenTime;
/** 学习流程的状态  1是未开始，2是继续，3是完成 */
@property (nonatomic, assign) NSInteger learnState;
@property (nonatomic, assign) NSInteger listenState;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger listen;
@property (nonatomic, assign) NSInteger learn;


/** 词单详情页跳转报告页 */
@property (nonatomic, copy) NSString *learnReportPage;


@property (nonatomic, copy) NSString *descString;
@property (nonatomic, copy) NSString *studyStateString;
@property (nonatomic, copy) NSString *listenStateString;
@property (nonatomic, copy) NSString *createDateDesc;
@property (nonatomic, copy) NSString *finishLearnDateDesc;
@property (nonatomic, copy) NSString *finishListenDateDesc;
@property (nonatomic, copy) NSString *sharingPersonDesc;

//词单是否处于编辑状态
@property (nonatomic, assign) BOOL isEditing;

@end

NS_ASSUME_NONNULL_END
/**
 "wordListName":"生龙活虎",
 "wordListId":1,
 "sharingPerson":"隔壁大爷", //为空，则表示自己创建
 "words": "2|4|4|5|5|6",  //词单单词
 "shareCode": "NNMLF03B215EB8DFF2D4", //分享码
 "createTime":"1465983112",
 "finishLearnTime":"", //完成学习时间
 "finishListenTime":"",  //完成听写时间
 "learnState":1,     //当前学习状态，1未开始学习，2表示未学完，3表示已经学完
 "listenState":1, //当前听写状态 ,1未开始听写，2表示未学完，3听写完成
 "total":32,
 "listen":23,
 "learn":24
 */
