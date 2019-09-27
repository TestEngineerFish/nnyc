//
//  YXSelectBookVC.h
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "VTMagic.h"
#import "YXNOSignalVC.h"
#import "YXBaseTransAnimateViewController.h"

typedef void(^SelectedBookSuccessBlock)(void) ;
@interface YXSelectBookVC : YXBaseTransAnimateViewController
@property (nonatomic, assign) BOOL hasLeftBarButtonItem;
@property (nonatomic, copy) SelectedBookSuccessBlock selectedBookSuccessBlock;
@property (nonatomic, assign) BOOL isFirstLogin;
+ (YXSelectBookVC *)selectBookVCSelectedSuccessBlock:(SelectedBookSuccessBlock)selectedBookSuccessBlock;
@end
