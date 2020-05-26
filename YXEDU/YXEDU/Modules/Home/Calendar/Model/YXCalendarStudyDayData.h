//
//  YXCalendarStudyDayData.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//最终使用的Model
@interface YXCalendarCellModel : NSObject
@property (nonatomic, assign) NSInteger word_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descValue;
@property (nonatomic, assign) BOOL isWord;
@end

@interface YXCalendarWordsModel : NSObject
@property (nonatomic, strong) NSString *word;
@property (nonatomic, assign) NSInteger word_id;
@property (nonatomic, strong) NSArray *paraphrase;
@property (nonatomic, strong) NSString *voice_us;
@property (nonatomic, strong) NSString *voice_uk;
@property (nonatomic, strong) NSString *is_synthesis;
@property (nonatomic, strong) NSString *descValue;
@end

@interface YXCalendarNewBookModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray<YXCalendarWordsModel *> *word_list;
@end

@interface YXCalendarStudyDayData : NSObject
@property (nonatomic, assign) NSNumber *date;
@property (nonatomic, assign) NSInteger study_duration;
@property (nonatomic, strong) NSMutableArray<YXCalendarNewBookModel *> *review_item;
@property (nonatomic, strong) NSMutableArray<YXCalendarNewBookModel *> *study_item;

@property (nonatomic, strong) NSMutableArray<YXCalendarCellModel *> *reviewCellList;//最终需要展示的数据
@property (nonatomic, strong) NSMutableArray<YXCalendarCellModel *> *studiedCellList;//最终需要展示的数据
@property (nonatomic, assign) BOOL showReviewList;
@property (nonatomic, assign) BOOL showStudiedList;
@end


NS_ASSUME_NONNULL_END
