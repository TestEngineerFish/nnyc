//
//  YXMyWordBookDetailVC.h
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookBaseVC.h"
#import "YXMyWordBookModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXMyWordBookDetailVC : YXMyWordBookBaseVC
@property (nonatomic, strong) YXMyWordBookModel *myWordBookModel;
@property (nonatomic, assign) BOOL isOwnWordList;
- (instancetype)initWithMyWordBookModel:(YXMyWordBookModel *)myWordBookModel;
@end

NS_ASSUME_NONNULL_END
