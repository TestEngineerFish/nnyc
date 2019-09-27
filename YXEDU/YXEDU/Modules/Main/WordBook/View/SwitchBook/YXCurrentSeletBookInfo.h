//
//  YXCurrentSeletBookInfo.h
//  YXEDU
//
//  Created by yao on 2019/2/27.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YXBookCategoryType) {
    YXBookCategoryNormalBook = 0,
    YXBookCategoryWordList
};

@interface YXCurrentSeletBookInfo : NSObject
@property (nonatomic, assign) YXBookCategoryType bookCategoryType;
@property (nonatomic, assign) NSInteger categoryBookIndex;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *bookName;
@end

NS_ASSUME_NONNULL_END
