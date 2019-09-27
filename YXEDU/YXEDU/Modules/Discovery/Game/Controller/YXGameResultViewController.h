//
//  YXGameResultViewController.h
//  YXEDU
//
//  Created by yao on 2019/1/4.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXGameAnswerModel.h"
@interface YXGameResultViewController : BSRootVC
@property (nonatomic, strong) YXGameAnswerModel *gameAnswerModel;
@property (nonatomic, copy) NSString *gameId;
@end

