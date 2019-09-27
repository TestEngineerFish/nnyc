//
//  YXWordPreviewPopView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWordDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXWordPreviewPopView : UIView
@property (nonatomic, strong) UIButton *checkDetail;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, weak)   UIImageView *upImageView;
@property (nonatomic, weak)   UIImageView *downImageView;
+ (YXWordPreviewPopView *)createWordPreviewPopView:(YXWordDetailModel *)wordModel;
@end

NS_ASSUME_NONNULL_END
