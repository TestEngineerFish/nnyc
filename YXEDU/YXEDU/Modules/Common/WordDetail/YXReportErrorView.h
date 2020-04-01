//
//  YXReportErrorView.h
//  YXEDU
//
//  Created by yao on 2018/10/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXReportErrorView : UIView
+ (YXReportErrorView *)showToView:(UIView *)view;
+ (YXReportErrorView *)showToView:(UIView *)view withWordId:(NSNumber *)wordId withWord:(NSString *)word;
@end

