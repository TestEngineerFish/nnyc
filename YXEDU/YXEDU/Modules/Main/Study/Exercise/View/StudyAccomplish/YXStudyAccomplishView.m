//
//  YXStudyAccomplishView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/17.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXStudyAccomplishView.h"

@interface YXStudyAccomplishView()
@property (nonatomic, assign) NSInteger totalQuestionsCount;
@end

@implementation YXStudyAccomplishView

+ (YXStudyAccomplishView *)studyAccomplishShowToView:(UIView *)view totalQuestionsCount:(NSInteger)totoQuestionCount {
    YXStudyAccomplishView *accomplishView = [[YXStudyAccomplishView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    accomplishView.totalQuestionsCount = totoQuestionCount;
    [accomplishView layoutIfNeeded];
    [view addSubview:accomplishView];
    return accomplishView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:frame];
        [bgImage setImage:[UIImage imageNamed:@"StudyAccomplish背景"]];
        [self addSubview:bgImage];
    }
    return self;
}

- (void)setTotalQuestionsCount:(NSInteger)totalQuestionsCount {
    _totalQuestionsCount = totalQuestionsCount;
    [self configViews];
}

- (void)configViews {
    NSString *totoalStr = [NSString stringWithFormat:@"%zd", self.totalQuestionsCount];
    UIImageView *bubbleView = [[UIImageView alloc] init];
    [self addSubview:bubbleView];
    [bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).with.offset(-20);
        make.centerY.equalTo(self).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 150.f, 110.f));
    }];
    [bubbleView setImage:[UIImage imageNamed:@"StudyAccomplish框"]];


    UIImageView *squirrel = [[UIImageView alloc] init];
    [self addSubview:squirrel];
    [squirrel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bubbleView.mas_bottom);
        make.right.equalTo(bubbleView).with.offset(20.f);
        make.size.mas_equalTo(CGSizeMake(62.f, 110.5f));
    }];
    [squirrel setImage:[UIImage imageNamed:@"StudyAccomplish松鼠"]];


    UILabel *goodJobL = [[UILabel alloc] init];
    [bubbleView addSubview:goodJobL];
    [goodJobL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bubbleView);
        make.top.equalTo(bubbleView).with.offset(20.f);
        make.width.equalTo(bubbleView);
        make.height.mas_equalTo(25.f);
    }];
    [goodJobL setTextAlignment:NSTextAlignmentCenter];
    NSString *goodJobStr = @"Good job!!";
    NSMutableAttributedString *attrGoodJob = [[NSMutableAttributedString alloc] initWithString:goodJobStr];
    [attrGoodJob addAttributes:@{NSForegroundColorAttributeName:UIColorOfHex(0x434A5D)} range:NSRangeFromString(goodJobStr)];
    goodJobL.attributedText = attrGoodJob;
    goodJobL.font = [UIFont systemFontOfSize:AdaptSize(20)];

    UILabel *noteL = [[UILabel alloc] init];
    [bubbleView addSubview:noteL];
    [noteL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bubbleView);
        make.top.equalTo(goodJobL.mas_bottom).with.offset(5.f);
        make.width.equalTo(bubbleView);
        make.height.mas_equalTo(18.f);
    }];
    NSString *noteStr = [NSString stringWithFormat:@"又完成了%@个单词的学习!", totoalStr];
    [noteL setTextAlignment:NSTextAlignmentCenter];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:noteStr];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:AdaptSize(14.f)], NSForegroundColorAttributeName:UIColorOfHex(0x434A5D)} range:NSRangeFromString(noteStr)];
    [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size: 18], NSForegroundColorAttributeName:UIColorOfHex(0x0EADFD)} range:NSMakeRange(4, totoalStr.length)];
    noteL.attributedText = attr;
}

@end
