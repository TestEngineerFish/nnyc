//
//  YXSpellView.m
//  1111
//
//  Created by yao on 2018/10/31.
//  Copyright © 2018年 yao. All rights reserved.
//

#import "YXSpellView.h"
#import "YXWordCharacterView.h"

@interface YXSpellView ()<UITextFieldDelegate,YXWordCharacterViewDelegate>
@property (nonatomic, strong) NSMutableArray *characterModels;
@property (nonatomic, assign)NSInteger limitCharsNum;
@property (nonatomic, weak) YXWordCharacterView *lastHightCharacterView;
@property (nonatomic, copy)NSArray *wordCharViews;
@property (nonatomic, copy)NSArray *blankCharViews;
@property (nonatomic, assign)NSInteger checkTimes;
@end

@implementation YXSpellView
{
    NSString *_oriWord;
    NSArray *_blankLocs;
}

+ (YXSpellView *)spellViewWithOriWord:(NSString *)oriWord andBlankLocs:(NSString *)blakLocs {
    YXSpellView *spellView = [[self alloc] initWithOriWord:oriWord andBlakLocs:blakLocs];
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
            YXCharacterModel *cm = [[YXCharacterModel alloc] init];
            
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
        YXWordCharacterView *wcv= [[YXWordCharacterView alloc] initWithFrame:CGRectMake(x, 0, width, 35)];
        wcv.delegate = self;
        wcv.tag = i;
        YXCharacterModel *chModel = self.characterModels[i];
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
        YXWordCharacterView *curWCV = [self.blankCharViews objectAtIndex:index];
        curWCV.characterType = YXCharacterHighlight;
//        curWCV.characterTF.textColor = kLetterHighLightColor;
        _lastHightCharacterView = curWCV;
    }
}

#pragma mark - <YXWordCharacterViewDelegate>
- (void)wordCharacterViewandoverToPreviousResponder:(YXWordCharacterView *)wordCharacterView {
    NSInteger curIndexOfWCV = [self.blankCharViews indexOfObject:wordCharacterView];
    [self changeFirstResponseToBlankCharViewsAtIndex:curIndexOfWCV - 1];
    self.lastHightCharacterView.characterTF.text = @"";
}

- (void)wordCharacterViewHandoverToNextResponder:(YXWordCharacterView *)wordCharacterView {
    NSInteger curIndexOfWCV = [self.blankCharViews indexOfObject:wordCharacterView];
    if (curIndexOfWCV + 1 < self.blankCharViews.count) {
        curIndexOfWCV += 1;
    }
    [self changeFirstResponseToBlankCharViewsAtIndex:curIndexOfWCV];
    // 有输入要检测当前是否可以check Ques result
    [self checkSpellComplateState];
}

- (void)wordCharacterViewBecomeResponder:(YXWordCharacterView *)wordCharacterView {
    NSInteger curIndexOfWCV = [self.blankCharViews indexOfObject:wordCharacterView];
    [self changeFirstResponseToBlankCharViewsAtIndex:curIndexOfWCV];
    [self checkSpellComplateState];
}

- (void)wordCharacterViewResignResponder:(YXWordCharacterView *)wordCharacterView {
    return;
    if (_lastHightCharacterView) {
        _lastHightCharacterView.characterType =  YXCharacterNormal;
        _lastHightCharacterView = nil;
    }
}

- (void)wordCharacterViewClickCheckResult:(YXWordCharacterView *)wordCharacterView {
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
    for (YXWordCharacterView *wcv in self.blankCharViews) {
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
    for (YXWordCharacterView *wcv in self.blankCharViews) {
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
    for (YXWordCharacterView *wcv in self.wordCharViews) {
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


