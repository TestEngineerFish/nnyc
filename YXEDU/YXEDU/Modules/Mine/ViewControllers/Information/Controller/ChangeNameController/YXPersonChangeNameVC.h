//
//  YXChangeNameViewController.h
//  YXEDU
//
//  Created by Jake To on 10/14/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReturnNameStringBlock) (NSString *nameString);

@interface YXPersonChangeNameVC : UIViewController

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userNameLength;

@property (nonatomic, strong) UITextField *textField;

@property(nonatomic, strong) ReturnNameStringBlock returnNameStringBlock;

@end

NS_ASSUME_NONNULL_END
