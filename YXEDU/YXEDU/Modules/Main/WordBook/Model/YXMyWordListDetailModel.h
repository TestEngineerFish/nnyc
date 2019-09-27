//
//  YXMyWordListDetailModel.h
//  YXEDU
//
//  Created by yao on 2019/2/26.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXMyWordBookModel.h"
#import "YXMyWordListCellModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface YXMyWordListDetailModel : YXMyWordBookModel
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, copy)  NSArray* words;
@property (nonatomic, copy) NSArray *markTexts;
@property (nonatomic, assign) NSInteger code;
@end

NS_ASSUME_NONNULL_END
