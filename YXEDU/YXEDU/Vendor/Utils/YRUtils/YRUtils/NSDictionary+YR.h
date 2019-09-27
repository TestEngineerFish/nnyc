//
//  NSDictionary+addition.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YR)

/*
 * dictionaryToJsonString 接口已经废弃，调用新接口 formatToJSON
 */
- (NSString *)dictionaryToJsonString DEPRECATED_ATTRIBUTE;
- (NSString *)formatToJSON;
- (id)filterNullObject;
- (id)filterNullObject:(BOOL)allowNilResult;
- (id)filterEmptyString;
- (id)filterEmptyString:(BOOL)allowNilResult;
@end
