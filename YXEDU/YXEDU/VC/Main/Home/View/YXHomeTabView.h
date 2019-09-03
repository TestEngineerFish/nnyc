//
//  YXHomeTabView.h
//  YXEDU
//
//  Created by shiji on 2018/6/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHomeDefined.h"
@protocol YXHomeUnitViewDelegate;
@interface YXHomeTabView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                       rootVC:(id<YXHomeUnitViewDelegate>)root
                rootViewModel:(id)viewModel;

- (void)reloadSubViews;
@end
