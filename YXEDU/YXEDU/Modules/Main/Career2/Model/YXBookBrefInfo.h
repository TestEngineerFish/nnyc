//
//  YXBookBrefInfo.h
//  YXEDU
//
//  Created by yao on 2018/11/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXBookBrefInfo : NSObject
@property (nonatomic, copy)NSString *wordNum;
@property (nonatomic, copy)NSString *bookId;
@property (nonatomic, copy)NSString *bookName;

- (instancetype)initWithBookId:(NSString *)bookId bookName:(NSString *)bookName wordNum:(NSString *)wordNum;
@end


