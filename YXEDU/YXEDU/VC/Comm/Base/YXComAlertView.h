//
//  YXComAlertView.h
//  YXEDU
//
//  Created by shiji on 2018/4/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YXFirstBlock)(id obj);
typedef void(^YXSecondBlock)(id obj);

typedef NS_ENUM(NSInteger, YXAlertType) {
    YXAlertLogout,
    YXAlertManageBook,
    YXAlertStudySelect,
    YXAlertGraphCode,
    YXAlertMaterial, // 资源包
};

@interface YXComAlertView : UIView
@property (nonatomic, strong) UIImageView *verifyCodeImage;
@property (nonatomic, strong) UITextField *verifyCodeField;

+ (id)showAlert:(YXAlertType)alertType
         inView:(UIView *)view
           info:(NSString *)info
        content:(NSString *)content
     firstBlock:(YXFirstBlock)firstBlock
    secondBlock:(YXSecondBlock)secondBlock;

- (void)removeView;
@end
