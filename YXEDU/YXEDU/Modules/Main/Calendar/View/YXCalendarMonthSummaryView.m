//
//  YXCalendarMonthSummaryView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/8.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarMonthSummaryView.h"

@interface YXCalendarMonthSummaryView()
@property (nonatomic, strong) UILabel *studyDaysLabel;
@property (nonatomic, strong) UILabel *studyWordsLabel;
@property (nonatomic, strong) UILabel *studyTimesLabel;
@end

@implementation YXCalendarMonthSummaryView

+ (YXCalendarMonthSummaryView *)showMonthSummaryView {
    YXCalendarMonthSummaryView *monthSummaryView = [[YXCalendarMonthSummaryView alloc] init];
    return monthSummaryView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *squirrel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_squirrel"]];
        [self addSubview:squirrel];
        [squirrel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(AdaptSize(55.f), AdaptSize(55.f)));
        }];

        UIImageView *msgBubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_msg_bubble"]];
        [self addSubview:msgBubble];
        [msgBubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(squirrel.mas_bottom).with.offset(-15.f);
        }];

        UILabel *title1 = [[UILabel alloc] init];
        title1.textColor = UIColorOfHex(0x8095AB);
        title1.font = [UIFont systemFontOfSize:AdaptSize(14.f)];
        title1.text = @"本月坚持学习";
        title1.textAlignment = NSTextAlignmentCenter;
        [msgBubble addSubview:title1];
        [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(msgBubble).with.offset(2.f);
            make.top.equalTo(msgBubble).with.offset(30.f);
            make.width.equalTo(msgBubble).multipliedBy(0.333);
        }];

        UILabel *title2 = [[UILabel alloc] init];
        [msgBubble addSubview:title2];
        title2.textColor = UIColorOfHex(0x8095AB);
        title2.font = [UIFont systemFontOfSize:AdaptSize(14.f)];
        title2.text = @"累计学习单词";
        title2.textAlignment = NSTextAlignmentCenter;
        [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title1.mas_right);
            make.top.equalTo(title1);
            make.width.equalTo(msgBubble).multipliedBy(0.333);
        }];

        UILabel *title3 = [[UILabel alloc] init];
        [msgBubble addSubview:title3];
        title3.textColor = UIColorOfHex(0x8095AB);
        title3.font = [UIFont systemFontOfSize:AdaptSize(14.f)];
        title3.text = @"累计学习时长";
        title3.textAlignment = NSTextAlignmentCenter;
        [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title2.mas_right);
            make.top.equalTo(title1);
            make.width.equalTo(msgBubble).multipliedBy(0.333);
        }];

        _studyDaysLabel = [[UILabel alloc] init];
        [msgBubble addSubview:_studyDaysLabel];
        NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:@"--天" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
        [attrStr1 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18], NSForegroundColorAttributeName: UIColorOfHex(0x59B2F3)} range:NSMakeRange(0, 2)];
        _studyDaysLabel.attributedText = attrStr1;
        _studyDaysLabel.textAlignment = NSTextAlignmentCenter;
        [_studyDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(msgBubble);
            make.top.equalTo(title1.mas_bottom).with.offset(10.f);
            make.width.equalTo(msgBubble).multipliedBy(0.333);
        }];

        _studyWordsLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:@"--个" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
        [attrStr2 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18], NSForegroundColorAttributeName: UIColorOfHex(0x59B2F3)} range:NSMakeRange(0, 2)];
        _studyWordsLabel.attributedText = attrStr2;
        _studyWordsLabel.textAlignment = NSTextAlignmentCenter;
        [msgBubble addSubview:_studyWordsLabel];
        [_studyWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_studyDaysLabel.mas_right);
            make.top.equalTo(title2.mas_bottom).with.offset(10.f);
            make.width.equalTo(msgBubble).multipliedBy(0.333);
        }];

        _studyTimesLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr3 = [[NSMutableAttributedString alloc] initWithString:@"--单词" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
        [attrStr3 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18], NSForegroundColorAttributeName: UIColorOfHex(0x59B2F3)} range:NSMakeRange(0, 2)];
        _studyTimesLabel.attributedText = attrStr3;
        _studyTimesLabel.textAlignment = NSTextAlignmentCenter;
        [msgBubble addSubview:_studyTimesLabel];
        [_studyTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_studyWordsLabel.mas_right);
            make.top.equalTo(title3.mas_bottom).with.offset(10.f);
            make.width.equalTo(msgBubble).multipliedBy(0.333);
        }];
    }
    return self;
}

- (void)updateView: (YXStudyMonthSummaryModel *)model {
    NSString *daysStr = [NSString stringWithFormat:@"%ld天", model.studyDays];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:daysStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
    [attrStr1 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18], NSForegroundColorAttributeName: UIColorOfHex(0x59B2F3)} range:NSMakeRange(0, daysStr.length - 1)];
    self.studyDaysLabel.attributedText = attrStr1;

    NSString *wordsStr =[NSString stringWithFormat:@"%ld个", model.studyWords];;
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:wordsStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
    [attrStr2 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18], NSForegroundColorAttributeName: UIColorOfHex(0x59B2F3)} range:NSMakeRange(0, wordsStr.length - 1)];
    self.studyWordsLabel.attributedText = attrStr2;

    NSString *minuteStr = [[NSString stringWithFormat:@"%zd", model.studyTimes] getMinuteFromSecond];
    NSString *timesStr = [NSString stringWithFormat:@"%@分钟", minuteStr];
    NSMutableAttributedString *attrStr3 = [[NSMutableAttributedString alloc] initWithString:timesStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 14],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
    [attrStr3 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 18], NSForegroundColorAttributeName: UIColorOfHex(0x59B2F3)} range:NSMakeRange(0, timesStr.length - 2)];
    self.studyTimesLabel.attributedText = attrStr3;
}


@end
