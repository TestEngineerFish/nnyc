//
//  YXLearnProgressView.h
//  YXEDU
//
//  Created by shiji on 2018/3/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLearnProgressView : UIView
@property (nonatomic, strong) UILabel *progressLab;

@property (nonatomic, assign) NSInteger unitGroupTotal; // 多少组

@property (nonatomic, assign) NSInteger unitGroupIdx;   // 组数index

@property (nonatomic, assign) NSInteger unitGroupQuestionCount; // 该组的单词数

@property (nonatomic, assign) NSInteger unitGroupQuestionLearnCount; // 组的单词已经学习个数

@end
