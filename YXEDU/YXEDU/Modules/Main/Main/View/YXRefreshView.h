//
//  YXRefreshView.h
//  YXEDU
//
//  Created by yao on 2018/10/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXRefreshNormalHeader.h"
@interface YXRefreshView : UIView <YXRefreshNormalHeaderDelegate>
@property (nonatomic, assign)MJRefreshState refreshState;
@property (nonatomic, assign)NSInteger currentImageIndex;
@end

