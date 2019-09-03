//
//  YXUnitVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHomeUnitView.h"
#import "BSCommon.h"
#import "YXHomeUnitCell.h"
#import "NSString+YR.h"

#define kHeaderMargin 15

@interface YXHomeUnitView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *unitTable;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) YXHomeViewModel *mainViewModel;
@property (nonatomic, strong) UIView *noResView;
@property (nonatomic, strong) UIImageView *noResImageIcon;
@property (nonatomic, strong) UIView *labView;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *endLab;

@end

@implementation YXHomeUnitView

- (instancetype)initWithFrame:(CGRect)frame rootViewModel:(YXHomeViewModel *)viewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainViewModel = viewModel;
        self.unitTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight-44) style:UITableViewStylePlain];
        self.unitTable.delegate = self;
        self.unitTable.dataSource = self;
        self.unitTable.bounces = YES;
        self.unitTable.scrollEnabled = YES;
        self.unitTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.unitTable];
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderMargin)];
        [self.unitTable insertSubview:headerView atIndex:0];
        self.unitTable.contentInset = UIEdgeInsetsMake(kHeaderMargin, 0, 0, 0);
        [self.unitTable registerClass:[YXHomeUnitCell class] forCellReuseIdentifier:@"YXHomeUnitCell"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"kGoTopNotificationName" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"kLeaveTopNotificationName" object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
        
        self.noResView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight-44)];
        self.noResView.backgroundColor = [UIColor whiteColor];
        [self.unitTable addSubview:self.noResView];
        
        self.noResImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-115)/2.0, 85, 115, 109)];
        [self.noResView addSubview:self.noResImageIcon];
        
        self.labView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noResImageIcon.frame) + 16, SCREEN_WIDTH, 17)];
        [self.noResView addSubview:self.labView];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 17)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.textColor = UIColorOfHex(0x535353);
        self.titleLab.font = [UIFont systemFontOfSize:12];
        [self.labView addSubview:self.titleLab];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"换本词书"];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attrStr.string.length)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attrStr.string.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x210000) range:NSMakeRange(0, attrStr.string.length)];
        self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.changeBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
        [self.labView addSubview:self.changeBtn];
        [self.changeBtn setFrame:CGRectMake(0, 0, 90, 17)];
        
        self.endLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 17)];
        self.endLab.textAlignment = NSTextAlignmentCenter;
        self.endLab.textColor = UIColorOfHex(0x535353);
        self.endLab.font = [UIFont systemFontOfSize:12];
        self.endLab.text = @"试试？";
        [self.labView addSubview:self.endLab];
        self.noResView.hidden = YES;
    }
    return self;
}

- (void)setTabType:(YXHomeTabType)tabType {
    _tabType = tabType;
    switch (tabType) {
        case YXHomeTabTypeReadyLearn: {
            self.noResImageIcon.image = [UIImage imageNamed:@"home_willlearned_unit"];
            self.endLab.hidden = NO;
            self.changeBtn.hidden = NO;
            self.titleLab.text = @"这本书已经学完啦~";
            CGSize titleLabSize = [self.titleLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH, 17) font:self.titleLab.font];
            CGSize changeBtnSize = [self.changeBtn.titleLabel.attributedText.string sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH, 17) font:[UIFont systemFontOfSize:12]];
            CGSize endLabSize = [self.endLab.text sizeWithConstrainedSize:CGSizeMake(SCREEN_WIDTH, 17) font:self.endLab.font];
            CGFloat labWidth = titleLabSize.width + changeBtnSize.width + endLabSize.width;
            self.labView.frame = CGRectMake((SCREEN_WIDTH-labWidth)/2.0, CGRectGetMaxY(self.noResImageIcon.frame) + 16, labWidth, 17);
            self.titleLab.frame = CGRectMake(0, 0, titleLabSize.width, 17);
            self.changeBtn.frame = CGRectMake(titleLabSize.width, 0, changeBtnSize.width, 17);
            self.endLab.frame = CGRectMake(titleLabSize.width+changeBtnSize.width, 0, endLabSize.width, 17);
        }
            break;
        case YXHomeTabTypeAlreadyLearn: {
            self.noResImageIcon.image = [UIImage imageNamed:@"home_completelearned_unit"];
            self.endLab.hidden = YES;
            self.changeBtn.hidden = YES;
            self.titleLab.text = @"还没有已学完的单元，再努把力吧~";
            self.labView.frame = CGRectMake(0, CGRectGetMaxY(self.noResImageIcon.frame) + 16, SCREEN_WIDTH, 17);
            self.titleLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 17);
        }
            break;
            
        default:
            break;
    }
}

- (void)changeBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeBookBtnClicked:)]) {
        [self.delegate changeBookBtnClicked:sender];
    }
}

- (void)reloadSubViews {
    [self.unitTable reloadData];
}

-(void)acceptMsg : (NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:@"kGoTopNotificationName"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.unitTable.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:@"kLeaveTopNotificationName"]){
        self.unitTable.contentOffset = CGPointMake(0, -kHeaderMargin);
        self.canScroll = NO;
        self.unitTable.showsVerticalScrollIndicator = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointMake(0, -kHeaderMargin)];
    }
    CGFloat offsetY = scrollView.contentOffset.y+kHeaderMargin;
    if (offsetY<0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNotificationName" object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.tabType) {
        case YXHomeTabTypeAll: {
            return [self.mainViewModel itemCount];
        }
        case YXHomeTabTypeReadyLearn: {
            if ([self.mainViewModel readyLearnedUnitCount] == 0) {
                self.noResView.hidden = NO;
            } else {
                self.noResView.hidden = YES;
            }
            return [self.mainViewModel readyLearnedUnitCount];
        }
        case YXHomeTabTypeAlreadyLearn: {
            if ([self.mainViewModel learnedUnitCount] == 0) {
                self.noResView.hidden = NO;
            } else {
                self.noResView.hidden = YES;
            }
            return [self.mainViewModel learnedUnitCount];
        }
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXHomeUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXHomeUnitCell" forIndexPath:indexPath];
    id model;
    if (self.tabType == YXHomeTabTypeAll) {
        model = [self.mainViewModel itemModel:indexPath.row];
    } else if (self.tabType == YXHomeTabTypeReadyLearn) {
        model = [self.mainViewModel readyLearnedUnitModel:indexPath.row];
    } else if (self.tabType == YXHomeTabTypeAlreadyLearn) {
        model = [self.mainViewModel learnedUnitModel:indexPath.row];
    }
    [cell insertModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id model;
    if (self.tabType == YXHomeTabTypeAll) {
        model = [self.mainViewModel itemModel:indexPath.row];
    } else if (self.tabType == YXHomeTabTypeReadyLearn) {
        model = [self.mainViewModel readyLearnedUnitModel:indexPath.row];
    } else if (self.tabType == YXHomeTabTypeAlreadyLearn) {
        model = [self.mainViewModel learnedUnitModel:indexPath.row];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedRow:)]) {
        [self.delegate didSelectedRow:model];
    }
}


@end
