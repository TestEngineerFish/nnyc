//
//  YXWordDetailToolkitView.h
//  YXEDU
//
//  Created by jukai on 2019/5/15.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWordToolkitModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YXWordDetailToolBlock)(id obj);

@interface YXWordDetailToolkitView : UIView
@property (nonatomic, copy) YXWordDetailToolBlock toolkitBlock;
+ (YXWordDetailToolkitView *)showShareInView:(UIView *)view
                            toolkitModel:(YXWordToolkitModel *)toolkitModelodel block:(YXWordDetailToolBlock)block;

-(void)setToolkitModelodel:(YXWordToolkitModel *)toolkitModelodel;

@end

NS_ASSUME_NONNULL_END
