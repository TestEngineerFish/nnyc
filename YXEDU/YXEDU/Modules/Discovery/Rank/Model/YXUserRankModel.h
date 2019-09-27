//
//  YXUserRankModel.h
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//


#import "YXRankBaseInfo.h"
#import "YXDescoverHeader.h"
@interface YXUserRankModel : YXRankBaseInfo
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL    isMyself;
@property (nonatomic, strong) UIImage *acrIcon;
@end

