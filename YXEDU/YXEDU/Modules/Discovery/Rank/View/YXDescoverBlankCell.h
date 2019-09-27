//
//  YXDescoverBlankCell.h
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoverBaseCell.h"

@interface YXDescoverBlankCell : YXDescoverBaseCell
@property (nonatomic, assign) NSInteger gameState;
@property (nonatomic, copy) NSString *gameName;
- (void)configGameName:(NSString *)gameName gameState:(NSInteger)gameState;
@end

