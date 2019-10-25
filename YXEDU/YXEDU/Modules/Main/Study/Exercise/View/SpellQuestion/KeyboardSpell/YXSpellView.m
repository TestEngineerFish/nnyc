//
//  YXSpellViewOld.m
//  1111
//
//  Created by yao on 2018/10/31.
//  Copyright © 2018年 yao. All rights reserved.
//

#import "YXSpellViewOld.h"
#import "YXWordCharacterViewOld.h"

@interface YXSpellViewOld ()<UITextFieldDelegate,YXWordCharacterViewOldDelegate>
@property (nonatomic, strong) NSMutableArray *characterModels;
@property (nonatomic, assign)NSInteger limitCharsNum;
@property (nonatomic, weak) YXWordCharacterViewOld *lastHightCharacterView;
@property (nonatomic, copy)NSArray *wordCharViews;
@property (nonatomic, copy)NSArray *blankCharViews;
@property (nonatomic, assign)NSInteger checkTimes;
@end

@implementation YXSpellViewOld
{
    NSString *_oriWord;
    NSArray *_blankLocs;
}

+ (YXSpellViewOld *)spellViewWithOriWord:(NSString *)oriWord andBlankLocs:(NSString *)blakLocs {
    YXSpellViewOld *spellView = [[self alloc] initWithOriWord:oriWord andBlakLocs:blakLocs];
    return spellView;
}

- (NSMutableArray *)characterModels {
    if (!_characterModels) {
        _characterModels = [NSMutableArray array];
    }
    return _characterModels;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.characterModels removeAllObjects];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (instancetype)initWithOriWord:(NSString *)oriWord andBlakLocs:(NSString *)blankLocs {
    if (self = [super init]) {
        _oriWord = oriWord;
        _blankLocs = [blankLocs componentsSeparatedByString:@","];
        
        self.limitCharsNum = _blankLocs.count;
        
        for (NSInteger i = 0; i < oriWord.length; i ++) {
            NSString *character = [oriWord substringWithRange:NSMakeRange(i, 1)];
            YXCharacterModelOld *cm = [[YXCharacterModelOld alloc] init];
            
            NSString *indexStr = [NSString stringWithFormat:@"%zd",i];
            BOOL isContain = [self.blankLocs containsObject:indexStr];
            cm.blank = isContain;
            cm.oriCharacter = character;
            [self.characterModels addObject:cm];
        }
        
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    NSInteger count = self.characterModels.count;
    CGFloat width = kDefaultCharacterWith;
    CGFloat fontSize = kDefaultCharacterFont;
    CGFloat leftMargin = 0;
    if (kMaxSpellViewWith < kDefaultCharacterWith * count) {
        width = 1.0 * kMaxSpellViewWith / count;
        fontSize = width -1;
    }else {
        leftMargin = (kMaxSpellViewWith - kDefaultCharacterWith * count) * 0.5;
    }
    
    NSMutableArray *wordCharViews = [NSMutableArray array];
    NSMutableArray *blankCharViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.characterModels.count; i++) {
        CGFloat x = width * i + leftMargin;
        YXWordCharacterViewOld *wcv= [[YXWordCharacterViewOld alloc] initWithFrame:CGRectMake(x, 0, width, 35)];
        wcv.delegate = self;
        wcv.tag = i;
        YXCharacterModelOld *chModel = self.characterModels[i];
        wcv.chModel = chModel;
        if (chModel.isBlank) {
            wcv.characterTF.text  = @"";
            [blankCharViews addObject:wcv];
        }
        if (fontSize != kDefaultCharacterFont ) {
            wcv.characterFont = [UIFont boldSystemFontOfSize:fontSize];
        }
        [self addSubview:wcv];
        [wordCharViews addObject:wcv];
    }
    
    self.wordCharViews = [wordCharViews copy];
    self.blankCharViews = [blankCharViews copy];
}

- (void)changeFirstResponseToBlankCharViewsAtIndex:(NSInteger)index {
    if (index != NSNotFound && index >=0 && index < self.blankCharViews.count) {
        if (_lastHightCharacterView) {
            NSInteger lastHighlightIndex = [self.blankCharViews indexOfObject:_lastHightCharacterView];
            
            if (index == lastHighlightIndex) { // 同一个高亮
                _lastHightCharacterView.characterType = YXCharacterHighlight;
                return;
            }
            
            _lastHightCharacterView.characterType = YXCharacterNormal;
        }
        YXWordCharacterViewOld *curWCV = [self.blankCharViews objectAtIndex:index];
        curWCV.characterType = YXCharacterHighlight;
//        curWCV.characterTF.textColor = kLetterHighLightColor;
        _lastHightCharacterView = curWCV;
    }
}

#pragma mark - <YXWordCharacterViewOldDelegate>
- (void)wordCharacterViewandoverToPreviousResponder:(YXWordCharacterViewOld *)wordCharacterView {
    NSInteger curIndexOfWCV = [self.blankCharViews indexOfObject:wordCharacterView];
    [self changeFirstResponseToBlankCharViewsAtIndex:curIndexOfWCV - 1];
    self.lastHightCharacterView.characterTF.text = @"";
}

- (void)wordCharacterViewHandoverToNextResponder:(YXWordCharacterViewOld *)wordCharacterView {
    NSInteger curIndexOfWCV = [self.blankCharViews indexOfObject:wordCharacterView];
    if (curIndexOfWCV + 1 < self.blankCharViews.count) {
        curIndexOfWCV += 1;
    }
    [self changeFirstResponseToBlankCharViewsAtIndex:curIndexOfWCV];
    // 有输入要检测当前是否可以check Ques result
    [self checkSpellComplateState];
}

- (void)wordCharacterViewBecomeResponder:(YXWordCharacterViewOld *)wordCharacterView {
    NSInteger curIndexOfWCV = [self.blankCharViews indexOfObject:wordCharacterView];
    [self changeFirstResponseToBlankCharViewsAtIndex:curIndexOfWCV];
    [self checkSpellComplateState];
}

- (void)wordCharacterViewResignResponder:(YXWordCharacterViewOld *)wordCharacterView {
    return;
    if (_lastHightCharacterView) {
        _lastHightCharacterView.characterType =  YXCharacterNormal;
        _lastHightCharacterView = nil;
    }
}

- (void)wordCharacterViewClickCheckResult:(YXWordCharacterViewOld *)wordCharacterView {
    BOOL canCheck = [self canCheckResult];
    
    if ([self.delegate respondsToSelector:@selector(spellView:canCheck:)]) {
        [self.delegate spellView:self canCheck:canCheck];
    }
}

- (void)checkSpellComplateState {
    BOOL canCheck = [self canCheckResult];
    if ([self.delegate respondsToSelector:@selector(spellView:complate:)]) {
        [self.delegate spellView:self complate:canCheck];
    }
}
- (BOOL)canCheckResult {
    BOOL canCheck = YES;
    for (YXWordCharacterViewOld *wcv in self.blankCharViews) {
        if (!wcv.hasInput) {
            canCheck = NO;
            break;
        }
    }
    
    return canCheck;
}

- (BOOL)result {
    self.checkTimes ++;
    BOOL isCorrect = YES;
    for (YXWordCharacterViewOld *wcv in self.blankCharViews) {
        if (wcv.isCorrect == NO) {
//            if (self.checkTimes > 1) { // 打错超过一次标红（2.0第一次标红加发音）
                wcv.characterType = YXCharacterError;
//            }
            isCorrect = NO;
        }
    }
    
    return isCorrect;
}

- (NSString *)resultWord {
    NSMutableString *rWord = [NSMutableString string];
    for (YXWordCharacterViewOld *wcv in self.wordCharViews) {
        [rWord appendString:wcv.curCharacter];
    }
    return [rWord copy];
}

- (void)beginEditing {
    if (self.lastHightCharacterView) {
        [self.lastHightCharacterView.characterTF becomeFirstResponder];
        self.lastHightCharacterView.indicator.backgroundColor = UIColorOfHex(0x60B6F8).CGColor;
//        self.lastHightCharacterView.characterType = YXCharacterHighlight;
    }else {
        [self changeFirstResponseToBlankCharViewsAtIndex:0];
    }
}



@end


