//
//  YXCustomButton.h
//  YXEDU
//
//  Created by yao on 2018/10/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXCustomButton : UIButton
@property (nonatomic, assign)CGFloat cornerRadius;
@property (nonatomic, strong)UIColor *disableColor;
+ (YXCustomButton *)commonBlueWithCornerRadius:(CGFloat)cornerRadius;
+ (YXCustomButton *)comBlueShadowBtnWithSize:(CGSize)size;
+ (YXCustomButton *)comBlueShadowBtnWithSize:(CGSize)size WithCornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
