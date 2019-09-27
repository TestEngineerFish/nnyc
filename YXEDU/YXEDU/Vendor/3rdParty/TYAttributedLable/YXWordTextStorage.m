//
//  YXWordTextStorage.m
//  AttributedDemo
//
//  Created by 沙庭宇 on 2019/5/24.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import "YXWordTextStorage.h"

@implementation YXWordTextStorage

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - protocol

- (void)addTextStorageWithAttributedString:(NSMutableAttributedString *)attributedString
{
    [super addTextStorageWithAttributedString:attributedString];
    [attributedString addAttribute:kTYTextLongPressRunAttributedName value:self range:self.range];
    self.text = [attributedString.string substringWithRange:self.range];

}

@end
