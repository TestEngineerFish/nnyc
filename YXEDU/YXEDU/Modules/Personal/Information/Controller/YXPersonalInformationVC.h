//
//  YXPersonalInformationVC.h
//  YXEDU
//
//  Created by Jake To on 10/12/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPersonalInformationVC : UIViewController

@property (nonatomic, strong) YXUserModel_Old *userModel;
@property (nonatomic, copy)void(^shouldRefreshInfoBlock)(void);
@end

NS_ASSUME_NONNULL_END
