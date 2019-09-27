//
//  NSArray+additions.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YR)

- (id)filterNullObject;
- (id)filterNullObject:(BOOL)allowNilResult;
- (id)filterEmptyString;
- (id)filterEmptyString:(BOOL)allowNilResult;

@end
