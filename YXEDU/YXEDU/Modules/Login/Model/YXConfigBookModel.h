//
//  YXConfigBookModel.h
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXConfigBookModel : NSObject //YXConfigBookModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *wordCount;
@property (nonatomic,readonly, assign,getter=isLearning)  BOOL learning;
@property (nonatomic, assign) BOOL isSetSuccess;
@end
