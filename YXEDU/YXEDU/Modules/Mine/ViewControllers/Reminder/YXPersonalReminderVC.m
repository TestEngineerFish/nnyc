//
//  YXPersonalProfileVC.m
//  YXEDU
//
//  Created by shiji on 2018/9/4.
//  Copyright © 2018年 shiji. All rights reserved.
//
#import "BSCommon.h"

#import "YXPersonalReminderVC.h"
#import <UserNotifications/UserNotifications.h>

@interface YXPersonalReminderVC ()

@property (nonatomic, strong) UISwitch *isReminderSwitch;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, weak)   UIView *bottomView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation YXPersonalReminderVC
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewDidLoad];
    [self createSubviews];
    [self bindProperty];
    [self switchTaped];
}

- (void) createSubviews {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];

    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = UIColorOfHex(0xedf2f6);
    [self.bgView addSubview:sepLine];

    UILabel *switchLabel = [[UILabel alloc] init];
    switchLabel.text = @"每日提醒";
    switchLabel.textColor = UIColorOfHex(0x485461);
    switchLabel.backgroundColor = [UIColor whiteColor];

    self.isReminderSwitch = [[UISwitch alloc] init];
    [self.isReminderSwitch addTarget:self action:@selector(switchTaped) forControlEvents:UIControlEventValueChanged];
    self.isReminderSwitch.tintColor = UIColorOfHex(0xE5E5E5);
    self.isReminderSwitch.onTintColor = UIColorOfHex(0xFBA217);

    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 44)];
    intervalView.backgroundColor = UIColorOfHex(0xF5F5F5);
    UILabel *intervalLabel = [[UILabel alloc] init];
    intervalLabel.text = @"开启每日提醒，不错过每天的背单词计划";
    [intervalLabel setFont:[UIFont systemFontOfSize:14]];
    intervalLabel.textColor = UIColorOfHex(0x888888);
    [self.view addSubview:switchLabel];
    [self.view addSubview:self.isReminderSwitch];
    [self.view addSubview:intervalView];
    [intervalView addSubview:intervalLabel];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(8);
        make.height.mas_equalTo(70);
    }];

    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bgView);
        make.height.mas_equalTo(1.0);
    }];

    [switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.centerY.equalTo(self.bgView);//.offset(25);

    }];

    [self.isReminderSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-16);
        make.centerY.equalTo(self.bgView).offset(-2);
    }];

    [intervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.centerY.equalTo(intervalView);
    }];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(intervalView.mas_bottom);
    }];
    _bottomView = bottomView;
}

- (void) bindProperty {
    self.view.backgroundColor = UIColorOfHex(0xF5F5F5);

    if ([YXSetReminderView getReminderDate] == nil) {
        self.remindDate = nil;
        [self.isReminderSwitch setOn:NO];
    } else {
        self.remindDate = [YXSetReminderView getReminderDate];
        [self.isReminderSwitch setOn:YES];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(8);
        make.height.mas_equalTo(70);
    }];
}

- (void) switchTaped {
    self.bottomView.hidden = !self.isReminderSwitch.isOn;
    if (self.isReminderSwitch.isOn) {
        YXLog(@"开启每日提醒");
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = @"提醒时间";
        self.timeLabel.textColor = UIColorOfHex(0x485461);

        self.datePicker = [[UIDatePicker alloc] init];
        [self.datePicker setDatePickerMode:UIDatePickerModeTime];
        [self.datePicker setValue:UIColorOfHex(0x485461) forKey:@"textColor"];
        if (@available(iOS 13.4, *)) {
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        if (self.remindDate == nil) {
            NSString *remindDateString = @"20:00";
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            self.datePicker.date = [dateFormatter dateFromString:remindDateString];

        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            self.datePicker.date = self.remindDate;
        }
        
        [self.bottomView addSubview:self.timeLabel];
        [self.bottomView addSubview:self.datePicker];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(16);
            make.top.equalTo(self.bottomView).offset(23);
        }];
        
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(20);
        }];
    } else {
        YXLog(@"关闭每日提醒");
        [self.timeLabel removeFromSuperview];
        [self.datePicker removeFromSuperview];
    }
}

- (void) done {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            YXLog(@"授权本地通知成功");
        }
    }];

    if (self.isReminderSwitch.isOn) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        NSCalendar *calendar                  = [NSCalendar currentCalendar];
        NSDateComponents *components          = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:self.datePicker.date];
        
        NSDate *date  = [calendar dateFromComponents:components];
        content.title = @"每日提醒";
        content.body  = @"今天的背单词计划还未完成哦，戳我一下马上开始学习~";
        content.sound = [UNNotificationSound defaultSound];
        content.badge = [NSNumber numberWithInt: (int)([UIApplication sharedApplication].applicationIconBadgeNumber) + 1];
        UNCalendarNotificationTrigger * _Nonnull trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Reminder" content:content trigger:trigger];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *remindDateString = [dateFormatter stringFromDate:date];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                YXLog(@"添加每日提醒成功，时间:%@", remindDateString);
            }
        }];
        
        [YXSetReminderView didSetReminderWithDidOpen:1 time:[NSNumber numberWithDouble:[self.datePicker.date timeIntervalSince1970]]];
        [YXSetReminderView setReminderTimeWithDate: self.datePicker.date];

    } else {
        [YXSetReminderView didSetReminderWithDidOpen:0 time:0];
        [YXSetReminderView setReminderTimeWithDate: nil];
    }

    [self.navigationController popViewControllerAnimated:YES];
}




@end
