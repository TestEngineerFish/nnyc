//
//  YXPersonalFeedBackVC.h
//  YXEDU
//
//  Created by shiji on 2018/5/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXFeedBackSelectImageView.h"

@interface YXPersonalFeedBackVC : BSRootVC
@property (nonatomic, strong) UIImage *screenShotImage;
@property (nonatomic, strong) YXFeedBackSelectImageView *selectImageView;
- (void)addImage:(NSArray<UIImage *> *)imageList;
@end
