//
//  NSString+Router.m
//  pyyx
//
//  Created by sunwu on 2017/10/13.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import "NSString+Router.h"

@implementation NSString (Router)

- (NSDictionary *)params {
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    if (NSNotFound != [self rangeOfString:@"?"].location) {
        NSString *paramString = [self substringFromIndex:([self rangeOfString:@"?"].location + 1)];
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString* key = [[kvPair objectAtIndex:0] stringByRemovingPercentEncoding];
                NSString* value = [[kvPair objectAtIndex:1] stringByRemovingPercentEncoding];
                [pairs setValue:value forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@end
