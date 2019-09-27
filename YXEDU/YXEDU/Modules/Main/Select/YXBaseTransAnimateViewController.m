//
//  YXBaseTransAnimateViewController.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBaseTransAnimateViewController.h"

@interface YXBaseTransAnimateViewController ()

@end

@implementation YXBaseTransAnimateViewController
{
    YXBookTransHelper *_bookTransHelper;
}

- (instancetype)init {
    if (self = [super init]) {
        _bookTransHelper = [[YXBookTransHelper alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([viewControllerToPresent isKindOfClass:[YXBaseTransAnimateViewController class]]) {
        YXBaseTransAnimateViewController *baseVC = (YXBaseTransAnimateViewController *)viewControllerToPresent;
        self.bookTransHelper.animateType = YXTransAnimatePresent;
        baseVC.bookTransHelper.transModel = self.bookTransHelper.transModel;
        viewControllerToPresent.transitioningDelegate = self.bookTransHelper;
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    }

    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    self.bookTransHelper.animateType = YXTransAnimatePop;
    self.transitioningDelegate = self.bookTransHelper; // 不是同一个helper
    [super dismissViewControllerAnimated:flag completion:completion];
}
@end
