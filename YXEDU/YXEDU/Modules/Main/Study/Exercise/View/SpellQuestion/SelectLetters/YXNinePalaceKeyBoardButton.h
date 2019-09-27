//
//  YXNinePalaceKeyBoardButton.h
//  YXEDU
//
//  Created by yixue on 2019/1/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YXNinePalaceKeyBoardButtonStatus) {
    Normal,
    Selected,
    Wrong,
};

@interface YXNinePalaceKeyBoardButton : UIButton

@property (nonatomic, assign) YXNinePalaceKeyBoardButtonStatus status;
@property (nonatomic, copy) NSString *letters;
@end

NS_ASSUME_NONNULL_END
