//
//  YXBookWordsModel.h
//  YXEDU
//
//  Created by yao on 2019/2/26.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXMyWordCellBaseModel.h"


NS_ASSUME_NONNULL_BEGIN
@interface YXSelectWordCellModel : YXMyWordCellBaseModel
@property (nonatomic, copy) NSString *occorDesc;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@end

@interface YXBookUnitContentModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *words;

@property (nonatomic, assign) NSInteger unitSelectedWordsCount;
@property (nonatomic, assign, getter = isSelected) BOOL selected;
@property (nonatomic, strong) NSMutableArray *unitSelectedWords;
@property (nonatomic, copy) NSArray *unitWordIds;

- (YXSelectWordCellModel *)quarySelectWordCellModelWith:(NSString *)wordId;
- (void)updateUnitSelectedWordCountWithDeltaNum:(NSInteger)delta;
- (void)updateUnitWordStateOf:(NSString *)wordId selectedState:(BOOL)isSelected;
- (void)addSelectWordCellModel:(YXSelectWordCellModel *)selectWordCellModel;
@end


@interface YXBookContentModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *content;

@property (nonatomic, assign) BOOL hasQuaryWordInfo;
@property (nonatomic, assign) NSInteger bookSelectedWordsCount;

@property (nonatomic, copy) NSArray *bookWordIds;

@property (nonatomic, readonly, strong) YXBookUnitContentModel *searchUnitModel;
- (void)updateBookSelectedWordCountAtUnit:(NSInteger)unitIndex withDeltaNum:(NSInteger)delta;
- (YXSelectWordCellModel *)quarySelectWordCellModelWith:(NSString *)wordId;
- (void)updateBookWordStateOf:(NSString *)wordId selectedState:(BOOL)isSelected;
- (NSIndexPath *)indexPathOfWordId:(NSString *)wordId;
- (void)selectedResultBookAddWord:(YXSelectWordCellModel *)selectWordCellModel;// 1个unit
@end



@interface YXBookCategoryModel : NSObject  // 词书 词单 (全部)
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSMutableArray *content;
@property (nonatomic, copy) NSArray *bookIds;
@end

NS_ASSUME_NONNULL_END
