//
//  YXTipsBaseView.h
//  YXEDU
//
//  Created by yao on 2018/11/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YXTouchBlock)(void);

@interface YXTipsBaseView : UIView
@property (nonatomic, weak )UIImageView *tipsImageView;
@property (nonatomic, weak )UILabel *tipsLabel;
@property (nonatomic, weak) UIButton *tapButton;
+ (YXTipsBaseView *)showTipsToView:(UIView *)view  image:(nonnull UIImage *)image tips:(NSString *_Nullable)tips touchBlock:(YXTouchBlock _Nullable )touchBlock;
+ (YXTipsBaseView *)showTipsToView:(UIView *)view  image:(nonnull UIImage *)image tips:(NSString *_Nullable)tips contentOffsetY:(CGFloat)offsetY touchBlock:(YXTouchBlock _Nullable )touchBlock;
@end

