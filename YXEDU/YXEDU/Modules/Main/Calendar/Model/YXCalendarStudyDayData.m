//
//  YXCalendarStudyDayData.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarStudyDayData.h"
#import "YXWordModelManager.h"

@implementation YXCalendarBookModel

@end

@implementation YXCalendarWordsModel
@end

@implementation YXCalendarNewBookModel

+(NSDictionary *)mj_objectClassInArray {
    return @{
        @"words" : [YXCalendarWordsModel class]
    };
}

@end

@implementation YXCalendarLearningModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"review_words" : [YXCalendarNewBookModel class],
             @"study_words"  : [YXCalendarNewBookModel class]
             };
}
@end


@implementation YXCalendarStudyDayData

- (NSMutableArray<YXCalendarBookModel *> *)reviewBooksList {
    if (!_reviewBooksList) {
        NSMutableArray<YXCalendarBookModel *> *tmpArray = [[NSMutableArray alloc] init];
//        for (YXCalendarWordsModel *model in self.learning_data.review_words) {
//            NSString *bookIdStr = [NSString stringWithFormat:@"%zd", model.book_id];
//            NSString *bookName = [[YXConfigure shared].confModel getBookNameWithId:bookIdStr];
//            [YXWordModelManager quardWithWordIds:model.wordIds completeBlock:^(id obj, BOOL result) {
//                if (result) {
//                    NSArray<YXWordDetailModel *> *wordsList = obj;//词单列表
//                    YXCalendarBookModel *bookModel = [[YXCalendarBookModel alloc] init];
//                    bookModel.title = bookName;
//                    bookModel.descValue = [NSString stringWithFormat: @"%zu", wordsList.count];
//                    bookModel.isWork = NO;
//                    bookModel.wordModel = nil;
//                    [tmpArray addObject:bookModel];
//                    for (YXWordDetailModel *wordModel in wordsList) {
//                        wordModel.bookId = [NSString stringWithFormat:@"%zd", model.book_id];
//                        YXCalendarBookModel *bookModel = [[YXCalendarBookModel alloc] init];
//                        bookModel.title = wordModel.word;
//                        bookModel.descValue = wordModel.explainText;
//                        bookModel.isWork = YES;
//                        bookModel.wordModel = wordModel;
//                        [tmpArray addObject:bookModel];
//                    }
//                } else {
//                    NSLog(@"查询数据失败");
//                }
//            }];
//        }
        _reviewBooksList = tmpArray;
    }
    return _reviewBooksList;
}

- (NSMutableArray<YXCalendarBookModel *> *)studiedBooksList {
    if (!_studiedBooksList) {
        NSMutableArray<YXCalendarBookModel *> *tmpArray = [[NSMutableArray alloc] init];
//        for (YXCalendarWordsModel *model in self.learning_data.study_words) {
//            NSString *bookIdStr = [NSString stringWithFormat:@"%zd", model.word_id];
//            NSString *bookName = [[YXConfigure shared].confModel getBookNameWithId:bookIdStr];
//            [YXWordModelManager quardWithWordIds:model.wordIds completeBlock:^(id obj, BOOL result) {
//                if (result) {
//                    NSArray<YXWordDetailModel *> *wordsList = obj;//词单列表
//                    YXCalendarBookModel *bookModel = [[YXCalendarBookModel alloc] init];
//                    bookModel.title = bookName;
//                    bookModel.descValue = [NSString stringWithFormat: @"%lu", wordsList.count];
//                    bookModel.isWork = NO;
//                    bookModel.wordModel = nil;
//                    [tmpArray addObject:bookModel];
//
//                    for (YXWordDetailModel *wordModel in wordsList) {
//                        wordModel.bookId = [NSString stringWithFormat:@"%zd", model.book_id];
//                        YXCalendarBookModel *bookModel = [[YXCalendarBookModel alloc] init];
//                        bookModel.title = wordModel.word;
//                        bookModel.descValue = wordModel.explainText;
//                        bookModel.isWork = YES;
//                        bookModel.wordModel = wordModel;
//                        [tmpArray addObject:bookModel];
//                    }
//                } else {
//                    NSLog(@"查询数据失败");
//                }
//            }];
//        }
        _studiedBooksList = tmpArray;
    }
    return _studiedBooksList;
}
@end
