//
//  NSObject+YR.h
//  YRUtils
//
//  Created by shiji on 2018/3/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (YR)
+ (id)yrModelWithJSON:(id)json;
- (NSString *)yrModelToJSONString;
- (id)yrModelToDictionary;
@end
