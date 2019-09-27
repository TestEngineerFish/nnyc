//
//  YXCareerBigNaviModel.h
//  YXEDU
//
//  Created by yixue on 2019/2/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCareerModel : NSObject

- (id)initWithItem:(NSString *)item bookId:(NSInteger)bookId sort:(NSInteger)sort;

@property (nonatomic, copy) NSString *item;
@property (nonatomic, assign) NSInteger bookId;
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, copy) NSString *bookName;
@property (nonatomic, copy) NSArray *itemTitles;

@end

NS_ASSUME_NONNULL_END
