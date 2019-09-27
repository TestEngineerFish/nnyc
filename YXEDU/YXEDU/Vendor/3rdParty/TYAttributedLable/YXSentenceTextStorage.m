//
//  YXSentenceTextStorage.m
//  AttributedDemo
//
//  Created by 沙庭宇 on 2019/5/25.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

#import "YXSentenceTextStorage.h"

@implementation YXSentenceTextStorage


#pragma mark - protocol

- (void)addTextStorageWithAttributedString:(NSMutableAttributedString *)attributedString
{
    [super addTextStorageWithAttributedString:attributedString];
    [attributedString addAttribute:kTYTextClickRunAttributedName value:self range:self.range];
    [attributedString addAttributeTextColor:self.textColor range:self.range];
    self.text = [attributedString.string substringWithRange:self.range];
}

@end
