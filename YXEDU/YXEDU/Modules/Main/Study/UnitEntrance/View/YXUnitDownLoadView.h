//
//  YXUnitDownLoadView.h
//  YXEDU
//
//  Created by shiji on 2018/6/11.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXUnitDownLoadViewDelegate <NSObject>
@optional
- (void)cancelBtnDidClicked:(id)sender;
@end

@interface YXUnitDownLoadView : UIView
@property (nonatomic, assign) id<YXUnitDownLoadViewDelegate>delegate;
+ (id)showDownLoadView:(UIView *)_view
                rootVC:(id<YXUnitDownLoadViewDelegate>)root;
- (void)updateProgress:(float)progress;
@end
