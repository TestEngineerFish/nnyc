//
//  YXSpokenResultModel.h
//  YXEDU
//
//  Created by yao on 2018/11/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXSpokenSymbolModel :NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *type;
@end

@interface YXSpokenResultModel : NSObject
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSMutableArray *details;
@property (nonatomic, strong) NSAttributedString *symbolAttri;
@end
