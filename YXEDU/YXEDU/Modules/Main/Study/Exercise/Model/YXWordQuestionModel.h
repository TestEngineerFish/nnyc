//
//  YXWordQuestionModel.h
//  YXEDU
//
//  Created by yao on 2018/10/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
//"wordId":"1",
//"speakStatus":2,   //口语题是否进行  1，表示未开始，2表示已完成，3表示取消
//"end":false,   // 本单词是否结束    false 未结束   true结束
//"bookId":"1",
//"question":{
//    "questionId":"1",
//    "type":"2",
//    "options":["下午","好的","怎样；如何","英国广播公司"],
//    "answer":"2",
//    "tip":"1",
//
//}



//if ([questionType isEqualToString:@"2"]) { // 根据单词选词义
//
//    YXENTranCHChoiceView *view = [[YXENTranCHChoiceView alloc] initWithFrame:questionFrame];
//    [self.questionAreaView addSubview:view];
//
//    view.wordQuestionModel = wordQuestion;
//
//    [view reloadData];
//
//} else if ([questionType isEqualToString:@"3"]) { // 根据词义选单词
//
//} else if ([questionType isEqualToString:@"4"]) { // 根据词义全拼
//
//} else if ([questionType isEqualToString:@"5"]) { // 单词的部分拼写
//
//} else if ([questionType isEqualToString:@"6"]) { // 听发音部分拼写
//
//} else if ([questionType isEqualToString:@"7"]) { // 听发音全拼
//
//} else if ([questionType isEqualToString:@"8"]) { // 例句挖空

    
typedef NS_ENUM(NSUInteger, YXQuestionType) {
    YXQuestionEngTransCh = 2,    // 2  英译汉
    YXQuestionChTransEng,        // 3  汉译英
    YXQuestionChToFullSpell,     // 4  根据词义全拼
    YXQuestionChToPartSpell,     // 5  根据词义部分拼写
    YXQuestionPronuncePartSpell, // 6  根据发音部分拼写
    YXQuestionPronunceFullSpell, // 7  根据发音全拼
    YXQuestionFillBlankWord,     // 8  例句挖空
    YXQuestionSelectPartLetters, // 9  选择字母部分拼写
    YXQuestionSelectFullLetters  // 10 选择字母全拼写
};

#import "YXWordDetailModel.h"

@interface YXQuestionModel : NSObject
@property (nonatomic, copy) NSString *tip;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSArray *options;
@property (nonatomic, assign) YXQuestionType type;
@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSArray *allOptions;
//@property (nonatomic, assign)YXQuestionType questionType;
@end



@interface YXWordQuestionModel : NSObject
@property (nonatomic, copy) NSString *wordId;
@property (nonatomic, copy) NSString *speakStatus;
@property (nonatomic, assign) BOOL end;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, strong)YXQuestionModel *question;
@property (nonatomic, strong)YXWordDetailModel *wordDetail;
@property (nonatomic, assign) NSInteger answeredCount;
@end

