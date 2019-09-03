//
//  YXCompleteUnitView.m
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCompleteUnitView.h"
#import "BSCommon.h"
#import "YXStudyCmdCenter.h"
#import "YXCommHeader.h"

@interface YXCompleteUnitView ()
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *studyTitleLab;
@property (nonatomic, strong) UILabel *studyNumLab;
@property (nonatomic, strong) UIButton *enterNextBtn;
@property (nonatomic, strong) UIButton *reCallingBtn;
@end

@implementation YXCompleteUnitView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorOfHex(0xf0f0f0);
    }
    return self;
}

- (void)enterNextBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backToMainPage:)]) {
        [self.delegate backToMainPage:sender];
    }
//    [[YXStudyCmdCenter shared]studyAction:YXActionSelectImageContinue];
}

- (void)reCallingBtnClicked:(id)sender {
    [[YXStudyCmdCenter shared]startTopic];
}


- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        [self recreateSubViews];
    } else {
        [self removeAllSubViews];
    }
}

- (void)recreateSubViews {
    [self titleImage];
    [self titleLab];
    [self studyTitleLab];
    [self studyNumLab];
    [self enterNextBtn];
    [self reCallingBtn];
    [self reloadData];
}
- (void)removeAllSubViews {
    RELEASE(_titleImage);
    RELEASE(_titleLab);
    RELEASE(_studyTitleLab);
    RELEASE(_studyNumLab);
    RELEASE(_enterNextBtn);
    RELEASE(_reCallingBtn);
}

- (void)reloadData {
    self.titleLab.text = [NSString stringWithFormat:@"已完成第%ld单元", (long)[[YXStudyCmdCenter shared]unitIndex]];
    self.studyNumLab.text = [[YXStudyCmdCenter shared]unitWordCount];
}

#pragma mark -lazy load view-
- (UIImageView *)titleImage {
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-222)/2.0, 56, 222, 193)];
        if (iPhone4) {
            _titleImage.frame = CGRectMake((SCREEN_WIDTH-222)/2.0, 46, 222, 193);
        }
        _titleImage.image = [UIImage imageNamed:@"study_cup"];
        [self addSubview:_titleImage];
    }
    return _titleImage;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 274, SCREEN_WIDTH, 20)];
        if (iPhone4) {
            _titleLab.frame = CGRectMake(0, 255, SCREEN_WIDTH, 20);
        }
        _titleLab.text = @"已完成第一单元";
        _titleLab.textColor = UIColorOfHex(0x666666);
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

- (UILabel *)studyTitleLab {
    if (!_studyTitleLab) {
        _studyTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 343, SCREEN_WIDTH, 20)];
        if (iPhone4) {
            _studyTitleLab.frame = CGRectMake(0, 300-NavHeight, SCREEN_WIDTH, 20);
        } else if (iPhone5) {
            _studyTitleLab.frame = CGRectMake(0, 300, SCREEN_WIDTH, 20);
        }
        _studyTitleLab.text = @"已学习";
        _studyTitleLab.textColor = UIColorOfHex(0x999999);
        _studyTitleLab.font = [UIFont systemFontOfSize:15];
        _studyTitleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_studyTitleLab];
    }
    return _studyTitleLab;
}

- (UILabel *)studyNumLab {
    if (!_studyNumLab) {
        _studyNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 362, SCREEN_WIDTH, 36)];
        if (iPhone4) {
            _studyNumLab.frame = CGRectMake(0, 321-NavHeight, SCREEN_WIDTH, 36);
        } else if (iPhone5) {
            _studyNumLab.frame = CGRectMake(0, 321, SCREEN_WIDTH, 36);
        }
        _studyNumLab.text = @"50";
        _studyNumLab.textColor = UIColorOfHex(0x1CB0F6);
        _studyNumLab.font = [UIFont boldSystemFontOfSize:32];
        _studyNumLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_studyNumLab];
    }
    return _studyNumLab;
}

- (UIButton *)enterNextBtn {
    if (!_enterNextBtn) {
        _enterNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterNextBtn setFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, 438, 200, 54)];
        if (iPhone4) {
            _enterNextBtn.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, 370-NavHeight, 200, 54);
        } else if (iPhone5) {
            _enterNextBtn.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, 370, 200, 54);
        }
        [_enterNextBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        [_enterNextBtn setBackgroundImage:[UIImage imageNamed:@"study_continue_btn"] forState:UIControlStateNormal];
        [_enterNextBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
        [_enterNextBtn setBackgroundColor:[UIColor clearColor]];
        [_enterNextBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_enterNextBtn addTarget:self action:@selector(enterNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _enterNextBtn.layer.cornerRadius = 27.0f;
        [self addSubview:_enterNextBtn];
    }
    return _enterNextBtn;
}

- (UIButton *)reCallingBtn {
    if (!_reCallingBtn) {
        _reCallingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reCallingBtn setFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, 492, 200, 54)];
        if (iPhone4) {
            _reCallingBtn.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, 438-NavHeight, 200, 54);
        } else if (iPhone5) {
            _reCallingBtn.frame = CGRectMake((SCREEN_WIDTH-200)/2.0, 438, 200, 54);
        }
        [_reCallingBtn setTitle:@"重新回顾" forState:UIControlStateNormal];
        [_reCallingBtn setTitleColor:UIColorOfHex(0x1CB0F6) forState:UIControlStateNormal];
        [_reCallingBtn setBackgroundColor:[UIColor clearColor]];
        [_reCallingBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_reCallingBtn addTarget:self action:@selector(reCallingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reCallingBtn];
    }
    return _reCallingBtn;
}


@end
