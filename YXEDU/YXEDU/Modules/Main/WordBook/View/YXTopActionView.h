//
//  YXTopActionView.h
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordBookActionProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXTopActionView : UIView
@property (nonatomic, weak) id<YXMyWordBookActionProtocol> delegate;
@property (nonatomic, assign) BOOL manageState;
@end

NS_ASSUME_NONNULL_END
