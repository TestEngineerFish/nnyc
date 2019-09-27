//
//  YXCareerSortButton.h
//  YXEDU
//
//  Created by yixue on 2019/2/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCareerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCareerSortButton : YXNoHightButton

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) YXCareerModel *careerModel;

@end

NS_ASSUME_NONNULL_END
