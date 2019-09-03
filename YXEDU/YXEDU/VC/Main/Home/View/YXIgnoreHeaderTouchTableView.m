//
//  YXIgnoreHeaderTouchTableView.m
//  YXEDU
//
//  Created by shiji on 2018/5/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXIgnoreHeaderTouchTableView.h"
@interface YXIgnoreHeaderTouchTableView ()

@end

@implementation YXIgnoreHeaderTouchTableView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}


@end
