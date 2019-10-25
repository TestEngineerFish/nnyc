//
//  YXWordCharacterViewOld.h
//  1111
//
//  Created by yao on 2018/11/1.
//  Copyright © 2018年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSpellQuestionCommon.h"


@interface YXCharacterModelOld : NSObject
@property (nonatomic, assign, getter = isBlank)BOOL blank;
//@property (nonatomic, copy)NSString *curCharacter;
@property (nonatomic, copy) NSString *oriCharacter;
@end




@class YXCharacterTextFieldOld;
@protocol YXCharacterTextFieldOldDelegate <NSObject>

- (void)characterTextFieldDeleteBackward:(YXCharacterTextFieldOld *)characterTF;
@end

@interface YXCharacterTextFieldOld : UITextField
@property (nonatomic, weak) id<YXCharacterTextFieldOldDelegate> characterTFDelegate;
@end




@class YXWordCharacterViewOld;
@protocol YXWordCharacterViewOldDelegate <NSObject>
- (void)wordCharacterViewHandoverToNextResponder:(YXWordCharacterViewOld *)wordCharacterView;
- (void)wordCharacterViewandoverToPreviousResponder:(YXWordCharacterViewOld *)wordCharacterView;
- (void)wordCharacterViewBecomeResponder:(YXWordCharacterViewOld *)wordCharacterView;
- (void)wordCharacterViewResignResponder:(YXWordCharacterViewOld *)wordCharacterView;
- (void)wordCharacterViewClickCheckResult:(YXWordCharacterViewOld *)wordCharacterView;
@end

@interface YXWordCharacterViewOld : UIView
@property (nonatomic, weak) id <YXWordCharacterViewOldDelegate> delegate;
@property (nonatomic, readonly, weak)YXCharacterTextFieldOld *characterTF;
@property (nonatomic, readonly, copy) NSString *curCharacter;
@property (nonatomic, readonly, weak)CALayer *indicator;
@property (nonatomic, strong) UIFont *characterFont;
@property (nonatomic, strong) YXCharacterModelOld *chModel;
@property (nonatomic, assign) YXCharacterType characterType;
@property (nonatomic, readonly,assign,getter=isCorrect) BOOL correct;
@property (nonatomic, readonly,assign) BOOL hasInput;
@end

