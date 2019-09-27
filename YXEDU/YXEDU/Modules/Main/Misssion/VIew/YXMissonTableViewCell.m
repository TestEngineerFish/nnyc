//
//  YXMissonTableViewCell.m
//  YXEDU
//
//  Created by yixue on 2018/12/26.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXMissonTableViewCell.h"
#import "YXDescoverTitleView.h"
#import "YXMissionCollectionViewCell.h"

@interface YXMissonTableViewCell () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, YXMissionCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *missionCollectionView;

@property (nonatomic, strong)  YXDescoverTitleView *titleView;

@end

@implementation YXMissonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupModel];
        [self setupUI];
    }
    return self;
}

- (void)setupModel {
    
}

- (void)setTaskListAfterSelected:(NSMutableArray *)taskListAfterSelected {
    _taskListAfterSelected = taskListAfterSelected;
    [self.missionCollectionView reloadData];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleView.titleLabel.text = _title;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
    line.backgroundColor = [UIColor colorWithRed:233/255.0 green:239/255.0 blue:244/255.0 alpha:1.0].CGColor;
    [self.layer addSublayer:line];
    
    _titleView = [[YXDescoverTitleView alloc] init];
    _titleView.frame = CGRectMake(AdaptSize(15), AdaptSize(30), AdaptSize(150), AdaptSize(15));
    //_titleView.titleLabel.text = _title;
    [self addSubview:_titleView];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = MakeAdaptCGSize(135, 180);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(0, AdaptSize(15), 0, AdaptSize(15));
    
    _missionCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(AdaptSize(0), AdaptSize(64), SCREEN_WIDTH, AdaptSize(180))
                                               collectionViewLayout:layout];
    _missionCollectionView.backgroundColor = [UIColor whiteColor];
    _missionCollectionView.delegate = self;
    _missionCollectionView.dataSource = self;
    //_missionCollectionView.scrollsToTop = NO;
    _missionCollectionView.showsVerticalScrollIndicator = NO;
    _missionCollectionView.showsHorizontalScrollIndicator = NO;
    [_missionCollectionView registerClass:[YXMissionCollectionViewCell class] forCellWithReuseIdentifier:@"YXMissionCollectionViewCellID"];
    [self addSubview:_missionCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _taskListAfterSelected.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXMissionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXMissionCollectionViewCellID"
                                                                                  forIndexPath:indexPath];
    cell.delegate = self;
    for (YXTaskModel *model in _taskListAfterSelected) {
        if (model.state == 1){
            cell.model = model;
            [_taskListAfterSelected removeObject:model];
            return cell;
        } else if (model.state == 0) {
            cell.model = model;
            [_taskListAfterSelected removeObject:model];
            return cell;
        } else {
            cell.model = model;
            [_taskListAfterSelected removeObject:model];
            return cell;
        }
    }
    return cell;
}

- (void)missionCollectionViewCellTransferTo:(YXMissionCollectionViewCell *)missionCollectionCell {
    if ([self.delegate respondsToSelector:@selector(missonTableViewCellTransferTo:)]) {
        [self.delegate missonTableViewCellTransferTo:missionCollectionCell];
    }
}

- (void)missionCollectionViewCellGetNextTask:(YXMissionCollectionViewCell *)missionCollectionCell {
    if ([self.delegate respondsToSelector:@selector(missonTableViewCellGetNewTask:taskModel:)]) {
        [self.delegate missonTableViewCellGetNewTask:missionCollectionCell taskModel:missionCollectionCell.model];
    }
}

@end
