//
//  YXBookWordsModel.m
//  YXEDU
//
//  Created by yao on 2019/2/26.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXBookCategoryModel.h"

@implementation YXSelectWordCellModel

@end

@implementation YXBookUnitContentModel
- (instancetype)init {
    if (self = [super init]) {
        self.selected = NO;
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"words" : [YXSelectWordCellModel class]
             };
}

- (NSMutableArray *)unitSelectedWords {
    if (!_unitSelectedWords) {
        _unitSelectedWords = [NSMutableArray array];
    }
    return _unitSelectedWords;
}

- (NSArray *)unitWordIds {
    if (!_unitWordIds) {
        _unitWordIds = [self.words valueForKeyPath:@"wordId"];
    }
    return _unitWordIds;
}

- (void)updateUnitSelectedWordCountWithDeltaNum:(NSInteger)delta {
    self.unitSelectedWordsCount += delta;
}

- (void)updateUnitWordStateOf:(NSString *)wordId selectedState:(BOOL)isSelected {
    self.unitSelectedWordsCount += (isSelected ? 1 : -1);
    YXSelectWordCellModel *selectWordCellModel = [self quarySelectWordCellModelWith:wordId];
    selectWordCellModel.selected = isSelected;
}

- (YXSelectWordCellModel *)quarySelectWordCellModelWith:(NSString *)wordId {
    NSInteger index = [self.unitWordIds indexOfObject:wordId];
    if (index != NSNotFound) {
        return [self.words objectAtIndex:index];
    }else {
        return nil;
    }
}

- (void)addSelectWordCellModel:(YXSelectWordCellModel *)selectWordCellModel {
    [self.words addObject:selectWordCellModel];
    _unitWordIds = nil;
}
@end



@implementation YXBookContentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"content" : [YXBookUnitContentModel class]
             };
}

- (YXBookUnitContentModel *)searchUnitModel {
    return self.content.firstObject;
}

- (YXSelectWordCellModel *)quarySelectWordCellModelWith:(NSString *)wordId {
    YXSelectWordCellModel *selectWordCellModel = nil;
    for (YXBookUnitContentModel *unitModel in self.content) {
        if ([unitModel.unitWordIds containsObject:wordId]) {
            selectWordCellModel = [unitModel quarySelectWordCellModelWith:wordId];
            break;
//            NSInteger index = [unitModel.unitWordIds indexOfObject:wordId];
//            selectWordCellModel = [unitModel.words objectAtIndex:index];
        }
    }
    return selectWordCellModel;
}

- (NSArray *)bookWordIds {
    if (!_bookWordIds) {
        NSMutableArray *bookWordIds = [NSMutableArray array];
        for (YXBookUnitContentModel *unitModel in self.content) {
            [bookWordIds addObjectsFromArray:unitModel.unitWordIds];
        }
        _bookWordIds = [bookWordIds copy];
    }
    return _bookWordIds;
}

-(void)updateBookSelectedWordCountAtUnit:(NSInteger)unitIndex withDeltaNum:(NSInteger)delta {
    self.bookSelectedWordsCount += delta;
    YXBookUnitContentModel *unitModel = [self.content objectAtIndex:unitIndex];
    [unitModel updateUnitSelectedWordCountWithDeltaNum:delta];
}

- (void)updateBookWordStateOf:(NSString *)wordId selectedState:(BOOL)isSelected {
    self.bookSelectedWordsCount += (isSelected ? 1 : -1);
    for (YXBookUnitContentModel *unitModel in self.content) {
        if ([unitModel.unitWordIds containsObject:wordId]) {
            [unitModel updateUnitWordStateOf:wordId selectedState:isSelected];
            break;
        }
    }
}

- (NSIndexPath *)indexPathOfWordId:(NSString *)wordId {
    NSIndexPath *indexPath = nil;
    for (YXBookUnitContentModel *unitModel in self.content) {
        if ([unitModel.unitWordIds containsObject:wordId]) {
            NSInteger row = [unitModel.unitWordIds indexOfObject:wordId];
            NSInteger section = [self.content indexOfObject:unitModel];
            indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            break;
        }
    }
    return indexPath;
}

- (void)selectedResultBookAddWord:(YXSelectWordCellModel *)selectWordCellModel {
    [self.searchUnitModel addSelectWordCellModel:selectWordCellModel];
    _bookWordIds = nil;
}
@end



@implementation YXBookCategoryModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"content" : [YXBookContentModel class]
             };
}

- (NSArray *)bookIds {
    if (!_bookIds) {
        _bookIds = [self.content valueForKeyPath:@"ID"];
    }
    return _bookIds;
}
@end
