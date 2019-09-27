//
//  YXWordDetailAudioCell.h
//  YXEDU
//
//  Created by yao on 2018/11/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordDetailTextCell.h"
#import "YXAudioAnimations.h"
@interface YXWordDetailAudioCell : YXWordDetailTextCell
@property (nonatomic, copy)NSString *urlKey;
@property (nonatomic, strong) YXAudioAnimations *speakButton;
- (void)playWordSound;
@end

