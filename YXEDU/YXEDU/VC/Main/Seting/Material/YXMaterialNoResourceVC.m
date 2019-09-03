//
//  YXMaterialNoResourceVC.m
//  YXEDU
//
//  Created by shiji on 2018/6/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMaterialNoResourceVC.h"
#import "BSCommon.h"

@interface YXMaterialNoResourceVC ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLab;
@end

@implementation YXMaterialNoResourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noResourceView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    self.noResourceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.noResourceView];
    
    self.iconImageView = [[UIImageView alloc]init];
    [self.iconImageView setFrame:CGRectMake((SCREEN_WIDTH-60)/2.0, 100, 60, 86)];
    [self.iconImageView setImage:[UIImage imageNamed:@"personal_material_book"]];
    [self.noResourceView addSubview:self.iconImageView];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame)+29, SCREEN_WIDTH, 17)];
    self.titleLab.font = [UIFont systemFontOfSize:12];
    self.titleLab.text = @"暂未下载离线包";
    self.titleLab.textColor = UIColorOfHex(0x535353);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.noResourceView addSubview:self.titleLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
