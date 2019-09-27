//
//  YXNoNetworkView.h
//  YXEDU
//
//  Created by Jake To on 10/10/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXNoNetworkView : UIView

+ (YXNoNetworkView *)createWith:(void(^)(void))touchBlock;

@end

NS_ASSUME_NONNULL_END
