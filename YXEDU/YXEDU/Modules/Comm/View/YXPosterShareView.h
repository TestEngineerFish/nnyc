//
//  YXPosterShareView.h
//  YXEDU
//
//  Created by jukai on 2019/4/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPunchModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^YXPosterShareBlock)(id obj);

@protocol YXPosterShareViewDelegate <NSObject>

-(void)posterShareViewDidShareMoments;

@end


@interface YXPosterShareButton : UIButton

@end

//海报分享页面
@interface YXPosterShareView : UIView
+ (YXPosterShareView *)showShareInView:(UIView *)view
                            punchModel:(YXPunchModel *)punchModel block:(YXPosterShareBlock)block;
@end

NS_ASSUME_NONNULL_END
