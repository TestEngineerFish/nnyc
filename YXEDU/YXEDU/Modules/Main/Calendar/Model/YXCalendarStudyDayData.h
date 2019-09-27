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
@interface YXCalendarBookModel : NSObject
@property (nonatomic, strong, nullable) YXWordDetailModel *wordModel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descValue;
@property (nonatomic, assign) BOOL isWork;
@end

@interface YXCalendarWordsModel : NSObject
@property (nonatomic, assign) NSInteger book_id;
@property (nonatomic, copy) NSArray *wordIds;
@end

@interface YXCalendarLearningModel : NSObject
@property (nonatomic, strong) NSMutableArray<YXCalendarWordsModel *> *reviewWords;
@property (nonatomic, strong) NSMutableArray<YXCalendarWordsModel *> *studyWords;
@property (nonatomic, copy) NSString *studyTimes;
@end

@interface YXCalendarStudyDayData : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) YXCalendarLearningModel *learningData;
@property (nonatomic, strong) NSMutableArray<YXCalendarBookModel *> *reviewBooksList;//最终需要展示的数据
@property (nonatomic, strong) NSMutableArray<YXCalendarBookModel *> *studiedBooksList;//最终需要展示的数据
@property (nonatomic, assign) BOOL showReviewList;
@property (nonatomic, assign) BOOL showStudiedList;
//- (void)setupData;
@end


NS_ASSUME_NONNULL_END
