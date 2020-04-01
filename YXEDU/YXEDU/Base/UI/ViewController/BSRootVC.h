

#import <UIKit/UIKit.h>
#import "YXTipsBaseView.h"
//@protocol BSRootVC
//@optional
//- (void)showHUD;
//- (void)hideHUD;
//
//// 在window上展示HUD
//- (void)showHUD_OnWindow;
//
//// 隐藏window的HUD
//- (void)hideHUD_OnWindow;
//@end

typedef NS_ENUM(NSInteger, TextColorType) {
    TextColorBlack,
    TextColorWhite,
};

typedef NS_ENUM(NSInteger, TransationType) {
    TransationNone,
    TransationPop,
    TransationPresent,
};

typedef NS_ENUM(NSInteger, NavigationType) {
    NavigationDefault,
    NavigationTransparent,
    NavigationOpaque = NavigationDefault,
    NavigationBlue,
};

typedef NS_ENUM(NSInteger, BackType) {
    BackGray,
    BackWhite,
};

@interface BSRootVC : UIViewController
@property (nonatomic, assign) NavigationType navigationType;
@property (nonatomic, assign) BackType backType;
@property (nonatomic, assign) TransationType transType;
@property (nonatomic, assign) TextColorType textColorType;
@property (nonatomic, strong) UIImageView *topNavImageView;
@property (nonatomic, assign) BOOL popGestureRecognizerEnabled;

- (void)back;
//- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action;
//- (void)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action;
//- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;
//- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;
//- (void)addRightTwoBarButtonsWithFirstImage:(UIImage *)firstImage
//                                firstAction:(SEL)firstAction
//                                secondImage:(UIImage *)secondImage
//                               secondAction:(SEL)secondAction;

- (void)showNoNetWorkView:(YXTouchBlock)touchBlock;
- (void)hideNoNetWorkView;
- (BOOL)isNetworkAvaiable;

- (void)showNoDataView;
- (void)showNoDataView:(NSString *)tips;
- (void)showNoDataView:(NSString *)tips image:(UIImage *)image;
- (void)hideNoDataView;

- (void)showLoadingView;
- (void)hideLoadingView;
@end    
