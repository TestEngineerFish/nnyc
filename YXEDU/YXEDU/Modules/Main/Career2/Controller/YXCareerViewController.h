//
//  YXCareerViewController.h
//  YXEDU
//
//  Created by yixue on 2019/2/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRootVC.h"
#import "YXCareerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCareerViewController : BSRootVC

@property (nonatomic, strong) YXCareerModel *careerModel;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
