//
//  YXSliderBackVC.h
//  YXEDU
//
//  Created by shiji on 2018/3/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"


@protocol YXSideSlipDataSource <NSObject>
@optional

- (CGFloat)sliderWidth;

@end

@interface YXSideSlipVC : BSRootVC

@property (nonatomic, strong) UIViewController *frontVC;

@property (nonatomic, weak) id <YXSideSlipDataSource> dataSource;

- (instancetype)initFrontVC:(UIViewController *)frontVC;
@end
