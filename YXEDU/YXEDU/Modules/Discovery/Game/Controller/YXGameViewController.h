//
//  YXGameViewController.h
//  YXEDU
//
//  Created by yao on 2018/12/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXGameModel.h"
#import "YXGameDetailModel.h"
//游戏vc
@interface YXGameViewController : BSRootVC
@property (nonatomic, strong) YXGameModel *gameModel;
@property (nonatomic, strong) YXGameDetailModel *gameDetail;

@end

