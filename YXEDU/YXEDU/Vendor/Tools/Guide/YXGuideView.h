//
//  YXGuideView.h
//  YXEDU
//
//  Created by shiji on 2018/4/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXGuideView;
@protocol YXGuideViewDelegate <NSObject>
- (void)guideViewDidFinished:(YXGuideView *)guideView;
@end

@interface YXGuideView : UIView
@property (nonatomic, weak)id<YXGuideViewDelegate> delegate;
@end
