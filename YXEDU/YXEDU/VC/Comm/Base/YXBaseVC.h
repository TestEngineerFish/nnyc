//
//  YXBaseVC.h
//  YXEDU
//
//  Created by shiji on 2018/3/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"

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


@interface YXBaseVC : BSRootVC
@property (nonatomic, assign) NavigationType navigationType;
@property (nonatomic, assign) BackType backType;
@property (nonatomic, assign) TransationType transType;
@property (nonatomic, assign) TextColorType textColorType;

- (void)back;
@end
