//
//  YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.m
//  YXEDU
//
//  Created by shiji on 2018/5/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"

@implementation YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
