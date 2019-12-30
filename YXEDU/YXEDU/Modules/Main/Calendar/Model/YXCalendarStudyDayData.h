//
//  YXCalendarStudyDayData.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXWordDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

//最终使用的Model
@interface YXCalendarCellModel : NSObject
@property (nonatomic, strong, nullable) YXWordDetailModel *wordModel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descValue;
@property (nonatomic, assign) BOOL isWord;
@end

@interface YXCalendarWordsModel : NSObject
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *word_property;
@property (nonatomic, strong) NSString *paraphrase;
@end

@interface YXCalendarNewBookModel : NSObject
@property (nonatomic, strong) NSString *book_name;
@property (nonatomic, strong) NSArray<YXCalendarWordsModel *> *words;
@end

@interface YXCalendarLearningModel : NSObject
@property (nonatomic, strong) NSMutableArray<YXCalendarNewBookModel *> *review_words;
@property (nonatomic, strong) NSMutableArray<YXCalendarNewBookModel *> *study_words;
@property (nonatomic, assign) NSInteger study_times;
@end

@interface YXCalendarStudyDayData : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) YXCalendarLearningModel *learning_data;

@property (nonatomic, strong) NSMutableArray<YXCalendarCellModel *> *reviewCellList;//最终需要展示的数据
@property (nonatomic, strong) NSMutableArray<YXCalendarCellModel *> *studiedCellList;//最终需要展示的数据
@property (nonatomic, assign) BOOL showReviewList;
@property (nonatomic, assign) BOOL showStudiedList;
//- (void)setupData;
@end


NS_ASSUME_NONNULL_END
