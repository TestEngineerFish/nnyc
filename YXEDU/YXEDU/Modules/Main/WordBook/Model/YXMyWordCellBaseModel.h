//
//  YXMyWordCellBaseModel.h
//  YXEDU
//
//  Created by yao on 2019/2/26.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXWordDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXMyWordCellBaseModel : NSObject
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, strong) YXWordDetailModel *wordDetail;

/** 选择词书页面用到 */
@property (nonatomic, copy) NSString *wordId;

@property (nonatomic, assign) BOOL isSearch;

@end

NS_ASSUME_NONNULL_END
