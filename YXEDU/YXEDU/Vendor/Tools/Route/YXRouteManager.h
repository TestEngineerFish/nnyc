//
//  YXRouteManager.h
//  YXEDU
//
//  Created by yao on 2019/1/7.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXRouteManager : UIView

@property (nonatomic, copy) NSMutableArray *tabNamesArray;

+ (instancetype)shared;

- (void)openUrl:(NSString *)url;

- (void)openUrl:(NSString *)url title:(NSString *)title;

- (void)openInsideUrl:(NSString *)url;
@end

