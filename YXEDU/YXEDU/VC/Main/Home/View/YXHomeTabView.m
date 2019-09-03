//
//  YXHomeTabView.m
//  YXEDU
//
//  Created by shiji on 2018/6/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHomeTabView.h"
#import "BSCommon.h"
#import "YXHomeUnitView.h"
#import "YXHomeTabTitleView.h"

@interface YXHomeTabView () <UIScrollViewDelegate, YXHomeTabTitleViewDelegate>
@property (nonatomic, strong) UIScrollView *tabContentScroll;
@property (nonatomic, strong) YXHomeTabTitleView *tabTitleView;
@property (nonatomic, strong) NSMutableArray <YXHomeUnitView *>*dataArr;
@end

@implementation YXHomeTabView

- (instancetype)initWithFrame:(CGRect)frame
                       rootVC:(id<YXHomeUnitViewDelegate>)root
                rootViewModel:(id)viewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArr = [NSMutableArray array];
        self.backgroundColor = UIColorOfHex(0x4DB3FE);
        self.tabTitleView = [[YXHomeTabTitleView alloc]init];
        [self.tabTitleView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        self.tabTitleView.delegate = self;
        [self addSubview:self.tabTitleView];
        
        self.tabContentScroll = [[UIScrollView alloc]init];
        self.tabContentScroll.delegate = self;
        self.tabContentScroll.pagingEnabled = YES;
        self.tabContentScroll.bounces = NO;
        self.tabContentScroll.showsHorizontalScrollIndicator = NO;
        self.tabContentScroll.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-48-NavHeight);
        self.tabContentScroll.frame = CGRectMake(0, 48, SCREEN_WIDTH, SCREEN_HEIGHT-48-NavHeight);
        [self addSubview:self.tabContentScroll];
        
        for (int i = 0; i < 3; i ++) {
            YXHomeUnitView *unitView = [[YXHomeUnitView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48-NavHeight) rootViewModel:viewModel];
            unitView.delegate = root;
            unitView.tabType = i;
            [self.tabContentScroll addSubview:unitView];
            [self.dataArr addObject:unitView];
        }
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/SCREEN_WIDTH;
    [_tabTitleView setAllBtnIdx:pageNum];
}

- (void)reloadSubViews {
    for (YXHomeUnitView *unitView in self.dataArr) {
        [unitView reloadSubViews];
    }
}

- (void)titleBtnDidClicked:(id)sender {
    UIButton *btn = sender;
    [self.tabContentScroll setContentOffset:CGPointMake(btn.tag * SCREEN_WIDTH, 0) animated:YES];
}

@end
