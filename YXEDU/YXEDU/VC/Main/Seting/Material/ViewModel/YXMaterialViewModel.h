//
//  YXMaterialViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"

@interface YXMaterialViewModel : NSObject
- (void)requestAllDB:(finishBlock)block;
- (id)model:(NSInteger)idx;
- (NSInteger)getAllSize;
- (NSInteger)rowCount;
- (void)deleteDB:(NSInteger)idx
        finished:(finishBlock)block;
- (void)deleteAll:(finishBlock)block;
@end
