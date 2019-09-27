//
//  YXMainModel.h
//  YXEDU
//
//  Created by shiji on 2018/9/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartsData : NSObject
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *num;
@end

//"bookid":"1",
//"book_name":"人教版七年级上册",
//"remain_day":"20",   //剩余学习天数
//"word_plan":"20",   //今日待学习单词数
//"learned":"100",    //本词书已经学完的单词数
//"word_count":"1000", //词书总得单词数
//"review_plan":"40",  //待复习单词数
@interface Note_Index : NSObject
@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *book_name;
@property (nonatomic, strong) NSString *remain_day;
@property (nonatomic, strong) NSString *word_plan;
@property (nonatomic, strong) NSString *learned;
@property (nonatomic, strong) NSString *word_count;
@property (nonatomic, strong) NSString *review_plan;
@property (nonatomic, strong) NSString *plan_num;
@end

//"fav":"30",   //收藏单词个数
//"wrong":"40", //错词本个数
//"learned":"50"  //已学单词个数
@interface Note_Record : NSObject
@property (nonatomic, strong) NSString *fav;
@property (nonatomic, strong) NSString *wrong;
@property (nonatomic, strong) NSString *learned;
@end

@interface Note_Charts : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray <ChartsData *>*data;
@end

@interface YXNoteIndex : NSObject
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSString *remainDay;
//@property (nonatomic, strong) NSString *word_plan;
@property (nonatomic, copy) NSString *learned;
@property (nonatomic, copy) NSString *wordCount;
/** 复习单词 */
@property (nonatomic, copy) NSString *reviewPlan;
/** 学习计划数 */
@property (nonatomic, copy) NSString *planNum;
/** 今日要学习剩余单词 */
@property (nonatomic, copy)NSString *planRemain;

@end

@interface YXNoteRecord : NSObject
@property (nonatomic, copy) NSString *fav;
@property (nonatomic, copy) NSString *wrong;
@property (nonatomic, copy) NSString *learned;
@end


@interface YXNoteCharts : NSObject
@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy)NSString *dateStr;
@end

@interface YXMainModel : NSObject
@property (nonatomic, strong) Note_Index *note_index;
@property (nonatomic, strong) Note_Record *note_record;
@property (nonatomic, strong) Note_Charts *note_charts;

@property (nonatomic, strong) YXNoteIndex *noteIndex;
@property (nonatomic, strong) YXNoteRecord *noteRecord;
@property (nonatomic, strong) NSArray *noteCharts;

/** 当前这本书是否已经学完 */
@property (nonatomic, assign)BOOL bookFinished;
@end

//noteCharts =     (
//                  {
//                      date = 1539705600;
//                      num = 0;
//                  }
//                  );
//
//noteRecord =     {
//    fav = 0;
//    learned = 0;
//    wrong = 0;
//    };
