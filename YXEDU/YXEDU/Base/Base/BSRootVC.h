

#import <UIKit/UIKit.h>
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

@interface BSRootVC : UIViewController

- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action;
- (void)addRightBarButtonWithFirstImage:(UIImage *)firstImage action:(SEL)action;
- (void)addRightBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;
- (void)addLeftBarButtonItemWithTitle:(NSString *)itemTitle action:(SEL)action;
- (void)addRightTwoBarButtonsWithFirstImage:(UIImage *)firstImage
                                firstAction:(SEL)firstAction
                                secondImage:(UIImage *)secondImage
                               secondAction:(SEL)secondAction;
@end
