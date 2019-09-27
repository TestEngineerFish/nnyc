//
//  YXMissionCallenderView.m
//  YXEDU
//
//  Created by yixue on 2018/12/28.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXMissionCallenderView.h"

@interface YXMissionCallenderView ()

@property (nonatomic, assign) NSInteger numberOfCheckedDays;
@property (nonatomic, strong) NSMutableArray *checkInArray;

@end

@implementation YXMissionCallenderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self getData];
//        [self setupUI];
    }
    return self;
}

- (void)setUserSignIn:(NSString *)userSignIn {
    _userSignIn = userSignIn;
    [self getData];
    [self setupUI];
}

- (void)getData {
    _checkInArray = [[NSMutableArray alloc] initWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    //判断多少天已经签到 过滤掉 周日
//    _numberOfCheckedDays = _userSignIn.length;
    _numberOfCheckedDays = 0;
    for (NSInteger i = 0; i < _userSignIn.length; i++) {
        NSInteger itg = [[_userSignIn substringWithRange:NSMakeRange(i,1)] intValue];
        if (itg == 0) {
            _checkInArray[6] = @"1";
        } else {
            _checkInArray[itg - 1] = @"1";
            if (itg != 7) {
                _numberOfCheckedDays ++;
            }
        }
    }
}

- (void)setupUI {
    //self.backgroundColor = UIColorOfHex(0xeeeeee);
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    CALayer *line = [[CALayer alloc] init];
    line.backgroundColor = UIColorOfHex(0xeeeeee).CGColor;
    line.frame = CGRectMake(0, AdaptSize(14), self.width, 1);
    [self.layer addSublayer:line];
    
    CGFloat gap = (self.width - AdaptSize(210))/6;
    for (NSInteger i = 0; i < 7; i++) {
        UIView *dayView = [[UIView alloc] init];
        dayView.frame = CGRectMake((gap + AdaptSize(30)) * i, 0, AdaptSize(30), self.height);
        [self setCallenderDayView:dayView index:i];
        [self addSubview:dayView];
    }
    
}

- (void)setCallenderDayView:(UIView *)dayView index:(NSInteger)index {
    UIImageView *circle = [[UIImageView alloc] init];
    circle.frame = CGRectMake(0, 0, AdaptSize(30), AdaptSize(30));
    circle.layer.cornerRadius = AdaptSize(15);
    circle.backgroundColor = UIColorOfHex(0xEEF5FB);
    [dayView addSubview:circle];
    
    UILabel *scoreLbl = [[UILabel alloc] init];
    scoreLbl.frame = CGRectMake(AdaptSize(5), AdaptSize(5), AdaptSize(20), AdaptSize(20));
    scoreLbl.text = @"+10";
    NSInteger scoreOfSunday = 10 + _numberOfCheckedDays * 5;
    if (index == 6) { scoreLbl.text = [[NSString alloc] initWithFormat:@"%ld",(long)scoreOfSunday]; }
    //scoreLbl.backgroundColor = [UIColor redColor];
    scoreLbl.font = [UIFont systemFontOfSize:AdaptSize(10)];
    scoreLbl.textAlignment = NSTextAlignmentCenter;
    scoreLbl.textColor = UIColorOfHex(0x6B7F94);
    [circle addSubview:scoreLbl];
    if (index == [self getWeekDayFordate] && [_checkInArray[index]  isEqual: @"1"]) {
        circle.image = [UIImage imageNamed:@"Mission_header_preball"];
        scoreLbl.textColor = [UIColor whiteColor];
    } else if (index == [self getWeekDayFordate]){ //今天
        circle.image = [UIImage imageNamed:@"Mission_header_todayball"];
        circle.layer.frame = circle.frame;
        circle.layer.cornerRadius = circle.height / 2;
        circle.layer.shadowOffset = CGSizeMake(0,0);
        circle.layer.shadowOpacity = 0.5;
        circle.layer.shadowRadius = 5;
        circle.layer.shadowColor = [UIColor orangeColor].CGColor;
        scoreLbl.textColor = [UIColor whiteColor];
    } else if (index < [self getWeekDayFordate]) { //今天之前
        if ([_checkInArray[index]  isEqual: @"1"]) {
            circle.image = [UIImage imageNamed:@"Mission_header_preball"];
            scoreLbl.textColor = [UIColor whiteColor];
        }
    } else if (index > [self getWeekDayFordate]) { //今天之后
        circle.backgroundColor = [UIColor whiteColor];
        circle.layer.borderWidth = 1;
        circle.layer.borderColor = UIColorOfHex(0xEEF5FB).CGColor;
    }
    
    UILabel *dateLbl = [[UILabel alloc] init];
    dateLbl.frame = CGRectMake(0, AdaptSize(40), AdaptSize(30), AdaptSize(12));
    dateLbl.font = [UIFont systemFontOfSize:AdaptSize(12)];
    dateLbl.textAlignment = NSTextAlignmentCenter;
    
    dateLbl.text= [self getWeekStr:index];
    dateLbl.textColor = UIColorOfHex(0xA1B5CB);
    if ([dateLbl.text  isEqual: @"今天"]) { dateLbl.textColor = UIColorOfHex(0xFD9725); }
    
    [dayView addSubview:dateLbl];
}

- (NSString *)getWeekStr:(NSInteger)index {
    if (index == [self getWeekDayFordate]) { return @"今天"; }
    switch (index) {
        case 0:return @"周一";break;
        case 1:return @"周二";break;
        case 2:return @"周三";break;
        case 3:return @"周四";break;
        case 4:return @"周五";break;
        case 5:return @"周六";break;
        case 6:return @"周日";break;
        default:break;
    }
    return @"";
}

- (NSInteger)getWeekDayFordate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDate *now = [NSDate date];// 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    if ([comps weekday] - 2 == -1) { return 6; }
    return [comps weekday] - 2;
}

@end
