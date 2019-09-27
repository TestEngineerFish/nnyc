//
//  YXBookCateModel.h
//  YXEDU
//
//  Created by yao on 2018/11/28.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBookInfoModel.h"
@interface YXBookCateModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)NSMutableArray<YXBookInfoModel *> *options;
@end

