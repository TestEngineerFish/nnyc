//
//  YXLettersModel.h
//  YXEDU
//
//  Created by yao on 2019/1/23.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXSpellQuestionCommon.h"
@interface YXLettersModel : NSObject
@property (nonatomic, assign, getter = isBlank) BOOL blank;
@property (nonatomic, copy) NSString *oriCharacter;
@property (nonatomic, copy) NSString *curCharacters;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) BOOL isCorrect;
@end

