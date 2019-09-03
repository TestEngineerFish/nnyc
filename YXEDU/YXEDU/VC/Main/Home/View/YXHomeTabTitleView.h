//
//  YXHomeTabTitleView.h
//  YXEDU
//
//  Created by shiji on 2018/6/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXHomeTabTitleViewDelegate <NSObject>
- (void)titleBtnDidClicked:(id)sender;
@end

@interface YXHomeTabTitleView : UIView
@property (nonatomic, assign) id <YXHomeTabTitleViewDelegate>delegate;
- (void)setAllBtnIdx:(NSInteger )btnIdx;
@end
