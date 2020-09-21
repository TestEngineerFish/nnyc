//
//  YXSexPickverView.h
//  YXEDU
//
//  Created by Jake To on 10/12/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, YXBasePickverViewType) {
    SexType,
    BrithdayType,
    LocationType,
    GradeType,
    CalendarType,
    ClassType,
    BookEditionType
};

@class YXBasePickverView;

@protocol YXBasePickverViewDelegate <NSObject>

- (void)basePickverView:(YXBasePickverView *)pickverView withSelectedTitle:(NSString *)title;//DidSelectedInfo;

@end

@interface YXBasePickverView : UIView
@property (nonatomic, assign) YXBasePickverViewType type;
@property (nonatomic) UIPickerView *customPicker;
@property (nonatomic, weak) id<YXBasePickverViewDelegate> delegate;
@property (nonatomic, strong) NSArray *classArray;
@property (nonatomic, strong) NSArray *bookEditionArray;

+ (YXBasePickverView *)showSexPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>) delegate;
+ (YXBasePickverView *)showBirthdayPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>) delegate;
+ (YXBasePickverView *)showLocationPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>) delegate;
+ (YXBasePickverView *)showGradePickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>) delegate;
+ (YXBasePickverView *)showCalendarPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>) delegate;

+ (YXBasePickverView *)showClassTypeViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:(NSArray *)dataArray;

+ (YXBasePickverView *)showBookEditionViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:(NSArray *)dataArray;


@end

NS_ASSUME_NONNULL_END
