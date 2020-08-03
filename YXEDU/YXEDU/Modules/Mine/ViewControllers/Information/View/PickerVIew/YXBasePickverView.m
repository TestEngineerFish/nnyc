//
//  YXSexPickverView.m
//  YXEDU
//
//  Created by Jake To on 10/12/18.
//  Copyright © 2018 shiji. All rights reserved.
//
#import "YXBasePickverView.h"
#import "YXModel.h"
#import "NSDate+Extension.h"

@interface YXBasePickverView() <UIPickerViewDelegate, UIPickerViewDataSource>

//MARK: - Properties



@property (nonatomic, strong) UIView *containerBarView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic) UIDatePicker *datePicker;

@property (nonatomic) NSArray *sexArray;
@property (nonatomic) NSArray *locationArray;
@property (nonatomic) NSArray *gradeArray;
//calendar pick view
@property (nonatomic, strong) NSMutableArray<NSString *> *yearsArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *monthsArray;

@property (nonatomic) NSInteger provinceIndex;

@property (nonatomic, copy)NSString *confirmString;
@end

@implementation YXBasePickverView

//MARK: - Lazy Load Data

- (NSArray *)sexArray {
    if (!_sexArray) {
        _sexArray = @[@"男", @"女"];
    }
    
    return _sexArray;
}

-(NSArray *)locationArray {
    if (!_locationArray) {
        NSString *pathString = [[NSBundle mainBundle] pathForResource:@"location.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:pathString];
        NSError *error = nil;
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSArray *provinceNames = [result valueForKey:@"name"];
        
        NSArray *citylist = [result valueForKey:@"city"];
        NSArray *cityNames = [citylist valueForKey:@"name"];
    
        _locationArray = @[provinceNames, cityNames];
    }
    
    return _locationArray;
}

- (NSArray *)gradeArray {
    if (!_gradeArray) {
        _gradeArray = @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"七年级", @"八年级", @"九年级", @"高中"];
    }
    
    return _gradeArray;
}

- (NSArray<NSString *> *)yearsArray {
    if (!_yearsArray) {
        NSDate *today = [NSDate new];
        _yearsArray = [[NSMutableArray alloc] init];
        for (int i = 1970; i <= today.year; ++i) {
            [_yearsArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _yearsArray;
}

- (NSMutableArray<NSString *> *)monthsArray {
    if (!_monthsArray) {
        _monthsArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 12; ++i) {
            [_monthsArray addObject: [NSString stringWithFormat:@"%d", i]];
        }
    }
    return _monthsArray;
}


//MARK: - Class Functions
+ (YXBasePickverView *)showSexPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate {
    YXBasePickverView *view = [[self alloc] initWithPickViewType:SexType with:info andDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:nil];
    return view;
}

+ (YXBasePickverView *)showBirthdayPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate {
    YXBasePickverView *view = [[self alloc] initWithPickViewType:BrithdayType with:info andDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:nil];
    return view;
}

+ (YXBasePickverView *)showLocationPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate {
    YXBasePickverView *view = [[self alloc] initWithPickViewType:LocationType with:info andDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:nil];
    return view;
}

+ (YXBasePickverView *)showGradePickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate {
    YXBasePickverView *view = [[self alloc] initWithPickViewType:GradeType with:info andDelegate:delegate dataArray:nil];
    return view;
}
+ (YXBasePickverView *)showCalendarPickerViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate {
    YXBasePickverView *view = [[self alloc] initWithPickViewType:CalendarType with:info andDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:nil];
    return view;
}

+ (YXBasePickverView *)showClassTypeViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:(NSArray *)dataArray{
    YXBasePickverView *view = [[self alloc] initWithPickViewType:ClassType with:info andDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:dataArray];
    return view;
}

+ (YXBasePickverView *)showBookEditionViewOn:(NSString *)info withDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:(NSArray *)dataArray {
    YXBasePickverView *view = [[self alloc] initWithPickViewType:BookEditionType with:info andDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:dataArray];
    return view;
}


//MARK: - Init

- (instancetype)initWithPickViewType:(YXBasePickverViewType)type with:(NSString *)string andDelegate:(id<YXBasePickverViewDelegate>)delegate dataArray:(NSArray *)dataArray{
    
    if (self = [super init]) {
        
        self.type = type;
        self.delegate = delegate;
        
        self.customPicker.delegate = self;
        self.customPicker.dataSource = self;
        
        if (self.type == BrithdayType) {
            [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.containerView);
            }];
            
            if ([string isEqualToString:@"未设置"]) {
                self.datePicker.date = [NSDate date];
            } else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                self.datePicker.date = [dateFormatter dateFromString:string];
            }
        } else {
            [self.customPicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.containerView);
            }];
            
            if ([string isEqualToString:@"未设置"]) {
                switch (self.type) {
                    case SexType:
                    {
                        NSInteger index = [self.sexArray indexOfObject:@"男"];
                        [self.customPicker selectRow:index inComponent:0 animated:YES];
                    }
                        break;
                        
                    case LocationType:
                    {
                        NSArray *array = [@"上海市,上海市" componentsSeparatedByString:@","];
                        
                        self.provinceIndex = [self.locationArray[0] indexOfObject:array[0]];
                        [self.customPicker selectRow:self.provinceIndex inComponent:0 animated:YES];
                        
                        NSArray *citylist = self.locationArray[1];
                        NSArray *cities = citylist[self.provinceIndex];
                        NSInteger cityIndex = [cities indexOfObject:array[1]];
                        [self.customPicker selectRow:cityIndex inComponent:1 animated:YES];
                    }
                        break;
                        
                    case GradeType:
                    {
                        NSInteger index = [self.gradeArray indexOfObject:@"一年级"];
                        [self.customPicker selectRow:index inComponent:0 animated:YES];
                    }
                        break;
                        
                    case CalendarType:
                    {
                        [self.customPicker selectRow:0 inComponent:0 animated:YES];
                        [self.customPicker selectRow:0 inComponent:1 animated:YES];
                    }
                        break;
                     
                    case ClassType:
                    {
                        self.classArray = [dataArray mutableCopy];
                        
                        [self.customPicker selectRow:0 inComponent:0 animated:YES];
                    }
                        break;
                    case BookEditionType:
                    {
                        self.bookEditionArray = [dataArray mutableCopy];
                        
                        [self.customPicker selectRow:0 inComponent:0 animated:YES];
                    }
                        break;
                        
                        
                    default:
                        break;
                }
            } else {
                switch (self.type) {
                    case SexType:
                    {
                        NSInteger index = [self.sexArray indexOfObject:string];
                        [self.customPicker selectRow:index inComponent:0 animated:YES];
                    }
                        break;
                        
                    case LocationType:
                    {
                        NSArray *array;
                        if ([string containsString:@","]) {
                            array = [string componentsSeparatedByString:@","];
                        }else {
                            array = [string componentsSeparatedByString:@"，"];
                        }

                        if ([self.locationArray containsObject:array[0]]) {
                            self.provinceIndex = [self.locationArray[0] indexOfObject:array[0]];
                        } else {
                            self.provinceIndex = 0;
                        }
                        [self.customPicker selectRow:self.provinceIndex inComponent:0 animated:YES];
                        [self.customPicker reloadComponent:1];
                        
                        NSArray *citylist = self.locationArray[1];
                        NSArray *cities = citylist[self.provinceIndex];
                        NSInteger cityIndex = 0;
                        if (array.count > 1 && [cities containsObject:array[1]]) {
                            cityIndex = [cities indexOfObject:array[1]];
                        }
                        [self.customPicker selectRow:cityIndex inComponent:1 animated:YES];
                    }
                        break;
                        
                    case GradeType:
                    {
                        NSInteger index = [self.gradeArray indexOfObject:string];
                        [self.customPicker selectRow:index inComponent:0 animated:YES];
                    }
                        break;
                        
                    case CalendarType:
                    {
                        NSArray *array;
                        if ([string containsString:@","]) {
                            array = [string componentsSeparatedByString:@","];
                        }else {
                            array = [string componentsSeparatedByString:@"，"];
                        }
                        NSInteger yearIndex = [self.yearsArray indexOfObject:array[0]];
                        [self.customPicker selectRow:yearIndex inComponent:0 animated:YES];
                        [self.customPicker reloadComponent:1];
                        
                        NSInteger monthIndex = [self.monthsArray indexOfObject:array[1]];
                        [self.customPicker selectRow:monthIndex inComponent:1 animated:YES];
                    }
                        break;
                        
                    case ClassType:
                    {
                        self.classArray = [dataArray mutableCopy];
                        NSInteger index = [self.classArray indexOfObject:string];
                        [self.customPicker selectRow:index inComponent:0 animated:YES];
                    }
                        break;
                        
                    case BookEditionType:
                    {
                        self.bookEditionArray = [dataArray mutableCopy];
                        NSInteger index = [self.bookEditionArray indexOfObject:string];
                        [self.customPicker selectRow:index inComponent:0 animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containerBarView);
            make.centerY.equalTo(self.containerBarView).offset(-4);
        }];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    
    return self;
}

//MARK: - LoadView

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setDate:[NSDate date]];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-Hans"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *minDateStr = @"1949-1-1";
        _datePicker.minimumDate = [dateFormatter dateFromString:minDateStr];
        _datePicker.maximumDate = [NSDate date];
        [self.containerView addSubview:_datePicker];
    }

    return _datePicker;
}

- (UIPickerView *)customPicker {
    if (!_customPicker) {
        _customPicker = [[UIPickerView alloc] init];
        _customPicker.backgroundColor = UIColor.whiteColor;
        _customPicker.delegate = self;
        _customPicker.dataSource = self;
        
        [self.containerView addSubview:_customPicker];
    }
    
    return _customPicker;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = UIColorOfHex(0x888888);
        
        switch (self.type) {
            case SexType:
                _descriptionLabel.text = @"请选择性别";
                break;
            case BrithdayType:
                _descriptionLabel.text = @"请选择出生日期";
                break;
            case LocationType:
                _descriptionLabel.text = @"请选择省份和城市";
                break;
            case GradeType:
                _descriptionLabel.text = @"请选择年级";
                break;
            case CalendarType:
                _descriptionLabel.text = @"请选择年份和月份";
                break;
                
            case ClassType:
                _descriptionLabel.text = @"请选择年级";
                break;
                
            case BookEditionType:
                _descriptionLabel.text = @"请选择教材版本";
                break;
                
            default:
                break;
        }
        
        [self.containerBarView addSubview:_descriptionLabel];
    }
    
    return _descriptionLabel;
}

- (void)setUpSubviews {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *containerBarView = [[UIView alloc] init];
    containerBarView.backgroundColor = UIColorOfHex(0xFAF9F9);
    containerBarView.layer.cornerRadius = 8;
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = UIColor.whiteColor;
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doneButton = [[UIButton alloc] init];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:UIColorOfHex(0x485461) forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:containerView];
    _containerView = containerView;
    [self addSubview:containerBarView];
    [self sendSubviewToBack:containerBarView];
    _containerBarView = containerBarView;
    [containerBarView addSubview:cancelButton];
    [containerBarView addSubview:doneButton];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(216);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [containerBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(64);
        make.bottom.equalTo(self).offset(-208);
        make.centerX.equalTo(self);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerBarView).offset(15);
        make.centerY.equalTo(containerBarView).offset(-4);
    }];
    
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerBarView).offset(-15);
        make.centerY.equalTo(containerBarView).offset(-4);
    }];
}

// MARK: - PickerView Delagates
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {

    if (self.type == SexType) {
        return 1;
    } else if (self.type == LocationType) {
        return 2;
    } else if (self.type == GradeType) {
        return 1;
    } else if (self.type == CalendarType) {
        return 2;
    }
    else if (self.type == ClassType) {
        return 1;
    }
    else if (self.type == BookEditionType) {
        return 1;
    }else {
        return 0;
    }
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (self.type == SexType) {
        return self.sexArray.count;
    } else if (self.type == LocationType) {
        
        NSArray *provinces = self.locationArray[0];
        
        NSArray *citylist = self.locationArray[1];
        NSArray *cities;
        if (self.provinceIndex >= 0) {
            cities = citylist[self.provinceIndex];
        } else {
            cities = citylist[[pickerView selectedRowInComponent:0]];
        }

        if (component == 0) {
            return provinces.count;
        } else if (component == 1) {
            return cities.count;
        } else {
            return 0;
        }
        
    } else if (self.type == GradeType) {
        return self.gradeArray.count;
    } else if (self.type == CalendarType) {
        
        if (component == 0) {
            return self.yearsArray.count;
        }
        
//        NSInteger yearIndex = [pickerView selectedRowInComponent:0];

//        NSString *selectYear = self.yearsArray[yearIndex];
//        if (yearIndex == 0){
//            selectYear = self.yearsArray.lastObject;
//        }
        
//        NSString *currentYear = [NSString stringWithFormat:@"%lu", (unsigned long)[NSDate new].year];
//        NSUInteger monthCount = self.monthsArray.count;
//        if ([selectYear isEqualToString:currentYear]) {
//            monthCount = [NSDate new].month;
//        }

        return 12;
    }
    else if (self.type == ClassType) {
        return self.classArray.count;
    }
    
    else if (self.type == BookEditionType) {
        return self.bookEditionArray.count;
    }else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (self.type == SexType) {
        return self.sexArray[row];
    } else if (self.type == LocationType) {

        NSArray *provinces = self.locationArray[0];
        NSArray *citylist = self.locationArray[1];
        NSArray *cities;
        if (self.provinceIndex >= 0) {
            cities = citylist[self.provinceIndex];
        } else {
            cities = citylist[[pickerView selectedRowInComponent:0]];
        }
        
        if (component == 0) {
            return provinces[row];
        } else if (component == 1) {
            return cities[row];
        } else {
            return @"";
        }
        
    } else if (self.type == GradeType) {
        return self.gradeArray[row];
    } else if (self.type == CalendarType) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%@年", self.yearsArray[row]];
        } else if (component == 1) {
            return [NSString stringWithFormat:@"%@月", self.monthsArray[row]];
        } else {
            return @"";
        }
    }
    else if (self.type == ClassType) {
        return self.classArray[row];
    }
    
    else if (self.type == BookEditionType) {
        return self.bookEditionArray[row];
    }else {
        return nil;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = UIColorOfHex(0xE1EBF0);
        }
    }

    UILabel *label = (UILabel*)view;

    if (!label){

        label = [[UILabel alloc] init];
        [label setTextColor:UIColorOfHex(0x485461)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
    }

    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];

    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.type == LocationType) {
        self.provinceIndex = [pickerView selectedRowInComponent:0];;
        
        if(component == 0) {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
    }
    
    if (self.type == CalendarType) {
        if(component == 0) {
            [pickerView reloadComponent:1];
            
        } else {
            [pickerView reloadAllComponents];
        }
        
    } else {
        [pickerView reloadAllComponents];
    }
    
}

// MARK: - Cancel and Done Methods
- (void)cancelAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemovePickerView" object:nil];
}

- (void)doneAction:(id)sender {

    NSString *result = nil;//[[NSString alloc] init];

    if (self.type == SexType) {
        result = self.sexArray[[self.customPicker selectedRowInComponent:0]];
        
        if ([result isEqualToString:@"女"]) {
            [self setUpKey:@"sex" withValue:@"2"];
        } else if ([result isEqualToString:@"男"]) {
            [self setUpKey:@"sex" withValue:@"1"];
        } else {
            [self setUpKey:@"sex" withValue:@"0"];
        }
        
    } else if (self.type == BrithdayType) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        result = [dateFormatter stringFromDate:self.datePicker.date];
        
        [self setUpKey:@"birthday" withValue:result];

    } else if (self.type == CalendarType) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSUInteger yearIndex = [self.customPicker selectedRowInComponent:0];
        NSUInteger monthIndex = [self.customPicker selectedRowInComponent:1];
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@", self.yearsArray[yearIndex], self.monthsArray[monthIndex]];
        result = dateStr;
    } else if (self.type == LocationType) {
        NSString *province = self.locationArray[0][[self.customPicker selectedRowInComponent:0]];
        NSString *city = self.locationArray[1][[self.customPicker selectedRowInComponent:0]][[self.customPicker selectedRowInComponent:1]];
        result = [NSString stringWithFormat:@"%@,%@", province, city];
        
        [self setUpKey:@"area" withValue:result];

    } else if (self.type == GradeType) {
        result = self.gradeArray[[self.customPicker selectedRowInComponent:0]];
        
        if ([result isEqualToString:@"一年级"]) {
            [self setUpKey:@"grade" withValue:@"1"];
        } else if ([result isEqualToString:@"二年级"]) {
            [self setUpKey:@"grade" withValue:@"2"];
        } else if ([result isEqualToString:@"三年级"]) {
            [self setUpKey:@"grade" withValue:@"3"];
        } else if ([result isEqualToString:@"四年级"]) {
            [self setUpKey:@"grade" withValue:@"4"];
        } else if ([result isEqualToString:@"五年级"]) {
            [self setUpKey:@"grade" withValue:@"5"];
        } else if ([result isEqualToString:@"六年级"]) {
            [self setUpKey:@"grade" withValue:@"6"];
        } else if ([result isEqualToString:@"七年级"]) {
            [self setUpKey:@"grade" withValue:@"7"];
        } else if ([result isEqualToString:@"八年级"]) {
            [self setUpKey:@"grade" withValue:@"8"];
        } else if ([result isEqualToString:@"九年级"]) {
            [self setUpKey:@"grade" withValue:@"9"];
        } else if ([result isEqualToString:@"高中"]) {
            [self setUpKey:@"grade" withValue:@"10"];
        } else {
            [self setUpKey:@"grade" withValue:@"11"];
        }
    }
    else if (self.type == ClassType) {
        
        result = self.classArray[[self.customPicker selectedRowInComponent:0]];
        
        if ([result isEqualToString:@"一年级"]) {
            [self setUpKey:@"grade" withValue:@"1"];
        } else if ([result isEqualToString:@"二年级"]) {
            [self setUpKey:@"grade" withValue:@"2"];
        } else if ([result isEqualToString:@"三年级"]) {
            [self setUpKey:@"grade" withValue:@"3"];
        } else if ([result isEqualToString:@"四年级"]) {
            [self setUpKey:@"grade" withValue:@"4"];
        } else if ([result isEqualToString:@"五年级"]) {
            [self setUpKey:@"grade" withValue:@"5"];
        } else if ([result isEqualToString:@"六年级"]) {
            [self setUpKey:@"grade" withValue:@"6"];
        } else if ([result isEqualToString:@"七年级"]) {
            [self setUpKey:@"grade" withValue:@"7"];
        } else if ([result isEqualToString:@"八年级"]) {
            [self setUpKey:@"grade" withValue:@"8"];
        } else if ([result isEqualToString:@"九年级"]) {
            [self setUpKey:@"grade" withValue:@"9"];
        } else if ([result isEqualToString:@"高中"]) {
            [self setUpKey:@"grade" withValue:@"10"];
        } else {
            [self setUpKey:@"grade" withValue:@"11"];
        }
    }
    else if (self.type == BookEditionType) {
        
        result = self.bookEditionArray[[self.customPicker selectedRowInComponent:0]];
        
        if ([result isEqualToString:@"一年级"]) {
            [self setUpKey:@"grade" withValue:@"1"];
        } else if ([result isEqualToString:@"二年级"]) {
            [self setUpKey:@"grade" withValue:@"2"];
        } else if ([result isEqualToString:@"三年级"]) {
            [self setUpKey:@"grade" withValue:@"3"];
        } else if ([result isEqualToString:@"四年级"]) {
            [self setUpKey:@"grade" withValue:@"4"];
        } else if ([result isEqualToString:@"五年级"]) {
            [self setUpKey:@"grade" withValue:@"5"];
        } else if ([result isEqualToString:@"六年级"]) {
            [self setUpKey:@"grade" withValue:@"6"];
        } else if ([result isEqualToString:@"七年级"]) {
            [self setUpKey:@"grade" withValue:@"7"];
        } else if ([result isEqualToString:@"八年级"]) {
            [self setUpKey:@"grade" withValue:@"8"];
        } else if ([result isEqualToString:@"九年级"]) {
            [self setUpKey:@"grade" withValue:@"9"];
        } else if ([result isEqualToString:@"高中"]) {
            [self setUpKey:@"grade" withValue:@"10"];
        } else {
            [self setUpKey:@"grade" withValue:@"11"];
        }
    }
    
    self.confirmString = result;
    if ([self.delegate respondsToSelector:@selector(basePickverView:withSelectedTitle:)]) {
        [self.delegate basePickverView:self withSelectedTitle:self.confirmString];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemovePickerView" object:nil];
}

- (void)setUpKey:(NSString *)key withValue:(NSString *)value {
    
    NSDictionary *paramter = nil;

    if ([value isEqualToString:@"0"] || [value isEqualToString:@"1"] ||[value isEqualToString:@"2"]) {
        NSNumber *intValue = [NSNumber numberWithInt:[value intValue]];
        paramter = @{key:intValue};
    } else if ([value isEqualToString:@"7"] || [value isEqualToString:@"8"] ||[value isEqualToString:@"9"]) {
        NSNumber *intValue = [NSNumber numberWithInt:[value intValue]];
        paramter = @{key:intValue};
    } else {
        paramter = @{key:value};
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[YYNetworkService default] ocRequestWithType:YXOCRequestTypeChangeUserInfo params:paramter isUpload:NO success:^(YXOCModel* model) {
        if (model != nil) {
            [weakSelf saveInfoSuccess];
        }
        
    } fail:^(NSError* error) {
        YXLog(@"更改年级失败");
    }];
}

- (void)saveInfoSuccess {
    if ([self.delegate respondsToSelector:@selector(basePickverView:withSelectedTitle:)]) {
        [self.delegate basePickverView:self withSelectedTitle:self.confirmString];
    }
}

@end
