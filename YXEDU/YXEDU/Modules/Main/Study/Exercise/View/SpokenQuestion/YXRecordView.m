//
//  YXRecordView.m
//  YXEDU
//
//  Created by yao on 2018/12/17.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRecordView.h"
@interface YXRecordView ()
@property (nonatomic, assign)BOOL cancleTouchEvent;
@end

@implementation YXRecordView
{
    YXVoiceRecordState _currentRecordState;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self recordViewState:YES];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self recordViewState:NO];
    if([self.delegate respondsToSelector:@selector(recordViewSholdStartRecord:)]) {
        [self.delegate recordViewSholdStartRecord:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (touchPoint.y > 0) {
        _currentRecordState = YXVoiceRecordState_Recording;
    }else {
        _currentRecordState = YXVoiceRecordState_ReleaseToCancel; // 取消状态
    }
    if([self.delegate respondsToSelector:@selector(recodViewStateChanged:)]) {
        [self.delegate recodViewStateChanged:self];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endRecord];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endRecord];
}

- (void)endRecord {
    if([self.delegate respondsToSelector:@selector(recordViewShouldEndRecord:)]) {
        [self.delegate recordViewShouldEndRecord:self];
    }
    [self recordViewState:YES];
}

- (void)recordViewState:(BOOL)isNormal {
    NSString *imageName = isNormal ?  @"speaker_normal" : @"speaker_press";
    self.image = [UIImage imageNamed:imageName];
}
@end
