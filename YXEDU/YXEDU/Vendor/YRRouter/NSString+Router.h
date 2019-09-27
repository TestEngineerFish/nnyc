//
//  NSString+Router.h
//  pyyx
//
//  Created by sunwu on 2017/10/13.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Router)

/**
 * URL中所有的参数转换成字典，例如xxx.com/abc?p1=value1&p2=value2，转换成{p1 : value1, p2 = value2}
 */
- (NSDictionary *)params;

@end
