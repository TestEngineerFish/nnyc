//
//  YXShareView.h
//  YXEDU
//
//  Created by yao on 2018/11/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCommonMaskView.h"
#import "YXPunchModel.h"
@interface YXShareButton : UIButton

@end

@interface YXShareView : YXCommonMaskView
+ (YXShareView *)showShareInView:(UIView *)view;
+ (YXShareView *)showShareInView:(UIView *)view
                      punchModel:(YXPunchModel *)punchModel;
+ (YXShareView *)showShareInView:(UIView *)view
                           title:(NSString *)title
                       shareLink:(NSString *)link;
@end

