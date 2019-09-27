//
//  YXGameAnswer.h
//  YXEDU
//
//  Created by yao on 2019/1/3.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YXGameAnswer : NSObject
@property (nonatomic, copy) NSString *encryptKey;
@property (nonatomic, assign) NSInteger wordId; ;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *nature;
@property (nonatomic, copy) NSString *answer;
@end
