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
        UIImageView *msgBubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_msg_bubble"]];
        [self addSubview:msgBubble];
        [msgBubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        UIImageView *squirrel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_squirrel"]];
        [self addSubview:squirrel];
        [squirrel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(msgBubble.mas_centerY);
            make.left.equalTo(self).with.offset(AdaptSize(-13.f));
            make.size.mas_equalTo(CGSizeMake(AdaptSize(75.f), AdaptSize(84.f)));
        }];

        UILabel *title1 = [[UILabel alloc] init];
        title1.textColor = UIColorOfHex(0x888888);
        title1.font = [UIFont regularFontOfSize:12];
        title1.text = @"本月坚持学习";
        title1.textAlignment = NSTextAlignmentCenter;
        [msgBubble addSubview:title1];
        CGFloat titleWidth = (kSCREEN_WIDTH - AdaptSize(73.f) - AdaptSize(40.f))/3.f;
        [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(squirrel.mas_right);
            make.top.equalTo(msgBubble).with.offset(AdaptSize(20));
            make.width.mas_equalTo(titleWidth);
        }];

        UILabel *title2 = [[UILabel alloc] init];
        [msgBubble addSubview:title2];
        title2.textColor = UIColorOfHex(0x888888);
        title2.font = [UIFont regularFontOfSize:12];
        title2.text = @"累计学习单词";
        title2.textAlignment = NSTextAlignmentCenter;
        [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title1.mas_right);
            make.top.equalTo(title1);
            make.width.mas_equalTo(titleWidth);
        }];

        UILabel *title3 = [[UILabel alloc] init];
        [msgBubble addSubview:title3];
        title3.textColor = UIColorOfHex(0x888888);
        title3.font = [UIFont regularFontOfSize:12];
        title3.text = @"累计学习时长";
        title3.textAlignment = NSTextAlignmentCenter;
        [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title2.mas_right);
            make.top.equalTo(title1);
            make.width.mas_equalTo(titleWidth);
        }];

        _studyDaysLabel = [[UILabel alloc] init];
        [msgBubble addSubview:_studyDaysLabel];
        NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:@"--天" attributes:@{NSFontAttributeName: [UIFont semiboldFontOfSize:AdaptSize(14)],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
        [attrStr1 addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:AdaptSize(20)], NSForegroundColorAttributeName: UIColorOfHex(0xFBA217)} range:NSMakeRange(0, 2)];
        _studyDaysLabel.attributedText = attrStr1;
        _studyDaysLabel.textAlignment = NSTextAlignmentCenter;
        [_studyDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(title1);
            make.top.equalTo(title1.mas_bottom).with.offset(AdaptSize(3.f));
        }];

        _studyWordsLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:@"--个" attributes:@{NSFontAttributeName: [UIFont semiboldFontOfSize:AdaptSize(14)],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
        [attrStr2 addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:AdaptSize(20)], NSForegroundColorAttributeName: UIColorOfHex(0xFBA217)} range:NSMakeRange(0, 2)];
        _studyWordsLabel.attributedText = attrStr2;
        _studyWordsLabel.textAlignment = NSTextAlignmentCenter;
        [msgBubble addSubview:_studyWordsLabel];
        [_studyWordsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(title2);
            make.top.equalTo(title2.mas_bottom).with.offset(AdaptSize(3.f));
        }];

        _studyTimesLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr3 = [[NSMutableAttributedString alloc] initWithString:@"--分钟" attributes:@{NSFontAttributeName: [UIFont semiboldFontOfSize:AdaptSize(14)],NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
        [attrStr3 addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:AdaptSize(20)], NSForegroundColorAttributeName: UIColorOfHex(0xFBA217)} range:NSMakeRange(0, 2)];
        _studyTimesLabel.attributedText = attrStr3;
        _studyTimesLabel.textAlignment = NSTextAlignmentCenter;
        [msgBubble addSubview:_studyTimesLabel];
        [_studyTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.equalTo(title3);
            make.top.equalTo(title3.mas_bottom).with.offset(AdaptSize(3.f));
        }];
    }
    return self;
}

- (void)updateView: (YXStudyMonthSummaryModel *)model {
    NSString *daysStr = [NSString stringWithFormat:@"%ld天", model.study_days];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:daysStr attributes:@{NSFontAttributeName: [UIFont semiboldFontOfSize:AdaptSize(14)],NSForegroundColorAttributeName: UIColorOfHex(0x888888)}];
    [attrStr1 addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:AdaptSize(20)], NSForegroundColorAttributeName: UIColorOfHex(0xFBA217)} range:NSMakeRange(0, daysStr.length - 1)];
    self.studyDaysLabel.attributedText = attrStr1;

    NSString *wordsStr =[NSString stringWithFormat:@"%ld个", model.study_words];;
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc] initWithString:wordsStr attributes:@{NSFontAttributeName: [UIFont semiboldFontOfSize:AdaptSize(14)],NSForegroundColorAttributeName: UIColorOfHex(0x888888)}];
    [attrStr2 addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:AdaptSize(20)], NSForegroundColorAttributeName: UIColorOfHex(0xFBA217)} range:NSMakeRange(0, wordsStr.length - 1)];
    self.studyWordsLabel.attributedText = attrStr2;
    
    NSString *minuteStr = [[NSString stringWithFormat:@"%zd", model.study_times] getMinuteFromSecond];
    NSString *timesStr = [NSString stringWithFormat:@"%@分钟", minuteStr];
    NSMutableAttributedString *attrStr3 = [[NSMutableAttributedString alloc] initWithString:timesStr attributes:@{NSFontAttributeName: [UIFont semiboldFontOfSize:AdaptSize(14)],NSForegroundColorAttributeName: UIColorOfHex(0x888888)}];
    [attrStr3 addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:AdaptSize(20)], NSForegroundColorAttributeName: UIColorOfHex(0xFBA217)} range:NSMakeRange(0, timesStr.length - 2)];
    self.studyTimesLabel.attributedText = attrStr3;
}


@end
