//
//  YXGameShareView.h
//  YXEDU
//
//  Created by yao on 2019/1/4.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXGameShareView : UIView
@property (nonatomic, copy) void(^shareBlock)(YXSharePalform platForm);
@end

