//
//  YXPersonalInformationVC.m
//  YXEDU
//
//  Created by Jake To on 10/12/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXPersonalInformationVC.h"
#import "YXPersonalInformationCell.h"
#import "YXPersonalInformationModel.h"
#import "YXBasePickverView.h"
#import "YXPersonChangeNameVC.h"
#import "BSCommon.h"
#import "YXUtils.h"
#import "LEEAlert.h"
#import "YRNetworkManager.h"

@interface YXPersonalInformationVC () <UITableViewDelegate, UITableViewDataSource, YXBasePickverViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *pickerBackgroundView;
@property (nonatomic, strong) NSMutableArray *tableDataSource;

@property (nonatomic, strong) YXPersonalInformationModel *currentSelectedMode;
@property (nonatomic, strong) YXBasePickverView *pickerView;
@property (nonatomic, strong) NSIndexPath *selectdIndexPath;

@property (nonatomic, strong) NSArray *allRightDetails;

@end

@implementation YXPersonalInformationVC
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.shouldRefreshInfoBlock) {
        self.shouldRefreshInfoBlock();
    }
}
- (void)setUpDataSource {
    NSMutableArray *dataSource = [NSMutableArray array];
        
    NSArray *allTitles = @[@[@"头像",@"昵称",@"性别"],@[@"生日",@"地区",@"年级"]];
    NSArray *isShowAccseeories = @[@[@"1",@"1",@"1"],@[@"1",@"1",@"1"]];
    NSArray *isShowBottomLines = @[@[@"1",@"1",@"0"],@[@"1",@"1",@"1"]];

    for (NSInteger i = 0; i < allTitles.count; i++) {
            
        NSArray *titlesOfOneSection = allTitles[i];
        NSArray *rightDetailsOfOneSection = self.allRightDetails[i];
        NSArray *isShowAccessoriesOfOneSection = isShowAccseeories[i];
        NSArray *isShowBottomLinesOfOneSection = isShowBottomLines[i];
        
        NSMutableArray *itemsOfOneSection = [NSMutableArray array];
            
        for ( NSInteger j = 0; j < titlesOfOneSection.count; j++ ) {
            YXPersonalInformationModel *model = [[YXPersonalInformationModel alloc] init];
                
            model.title = titlesOfOneSection[j];
            model.rightDetail = rightDetailsOfOneSection[j];
            model.isShowAccessory = [isShowAccessoriesOfOneSection[j] boolValue];
            model.isShowBottomLine = [isShowBottomLinesOfOneSection[j] boolValue];

            [itemsOfOneSection addObject:model];
        }
            
        [dataSource addObject:itemsOfOneSection];
    }
    self.tableDataSource = dataSource;
}

- (void)back {
    [self.navigationController popViewControllerAnimated: true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem.leftBarButtonItem setTarget: self];
    [self.navigationItem.leftBarButtonItem setAction: @selector(back)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removePickerView:) name:@"RemovePickerView" object:nil];

    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGRect tableViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YXPersonalInformationCell class] forCellReuseIdentifier:@"PersonalInformationCell"];
    [self.view addSubview:self.tableView];
    
    NSString *name = self.userModel.nick;
    
    NSString *sex = @"未设置";
    if ([self.userModel.sex isEqualToString:@"1"]) {
        sex = @"男";
    } else if ([self.userModel.sex isEqualToString:@"2"]) {
        sex = @"女";
    }
    
    NSString *birthday = @"未设置";
    if (![self.userModel.birthday isEqualToString:@""]) {
        birthday = self.userModel.birthday;
    }
    
    NSString *area = @"未设置";
    if (![self.userModel.area isEqualToString:@""] && self.userModel.area.length) {
        area = self.userModel.area;
    }
    
    NSString *grade = @"未设置";
    if ([self.userModel.grade isEqualToString:@"1"]) {
        grade = @"一年级";
    } else if ([self.userModel.grade isEqualToString:@"2"]) {
        grade = @"二年级";
    } else if ([self.userModel.grade isEqualToString:@"3"]) {
        grade = @"三年级";
    } else if ([self.userModel.grade isEqualToString:@"4"]) {
        grade = @"四年级";
    } else if ([self.userModel.grade isEqualToString:@"5"]) {
        grade = @"五年级";
    } else if ([self.userModel.grade isEqualToString:@"6"]) {
        grade = @"六年级";
    } else if ([self.userModel.grade isEqualToString:@"7"]) {
        grade = @"七年级";
    } else if ([self.userModel.grade isEqualToString:@"8"]) {
        grade = @"八年级";
    } else if ([self.userModel.grade isEqualToString:@"9"]) {
        grade = @"九年级";
    } else if ([self.userModel.grade isEqualToString:@"10"]) {
        grade = @"其他";
    }
    
    self.allRightDetails = @[@[@"", name, sex],@[birthday, area, grade]];

    [self setUpDataSource];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

// MARK: - TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = self.tableDataSource[section];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YXPersonalInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInformationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *itemsOfOneSection = self.tableDataSource[indexPath.section];
    YXPersonalInformationModel *model = itemsOfOneSection[indexPath.row];
    cell.model = model;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self addAvatarImage:cell];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
        
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *itemsOfOneSection = self.tableDataSource[indexPath.section];
    YXPersonalInformationModel *model = itemsOfOneSection[indexPath.row];
    
    self.selectdIndexPath = indexPath;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    [LEEAlert actionsheet].config
                    
                    .LeeAddAction(^(LEEAction *action) {
                        action.type = LEEActionTypeDefault;
                        action.title = @"拍照";
                        action.titleColor = UIColor.blackColor;
                        action.font = [UIFont systemFontOfSize:18.0f];
                        
                        action.clickBlock = ^{
                            [self takePhoto];
                        };
                    })
                    
                    .LeeAddAction(^(LEEAction *action) {
                        action.type = LEEActionTypeDefault;
                        action.title = @"从相册中选择";
                        action.titleColor = UIColor.blackColor;
                        action.font = [UIFont systemFontOfSize:18.0f];
                        
                        action.clickBlock = ^{
                            [self pickImage];
                        };
                    })
                    
                    .LeeAddAction(^(LEEAction *action) {
                        action.type = LEEActionTypeCancel;
                        action.title = @"取消";
                        action.titleColor = UIColorOfHex(0x8095AB);
                        action.font = [UIFont systemFontOfSize:18.0f];
                    })
                    
                    .LeeActionSheetCancelActionSpaceColor(UIColorOfHex(0xF6F8FA))
                    .LeeActionSheetBottomMargin(0.0f)
                    .LeeCornerRadius(0.0f)
                    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
                        
                        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
                    })
                    
                    .LeeActionSheetBackgroundColor([UIColor whiteColor])
                    .LeeShow();
                }
                    break;
                case 1:
                    
                {
                    YXPersonChangeNameVC *changeNameViewController = [[YXPersonChangeNameVC alloc] init];
                    
                    changeNameViewController.returnNameStringBlock = ^(NSString *nameString) {
                        self.userModel.nick = nameString;
                        
                        YXPersonalInformationModel *model = [[YXPersonalInformationModel alloc] init];
                        model.title = @"昵称";
                        model.rightDetail = nameString;
                        model.isShowAccessory = YES;
                        model.isShowBottomLine = YES;
                        
                        self.tableDataSource[indexPath.section][indexPath.row] = model;
                      
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    
                    NSString *userName = model.rightDetail;
                    if (userName.length > 10) {
                        userName = [userName substringToIndex:10];
                    }
                    
                    changeNameViewController.userName = userName;
                    changeNameViewController.userNameLength = [NSString stringWithFormat:@"%lu/10", (unsigned long)userName.length ];
                    
                    [self.navigationController pushViewController:changeNameViewController animated:true];
                }
                    
                    break;
                case 2:
                    self.pickerView = [YXBasePickverView showSexPickerViewOn:model.rightDetail withDelegate:self];
                    break;
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    self.pickerView = [YXBasePickverView showBirthdayPickerViewOn:model.rightDetail withDelegate:self];
                    break;
                case 1:
                    self.pickerView = [YXBasePickverView showLocationPickerViewOn:model.rightDetail withDelegate:self];
                    break;
                case 2:
                    self.pickerView = [YXBasePickverView showGradePickerViewOn:model.rightDetail withDelegate:self];
                    break;
                default:
                    break;
            }
            break;

        case 2:
            break;
    }
    
    if (self.pickerView) {
        self.pickerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.pickerBackgroundView.backgroundColor = UIColor.blackColor;
//        [self.pickerBackgroundView setUserInteractionEnabled:YES];
        self.view.userInteractionEnabled = NO;
        self.pickerBackgroundView.userInteractionEnabled = NO;
        [self.pickerBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePickerView:)]];
        self.pickerBackgroundView.alpha = 0.5;
        
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 272);
        self.pickerView.backgroundColor = UIColor.clearColor;
        
        UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
        [currentWindow addSubview:self.pickerBackgroundView];
        [currentWindow addSubview:self.pickerView];

        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT - 272, SCREEN_WIDTH, 272);
            self.pickerBackgroundView.alpha = 0.5;
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            self.pickerBackgroundView.userInteractionEnabled = YES;
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        intervalView.backgroundColor = UIColorOfHex(0xF6F8FA);

        return intervalView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

// MARK: - Avatar Functions

- (void) addAvatarImage:(YXPersonalInformationCell *)cell {
    
    [self.avatarImageView removeFromSuperview];
    
    CGRect frame = CGRectMake(SCREEN_WIDTH - 100, 15, 70, 70);
    self.avatarImageView = [[UIImageView alloc] initWithFrame:frame];
    self.avatarImageView.layer.cornerRadius = 8;//self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:self.avatarImageView];
    
    if (self.avatarImage) {
        self.avatarImageView.image = self.avatarImage;
        return;
    }
    
    NSString *imageURLString = self.userModel.avatar;
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [self.avatarImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"challengeAvatar"]];
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) pickImage {
    [[UINavigationBar appearance]setTranslucent:NO];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.navigationBar.translucent = NO;
    picker.allowsEditing = YES;
    picker.navigationBar.tintColor = [UIColor blackColor];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self postAvatar:info[UIImagePickerControllerEditedImage]];
    }];
}



// MARK: - PickerView Delegate
- (void)basePickverView:(YXBasePickverView *)pickverView withSelectedTitle:(NSString *)title {

    NSArray *itemsOfOneSection = self.tableDataSource[self.selectdIndexPath.section];
    YXPersonalInformationModel *model = itemsOfOneSection[self.selectdIndexPath.row];
    model.rightDetail = title;
    
    [self.tableView reloadRowsAtIndexPaths:@[self.selectdIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// MARK: - Set Up Avatar
- (void)postAvatar:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image,0.2);
    
    YRFormFile *formFile = [[YRFormFile alloc] init];
    formFile.mineType = @"image/jpeg";
    formFile.data = imageData;
    formFile.name = @"file";
    formFile.filename = @"avatar.png";
    
    __weak typeof(self)weakSelf = self;
//    [YXUtils showHUD:self.view];
    
    [[YYNetworkService default] ocRequestWithType:YXOCRequestTypeChangeAvatar params:@{@"file": imageData} isUpload:YES  success:^(YXOCModel* model) {
        if (model != nil) {
            weakSelf.avatarImage = image;
            [weakSelf.tableView reloadData];
        }
        
    } fail:^(NSError* error) {
        
    }];
}

// MARK: Tap Gesture
- (void)removePickerView:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerBackgroundView.alpha = 0;
        self.pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 272);
    } completion:^(BOOL finished) {
        [self.pickerBackgroundView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        
        self.pickerBackgroundView = nil;
        self.pickerView = nil;
    }];
}

@end
