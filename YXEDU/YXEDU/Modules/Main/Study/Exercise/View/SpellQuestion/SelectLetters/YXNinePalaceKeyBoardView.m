//
//  YXNinePalaceKeyBoardView.m
//  YXEDU
//
//  Created by yixue on 2019/1/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXNinePalaceKeyBoardView.h"

@interface YXNinePalaceKeyBoardView ()



@property (nonatomic, assign) CGFloat palaceWidth;
@property (nonatomic, assign) CGFloat palaceHeight;

@property (nonatomic, copy) NSArray *keyBoardArray;

@property (nonatomic, copy) NSArray *allOptionsArray;
@property (nonatomic, copy) NSArray *answerArray;

@property (nonatomic, copy) NSMutableArray *userAnswerButtonArray;

@end

@implementation YXNinePalaceKeyBoardView

- (id)initWithFrame:(CGRect)frame
         allOptions:(NSString *)allOptions
             answer:(NSString *)answer
            options:(nonnull NSString *)options
{
    self = [super initWithFrame:frame];
    if (self) {
        _userAnswerArray = [[NSMutableArray alloc] init];
        _userAnswerButtonArray = [[NSMutableArray alloc] init];
        
//        allOptions = @"al,vn,xer,tion,na,la,in,ter";
//        answer = @"in,ter,na,tion,al";
        
        _allOptionsArray = [allOptions componentsSeparatedByString:@","];
        
        NSArray *indexArr = [options componentsSeparatedByString:@","];
        NSArray *allLetters =[answer componentsSeparatedByString:@","];
        NSMutableArray *answerArray = [NSMutableArray array];
        for (NSString *indexStr in indexArr) {
            NSInteger index = [indexStr integerValue];
            [answerArray addObject: [allLetters objectAtIndex:index]];
        }
        
        _answerArray = [answerArray copy];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gap = 10;
    
    _palaceWidth = (self.width - _gap * 2) / 3;
    _palaceHeight = (self.height - _gap * 2) / 3;
    
    [self createNinePalaceKeyBoard];
}

- (void)createNinePalaceKeyBoard {
    NSMutableArray *temKeyBoardArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.allOptionsArray.count; i++) {
        NSInteger col = i % 3;
        NSInteger row = i / 3;
        
        CGRect rect = CGRectMake(col * (_palaceWidth + _gap), row * (_palaceHeight + _gap), _palaceWidth, _palaceHeight);
        YXNinePalaceKeyBoardButton *btn = [[YXNinePalaceKeyBoardButton alloc] initWithFrame:rect];
        btn.letters = _allOptionsArray[i];
        
        btn.status = Normal;
        [btn addTarget:self action:@selector(palaceKeyBoardDidSelectedBy:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        [temKeyBoardArray addObject:btn];
    }
    _keyBoardArray = temKeyBoardArray;
}


- (void)reverseKeyButtonAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.userAnswerButtonArray.count) {
        YXNinePalaceKeyBoardButton *selBtn = [self.userAnswerButtonArray objectAtIndex:index];
        [self palaceKeyBoardDidSelectedBy:selBtn];
    }
}

- (void)palaceKeyBoardDidSelectedBy:(YXNinePalaceKeyBoardButton *)sender {
    //在答案数组中的位置
    NSInteger index = NSNotFound;
    switch (sender.status) {
        case Normal:
            //保证满格时不能添加只能删除
            if (_userAnswerArray.count >= _answerArray.count && ![self checkIfHasEmptyElement:_userAnswerArray]) { return; }
            
            [self insertNewOpt:sender];
            index = [_userAnswerButtonArray indexOfObject:sender];
            sender.status = Selected;
            break;
        case Selected:
        case Wrong:
            for (YXNinePalaceKeyBoardButton *btn in _userAnswerButtonArray) {
                btn.status = Selected;
            }
            index = [_userAnswerButtonArray indexOfObject:sender];
            [self deleteClickedOpt:sender];
            sender.status = Normal;
            break;
    }
    
    // 答案长度相等 && 答案内都不为空 时 isFinished 为YES
    BOOL isFinished = (_userAnswerArray.count == _answerArray.count) && ![self checkIfHasEmptyElement:_userAnswerArray] ? YES : NO;
    // 通过协议向外面传 点击按钮 && 是否已完成状态 && 在答案数组中的位置
    if ([self.delegate respondsToSelector:@selector(ninePalaceKeyBoardButtonDidClicked:clickButton:isFinished:indexInAnswerArr:)]) {
        [self.delegate ninePalaceKeyBoardButtonDidClicked:self clickButton:sender isFinished:isFinished indexInAnswerArr:index];
    }
    /** test code
    if (isFinished) {
        [self checkAnswer];
    }
    **/
}

- (void)insertNewOpt:(YXNinePalaceKeyBoardButton *)sender {
    // 遍历答案数组 if 有空的就填进去 else 在数组后面新加一个
    for (NSInteger i = 0; i < _userAnswerArray.count; i++) {
        if ([_userAnswerArray[i] isEqualToString:@""]) {
            _userAnswerArray[i] = sender.currentTitle;
            _userAnswerButtonArray[i] = sender;
            return;
        }
    }
    [_userAnswerArray addObject:sender.currentTitle];
    [_userAnswerButtonArray addObject:sender];
}

- (void)deleteClickedOpt:(YXNinePalaceKeyBoardButton *)sender {
    //根据对应的 _userAnswerButtonArray 找到在 _userAnswerArray 中对应的 index 并删除
    NSInteger index = [_userAnswerButtonArray indexOfObject:sender];
    _userAnswerArray[index] = @"";
    _userAnswerButtonArray[index] = [YXNinePalaceKeyBoardButton alloc];// 创建一个空白按钮堵住数组缺口
}

- (NSArray *)checkAnswer {
    NSAssert(_userAnswerArray.count == _answerArray.count, @"用户答案和标准答案长度不一致");
    NSAssert(![self checkIfHasEmptyElement:_userAnswerArray], @"用户答案内有空白答案");
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _userAnswerArray.count; i++) {
        if (_isCorrect) {
            YXNinePalaceKeyBoardButton *btn = _userAnswerButtonArray[i];
            btn.status = Selected;
        }
        else if (![_userAnswerArray[i] isEqual:_answerArray[i]]) {
            YXNinePalaceKeyBoardButton *btn = _userAnswerButtonArray[i];
            btn.status = Wrong;
            [ary addObject:@(i)];
        }
    }
    return ary;
}

- (BOOL)checkIfHasEmptyElement:(NSArray *)ary {
    for (NSString *str in ary) {
        if ([str isEqualToString:@""]) { return YES; }
    }
    return NO;
}
-(void)setIsCorrect:(BOOL)isCorrect{
    _isCorrect = isCorrect;
}

@end
