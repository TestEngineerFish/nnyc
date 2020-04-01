//
//  YXComNaviView.h
//  YXEDU
//
//  Created by yao on 2018/10/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YXNaviviewLeftButtonType){
    YXNaviviewLeftButtonWhite,
    YXNaviviewLeftButtonGray
};
typedef void (^ClickTitle)(void);
@interface YXComNaviView : UIView
@property (nonatomic,readonly,strong)UIButton *leftButton;
@property (nonatomic,readonly,strong)UIButton *rightButton;
@property (nonatomic,readonly,strong)UILabel *titleLabel;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)UIImageView *arrowIcon;//title上的箭头icon
@property (nonatomic, strong)UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong)UIBarButtonItem *leftButtonItem;
@property (nonatomic, strong) ClickTitle clickBlock;
+ (instancetype)comNaviViewWithLeftButtonType:(YXNaviviewLeftButtonType)leftButtonType;
- (void)setRightButtonNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightlightImage;
- (void)setLeftButtonNormalImage:(UIImage *)normalImage hightlightImage:(UIImage *)hightlightImage;
- (void)setRightButtonView:(UIView *)customView;

@end

