//
//  YXSelectBookSegment.h
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  YXSelectBookSegment;
@protocol YXSelectBookSegmentDelegate <NSObject>
- (void)selectBookSegment:(YXSelectBookSegment *)sgm selectTitleIndex:(NSInteger)index;
@end
@interface YXSelectBookSegment : UIView
@property (nonatomic, weak)id<YXSelectBookSegmentDelegate> delegate;
@property (nonatomic, copy)NSArray *titles;
@property (nonatomic,readonly,assign)NSInteger currentSelectIndex;
- (void)selectTitleAtIndex:(NSInteger)index;
@end

