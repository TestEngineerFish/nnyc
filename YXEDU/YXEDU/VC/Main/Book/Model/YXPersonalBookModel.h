//
//  YXPersonalBookModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXBookModel.h"



@interface YXPersonalBookModel : NSObject<NSCoding>
@property (nonatomic, strong) NSArray<YXBookModel *>* booklist;
@end
