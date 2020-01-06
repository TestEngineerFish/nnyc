//
//  YXCalendarStudyDayData.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarStudyDayData.h"
#import "YXWordModelManager.h"

@implementation YXCalendarCellModel

@end

@implementation YXCalendarWordsModel
@end

@implementation YXCalendarNewBookModel

+ (NSDictionary *)mj_objectClassInArray {
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

- (YXCalendarLearningModel *)learning_data {
    if (!_learning_data) {
        _learning_data = [[YXCalendarLearningModel alloc] init];
    }
    return _learning_data;
}

- (NSMutableArray<YXCalendarCellModel *> *)reviewCellList {
    if (!_reviewCellList) {
        NSMutableArray<YXCalendarCellModel *> *tmpArray = [[NSMutableArray alloc] init];
        for (YXCalendarNewBookModel *bookModel in self.learning_data.review_words) {
            NSString *bookName = bookModel.book_name;
            YXCalendarCellModel *headerModel = [[YXCalendarCellModel alloc] init];
            headerModel.isWord    = NO;
            headerModel.title     = bookName;
            headerModel.descValue = [NSString stringWithFormat:@"%lu", bookModel.words.count];
            // add
            [tmpArray addObject:headerModel];
            for (YXCalendarWordsModel *wordModel in bookModel.words) {
                YXCalendarCellModel *cellModel = [[YXCalendarCellModel alloc] init];
                cellModel.isWord    = YES;
                cellModel.title     = wordModel.word;
                cellModel.word_id   = wordModel.word_id;
                cellModel.descValue = [NSString stringWithFormat:@"%@%@", wordModel.word_property, wordModel.paraphrase];
                // add
                [tmpArray addObject:cellModel];
            }
        }
        _reviewCellList = tmpArray;
    }
    return _reviewCellList;
}

- (NSMutableArray<YXCalendarCellModel *> *)studiedCellList {
    if (!_studiedCellList) {
        NSMutableArray<YXCalendarCellModel *> *tmpArray = [[NSMutableArray alloc] init];
        for (YXCalendarNewBookModel *bookModel in self.learning_data.study_words) {
            NSString *bookName = bookModel.book_name;
            YXCalendarCellModel *headerModel = [[YXCalendarCellModel alloc] init];
            headerModel.isWord    = NO;
            headerModel.title     = bookName;
            headerModel.descValue = [NSString stringWithFormat:@"%lu", bookModel.words.count];
            // add
            [tmpArray addObject:headerModel];
            for (YXCalendarWordsModel *wordModel in bookModel.words) {
                YXCalendarCellModel *cellModel = [[YXCalendarCellModel alloc] init];
                cellModel.isWord    = YES;
                cellModel.title     = wordModel.word;
                cellModel.word_id   = wordModel.word_id;
                cellModel.descValue = [NSString stringWithFormat:@"%@%@", wordModel.word_property, wordModel.paraphrase];
                // add
                [tmpArray addObject:cellModel];
            }
        }
        _studiedCellList = tmpArray;
    }
    return _studiedCellList;
}
@end
