//
//  YXCompleteUnitView.h
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXCompleteUnitViewDelegate <NSObject>
- (void)backToMainPage:(id)sender;
@end


@interface YXCompleteUnitView : UIView
@property (nonatomic, assign) id<YXCompleteUnitViewDelegate>delegate;
- (void)reloadData;
@end
