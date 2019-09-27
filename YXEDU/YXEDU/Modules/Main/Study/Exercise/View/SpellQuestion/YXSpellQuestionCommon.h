//
//  YXSpellQuestionCommon.h
//  YXEDU
//
//  Created by yao on 2019/1/23.
//  Copyright © 2019年 shiji. All rights reserved.
//

#ifndef YXSpellQuestionCommon_h
#define YXSpellQuestionCommon_h


#define kDefaultCharacterWith 24
#define kDefaultCharacterFont 25
#define kMaxSpellViewWith (SCREEN_WIDTH - 30 - 10)

#define kLetterNormalColor    UIColorOfHex(0x485461)
#define kLetterHighLightColor UIColorOfHex(0x60B6F8)
#define kLetterErrorColor     UIColorOfHex(0xFC7D8B)

typedef NS_ENUM(NSUInteger, YXCharacterType) {
    YXCharacterNormal,
    YXCharacterHighlight,
    YXCharacterError,
};

#endif /* YXSpellQuestionCommon_h */
