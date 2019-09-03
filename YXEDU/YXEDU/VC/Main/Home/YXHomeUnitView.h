//
//  YXUnitVC.h
//  YXEDU
//
//  Created by shiji on 2018/5/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBaseVC.h"
#import "YXHomeViewModel.h"
#import "YXHomeDefined.h"

@protocol YXHomeUnitViewDelegate <NSObject>
@optional
- (void)didSelectedRow:(id)model;
- (void)changeBookBtnClicked:(id)sender;
@end

@interface YXHomeUnitView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                rootViewModel:(YXHomeViewModel *)viewModel;
@property (nonatomic, assign) id<YXHomeUnitViewDelegate>delegate;
@property (nonatomic, assign) YXHomeTabType tabType;
- (void)reloadSubViews;
@end
