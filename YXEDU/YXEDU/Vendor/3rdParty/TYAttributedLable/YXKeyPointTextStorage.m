//
//  YXKeyPointTextStorage.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/6/4.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXKeyPointTextStorage.h"

@implementation YXKeyPointTextStorage

#pragma mark - protocol

- (void)addTextStorageWithAttributedString:(NSMutableAttributedString *)attributedString
{
    [super addTextStorageWithAttributedString:attributedString];
    [attributedString addAttribute:kTYTextLongPressRunAttributedName value:self range:self.range];
    self.text = [attributedString.string substringWithRange:self.range];

}

@end
