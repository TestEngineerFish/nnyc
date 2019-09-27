//
//  YXBookSettingViewController.h
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXBaseTransAnimateViewController.h"
#import "YXBookInfoModel.h"

@interface YXBookSettingViewController : YXBaseTransAnimateViewController
@property (nonatomic, strong)YXBookInfoModel *bookModel;
@property (nonatomic, copy) void(^setPlanSuccessBlock)(NSString *bookId);
@property (nonatomic, assign) BOOL isFirstLogin;
- (instancetype)initWith:(YXBookInfoModel *)bookModel
     setPlanSuccessBlock:(void(^)(NSString *bookId))setPlanSuccessBlock;
@end

