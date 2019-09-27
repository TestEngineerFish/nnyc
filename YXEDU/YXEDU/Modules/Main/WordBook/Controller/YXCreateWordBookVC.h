//
//  YXCreateWordBookVC.h
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookBaseVC.h"
#import "YXBookBrefInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCreateWordBookVC : YXMyWordBookBaseVC
@property (nonatomic, strong) YXBookBrefInfo *curBookBrefInf;
@property (nonatomic, assign) NSInteger numOfNextList;
@property (nonatomic, copy) void(^saveWordListSuccessBlock)(void);
@property (nonatomic, assign) NSInteger wordListMaxWordLimited;
@end

NS_ASSUME_NONNULL_END
