//
//  YXNOSignalVC.h
//  YXEDU
//
//  Created by shiji on 2018/3/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBaseVC.h"

@protocol YXNOSignalViewDelegate <NSObject>
@optional
- (void)reloadBtnClicked:(id)sender;
@end

@interface YXNOSignalView : UIView
@property (nonatomic, assign) id <YXNOSignalViewDelegate>delegate;
@end


@interface YXNOSignalVC : YXBaseVC
@property (nonatomic, assign) BOOL coverAll;
@property (nonatomic, strong) YXNOSignalView *noSignalView;

- (void)reloadNoSignalView; // 加载信号
- (void)refreshBtnClicked; // 点击按钮
@end
