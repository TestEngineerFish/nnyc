//
//  YXWordBookBaseManageView.h
//  YXEDU
//
//  Created by yao on 2019/3/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXBaseMaskView.h"

NS_ASSUME_NONNULL_BEGIN
@class YXWordBookBaseManageView;
@protocol YXWordBookBaseManageViewDelegate <NSObject>
- (void)wordBookBaseManageView:(YXWordBookBaseManageView *)wordBookBaseManageView clickedButonAtIndex:(NSInteger)idnex;
@end
@interface YXWordBookBaseManageView : YXBaseMaskView <UITextFieldDelegate>
@property (nonatomic, weak) id<YXWordBookBaseManageViewDelegate> delegate;
@property (nonatomic, weak) YXSpringAnimateButton *canclebutton;
@property (nonatomic, weak) YXSpringAnimateButton *confirmButton;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *contenView;
@property (nonatomic, copy) NSString *currentText;
+ (instancetype)wordBookBaseManageViewShowToView:(UIView *)view
                                           title:(NSString *)title
                                    inputDefText:(NSString *)defText
                                        delegate:(id<YXWordBookBaseManageViewDelegate>)delegate;
- (void)textFieldChanged:(UITextField *)tf;
- (void)manageButtonClick:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
