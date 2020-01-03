//
//  BiggerClickAreaButton.m
//  Student
//
//  Created by sunwu on 2018/8/23.
//  Copyright © 2018年 YiXue. All rights reserved.
//

#import "BiggerClickAreaButton.h"

@implementation BiggerClickAreaButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


//#pragma mark 拖动执行的关键代码
//
//- (void)scrollToTheSelectedCell {
//    
//    
//    
//    CGRect selectionRectConverted = [self convertRect:_selectionRect toView:_tableView];
//    
//    NSArray *indexPathArray = [_tableView indexPathsForRowsInRect:selectionRectConverted];
//    
//    
//    
//    CGFloat intersectionHeight =0.0;
//    
//    
//    
//    for (NSIndexPath *indexin indexPathArray) {
//        
//        //looping through the closest cells to get the closest one
//        
//        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:index];
//        
//        CGRect intersectedRect =CGRectIntersection(cell.frame, selectionRectConverted);
//        
//        
//        
//        if (intersectedRect.size.height>=intersectionHeight) {
//            
//            selectedIndexPath = index;
//            
//            intersectionHeight = intersectedRect.size.height;
//            
//        }
//        
//    }
//    
//    if (selectedIndexPath!=nil) {
//        
//        //As soon as we elected an indexpath we just have to scroll to it
//        
//        [_tableViews crollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        
//        [self.delegateselector:_tableView didSelectRowAtIndex:selectedIndexPath.row];
//        
//        [_tableViewreloadData];
//        
//    }
//    
//}
@end
