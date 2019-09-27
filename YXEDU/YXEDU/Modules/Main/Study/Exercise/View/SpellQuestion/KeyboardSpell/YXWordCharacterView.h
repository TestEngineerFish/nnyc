//
//  YXWordCharacterView.h
//  1111
//
//  Created by yao on 2018/11/1.
//  Copyright © 2018年 yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSpellQuestionCommon.h"


@interface YXCharacterModel : NSObject
@property (nonatomic, assign, getter = isBlank)BOOL blank;
//@property (nonatomic, copy)NSString *curCharacter;
@property (nonatomic, copy) NSString *oriCharacter;
@end




@class YXCharacterTextField;
@protocol YXCharacterTextFieldDelegate <NSObject>

- (void)characterTextFieldDeleteBackward:(YXCharacterTextField *)characterTF;
@end

@interface YXCharacterTextField : UITextField
@property (nonatomic, weak) id<YXCharacterTextFieldDelegate> characterTFDelegate;
@end




@class YXWordCharacterView;
@protocol YXWordCharacterViewDelegate <NSObject>
- (void)wordCharacterViewHandoverToNextResponder:(YXWordCharacterView *)wordCharacterView;
- (void)wordCharacterViewandoverToPreviousResponder:(YXWordCharacterView *)wordCharacterView;
- (void)wordCharacterViewBecomeResponder:(YXWordCharacterView *)wordCharacterView;
- (void)wordCharacterViewResignResponder:(YXWordCharacterView *)wordCharacterView;
- (void)wordCharacterViewClickCheckResult:(YXWordCharacterView *)wordCharacterView;
@end

@interface YXWordCharacterView : UIView
@property (nonatomic, weak) id <YXWordCharacterViewDelegate> delegate;
@property (nonatomic, readonly, weak)YXCharacterTextField *characterTF;
@property (nonatomic, readonly, copy) NSString *curCharacter;
@property (nonatomic, readonly, weak)CALayer *indicator;
@property (nonatomic, strong) UIFont *characterFont;
@property (nonatomic, strong) YXCharacterModel *chModel;
@property (nonatomic, assign) YXCharacterType characterType;
@property (nonatomic, readonly,assign,getter=isCorrect) BOOL correct;
@property (nonatomic, readonly,assign) BOOL hasInput;
@end

