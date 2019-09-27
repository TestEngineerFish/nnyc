//
//  YXCheckButtonsView.h
//  YXEDU
//
//  Created by Jake To on 10/30/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCheckButton.h"

NS_ASSUME_NONNULL_BEGIN

@class YXCheckButtonsView;

@protocol YXCheckButtonsViewDelegate <NSObject>

- (void)CheckButtonView:(YXCheckButtonsView *)checkButtonView checkButton:(YXCheckButton *)checkButton;

@end

@interface YXCheckButtonsView : UIView

@property (nonatomic, weak) id<YXCheckButtonsViewDelegate> delegate;

- (void)configureButtonsWithType:(NSString *)type titles:(NSArray *)titles;
- (void)configureWithTitles:(NSArray *)titles;
- (void)disableAllButtons;
- (void)resetAllButtons;
- (YXCheckButton *)checkButtonAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
