//
//  YXCalendarStudyDayData.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarStudyDayData.h"

@implementation YXCalendarCellModel

@end

@implementation YXCalendarWordsModel

- (NSString *)descValue {
    YXSummaryItemsWordPartOfSpeechAndMeaningModel *firstParaphrase = self.paraphrase.firstObject;
    NSString *key = firstParaphrase.partOfSpeech;
    NSString *value = firstParaphrase.meaning;
    return [NSString stringWithFormat:@"%@%@", key, value];
}
@end

@implementation YXCalendarNewBookModel

- (NSMutableArray<YXCalendarWordsModel *> *)word_list {
    if (!_word_list) {
        _word_list = [[NSMutableArray alloc] init];
    }
    return _word_list;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"word_list" : [YXCalendarWordsModel class]
    };
}

@end


@implementation YXCalendarStudyDayData

- (NSMutableArray<YXCalendarNewBookModel *> *)review_item {
    if (!_review_item) {
        _review_item = [[NSMutableArray alloc] init];
    }
    return _review_item;
}

- (NSMutableArray<YXCalendarNewBookModel *> *)study_item {
    if (!_study_item) {
        _study_item = [[NSMutableArray alloc] init];
    }
    return _study_item;
}

+(NSDictionary *)mj_objectClassInArray {
return @{
         @"review_item" : [YXCalendarNewBookModel class],
         @"study_item"  : [YXCalendarNewBookModel class]
         };
}

- (NSMutableArray<YXCalendarCellModel *> *)reviewCellList {
    if (!_reviewCellList) {
        NSMutableArray<YXCalendarCellModel *> *tmpArray = [[NSMutableArray alloc] init];
        for (YXCalendarNewBookModel *bookModel in self.review_item) {
            NSString *bookName = bookModel.name;
            YXCalendarCellModel *headerModel = [[YXCalendarCellModel alloc] init];
            headerModel.isWord    = NO;
            headerModel.title     = bookName;
            headerModel.descValue = [NSString stringWithFormat:@"%lu", bookModel.word_list.count];
            // add
            [tmpArray addObject:headerModel];
            for (YXCalendarWordsModel *wordModel in bookModel.word_list) {
                YXCalendarCellModel *cellModel = [[YXCalendarCellModel alloc] init];
                cellModel.isWord    = YES;
                cellModel.title     = wordModel.word;
                cellModel.word_id   = wordModel.word_id;
                cellModel.descValue = wordModel.descValue;
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
        for (YXCalendarNewBookModel *bookModel in self.study_item) {
            NSString *bookName = bookModel.name;
            YXCalendarCellModel *headerModel = [[YXCalendarCellModel alloc] init];
            headerModel.isWord    = NO;
            headerModel.title     = bookName;
            headerModel.descValue = [NSString stringWithFormat:@"%lu", bookModel.word_list.count];
            // add
            [tmpArray addObject:headerModel];
            for (YXCalendarWordsModel *wordModel in bookModel.word_list) {
                YXCalendarCellModel *cellModel = [[YXCalendarCellModel alloc] init];
                cellModel.isWord    = YES;
                cellModel.title     = wordModel.word;
                cellModel.word_id   = wordModel.word_id;
                cellModel.descValue = wordModel.descValue;
                // add
                [tmpArray addObject:cellModel];
            }
        }
        _studiedCellList = tmpArray;
    }
    return _studiedCellList;
}
@end
