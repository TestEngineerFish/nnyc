//
//  FBYLineGraphView.m
//  FBYDataDisplay-iOS
//
//  Created by fby on 2018/1/18.
//  Copyright © 2018年 FBYDataDisplay-iOS. All rights reserved.
//

#import "FBYLineGraphView.h"
#import "FBYLineGraphContentView.h"

@interface FBYLineGraphView() {
    
    NSMutableArray *xMarkTitles;
    NSMutableArray *valueArray;
    
}

/**
 *  表名标签
 */
@property (nonatomic, strong) UILabel *titleLab;

/**
 *  显示折线图的可滑动视图
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  折线图
 */
@property (nonatomic, strong) FBYLineGraphContentView *lineGraphContentView;

/**
 *  X轴刻度标签 和 对应的折线图点的值
 */
@property (nonatomic, strong) NSArray *xMarkTitlesAndValues;

@property (nonatomic, strong)UILabel *noDataLabel;

@end

@implementation FBYLineGraphView

- (void)setXScaleMarkLEN:(CGFloat)xScaleMarkLEN {
    _xScaleMarkLEN = xScaleMarkLEN;
}

- (void)setYMarkTitles:(NSArray *)yMarkTitles {
    _yMarkTitles = yMarkTitles;
}

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
}

- (void)setXMarkTitlesAndValues:(NSArray *)xMarkTitlesAndValues titleKey:(NSString *)titleKey valueKey:(NSString *)valueKey {
    
    _xMarkTitlesAndValues = xMarkTitlesAndValues;
    
    xMarkTitles = [NSMutableArray array];
    valueArray = [NSMutableArray array];
    
    for (NSDictionary *dic in xMarkTitlesAndValues) {
        
        [xMarkTitles addObject:[dic objectForKey:titleKey]];
        [valueArray addObject:[dic objectForKey:valueKey]];
    }
}

- (void)setXMarkTitlesAndValues:(NSArray<YXNoteCharts *> *)xMarkTitlesAndValues {
    _xMarkTitlesAndValues = xMarkTitlesAndValues;
    
    xMarkTitles = [NSMutableArray array];
    valueArray = [NSMutableArray array];
    
    CGFloat maxValue = 0;
    int i = 0;
    for (YXNoteCharts *model in xMarkTitlesAndValues) {
//        model.num += i*(i%2 ? 2 : 5);
//        if (i == 0) {
//            model.num = 20;
//        }
        if (maxValue < model.num) {
            maxValue = model.num;
        }
        [xMarkTitles addObject:model.dateStr];
        [valueArray addObject:@(model.num)];
        i ++;
    }
    
    self.maxValue = maxValue + 1; // 防止最大值为0
}
#pragma mark 绘图
- (void)mapping {
    
    static CGFloat topToContainView = 0.f;
    
    if (self.title) {
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.frame), 20)];
        self.titleLab.text = self.title;
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
        topToContainView = 25;
    }
    
    if (!self.xMarkTitlesAndValues) {
        
        xMarkTitles = @[@1,@2,@3,@4,@5].mutableCopy;
        valueArray = @[@2,@2,@2,@2,@2].mutableCopy;
        
    }
    
    
    if (!self.yMarkTitles) {
        self.yMarkTitles = @[@0,@1,@2,@3,@4,@5];
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topToContainView, self.frame.size.width,self.frame.size.height - topToContainView)];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:self.scrollView];
    
    self.lineGraphContentView = [[FBYLineGraphContentView alloc] initWithFrame:self.scrollView.bounds];
    
    self.lineGraphContentView.yMarkTitles = self.yMarkTitles;
    self.lineGraphContentView.xMarkTitles = xMarkTitles;
    self.lineGraphContentView.xScaleMarkLEN = self.xScaleMarkLEN;
    self.lineGraphContentView.valueArray = valueArray;
    self.lineGraphContentView.maxValue = self.maxValue;
    
    [self.scrollView addSubview:self.lineGraphContentView];
    
    [self.lineGraphContentView mapping];
    
    self.scrollView.contentSize = self.lineGraphContentView.bounds.size;
    
    if (self.maxValue <= 1) {
        CGSize size = self.frame.size;
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, size.width, 16)];
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.noDataLabel.font = [UIFont systemFontOfSize:14];
        self.noDataLabel.textColor = UIColorOfHex(0x8095ab);
        self.noDataLabel.text = @"已经7天没有学习啦 (*>﹏<*)";
        [self addSubview:self.noDataLabel];
    }
}

#pragma mark 更新数据
- (void)reloadDatas {
    [self.lineGraphContentView reloadDatas];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
