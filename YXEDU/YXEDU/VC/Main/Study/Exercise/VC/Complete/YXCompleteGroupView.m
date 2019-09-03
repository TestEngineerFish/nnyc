//
//  YXCompleteGroupView.m
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCompleteGroupView.h"
#import "BSCommon.h"
#import "YXStudyCmdCenter.h"
#import "YXCommHeader.h"

@interface YXCompleteGroupView ()
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *studyTitleLab;
@property (nonatomic, strong) UILabel *studyNumLab;
@property (nonatomic, strong) UIButton *enterNextBtn;
@end

@implementation YXCompleteGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorOfHex(0xf0f0f0);
        
    }
    return self;
}

- (void)enterNextBtnClicked:(id)sender {
    [[YXStudyCmdCenter shared]studyAction:YXActionSelectImageContinue];
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
    [self reloadData];
}
- (void)removeAllSubViews {
    RELEASE(_titleImage);
    RELEASE(_titleLab);
    RELEASE(_studyTitleLab);
    RELEASE(_studyNumLab);
    RELEASE(_enterNextBtn);
}

- (void)reloadData {
    self.titleLab.text = [NSString stringWithFormat:@"已完成第%ld组", [[YXStudyCmdCenter shared]groupIndex]+1];
    self.studyNumLab.text = [[YXStudyCmdCenter shared]groupWordCount];
}

#pragma mark -lazy load view-
- (UIImageView *)titleImage {
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-222)/2.0, 56, 222, 193)];
        _titleImage.image = [UIImage imageNamed:@"study_cup"];
        [self addSubview:_titleImage];
    }
    return _titleImage;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 274, SCREEN_WIDTH, 20)];
        _titleLab.text = @"已完成第组";
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
        _studyTitleLab.text = @"已学习";
        _studyTitleLab.textColor = UIColorOfHex(0x999999);
        _studyTitleLab.font = [UIFont systemFontOfSize:15];
        _studyTitleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_studyTitleLab];
        if (iPhone4) {
            _studyTitleLab.frame = CGRectMake(0, 303, SCREEN_WIDTH, 20);
        }
    }
    return _studyTitleLab;
}

- (UILabel *)studyNumLab {
    if (!_studyNumLab) {
        _studyNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 362, SCREEN_WIDTH, 36)];
        _studyNumLab.text = @"50";
        _studyNumLab.textColor = UIColorOfHex(0x1CB0F6);
        _studyNumLab.font = [UIFont boldSystemFontOfSize:32];
        _studyNumLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_studyNumLab];
        if (iPhone4) {
            _studyNumLab.frame = CGRectMake(0, 332, SCREEN_WIDTH, 36);
        }
    }
    return _studyNumLab;
}

- (UIButton *)enterNextBtn {
    if (!_enterNextBtn) {
        _enterNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterNextBtn setFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, 438, 200, 54)];
        [_enterNextBtn setTitle:@"下一组" forState:UIControlStateNormal];
        [_enterNextBtn setBackgroundImage:[UIImage imageNamed:@"study_continue_btn"] forState:UIControlStateNormal];
        [_enterNextBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
        [_enterNextBtn setBackgroundColor:[UIColor clearColor]];
        [_enterNextBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_enterNextBtn addTarget:self action:@selector(enterNextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _enterNextBtn.layer.cornerRadius = 27.0f;
        [self addSubview:_enterNextBtn];
        if (iPhone4) {
            [_enterNextBtn setFrame:CGRectMake((SCREEN_WIDTH-200)/2.0, 360, 200, 54)];
        }
    }
    return _enterNextBtn;
}

@end
