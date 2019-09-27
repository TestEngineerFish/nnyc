//
//  YXCareerGuideMaskView.m
//  YXEDU
//
//  Created by yixue on 2019/3/4.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerGuideMaskView.h"
#import "YXCareerNoteWordListCell.h"
#import "YXCareerNoteWordInfoModel.h"
#import "YXCareerCommentButton.h"
#import "YXCareerSortButton.h"

static NSString *const kYXCareerNoteWordFakeListCellID = @"kYXCareerNoteWordFakeListCellID";

@interface YXCareerGuideMaskView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView *fakeView;

@property (nonatomic, weak) UIButton *bgView;

@property (nonatomic, weak) UIImageView *arrow1;
@property (nonatomic, weak) UILabel *lbl1;

@property (nonatomic, weak) UIImageView *arrow2;
@property (nonatomic, weak) UILabel *lbl2;

@end

@implementation YXCareerGuideMaskView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        
        [self fakeView];
        
        [self bgView];
        
        [self arrow1];
        [self lbl1];
        [self arrow2];
        [self lbl2];
    }
    return self;
}

- (void)dismissdd {
    [self removeFromSuperview];
}

- (UIView *)fakeView {
    if (!_fakeView) {
        UIView *fakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 + kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        fakeView.backgroundColor = [UIColor whiteColor];

        CGRect rect = CGRectMake(15, 50, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 30 - kNavHeight - 65 - kSafeBottomMargin);
        UITableView *wordTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        [wordTableView registerClass:[YXCareerNoteWordListCell class] forCellReuseIdentifier:kYXCareerNoteWordFakeListCellID];
        wordTableView.backgroundColor = UIColorOfHex(0xEAF4FC);
        wordTableView.layer.cornerRadius = 5;
        wordTableView.delegate = self;
        wordTableView.dataSource = self;
        
        UIView *shadowBg = [[UIView alloc] initWithFrame:rect];
        shadowBg.backgroundColor = UIColorOfHex(0xAED7E3);
        shadowBg.layer.cornerRadius = 5;
        shadowBg.layer.shadowColor = UIColorOfHex(0xAED7E3).CGColor;
        shadowBg.layer.shadowOffset = CGSizeMake(0, 0);
        shadowBg.layer.shadowRadius = 3;
        shadowBg.layer.shadowOpacity = 1;
        
        YXCareerCommentButton *commentBtn = [[YXCareerCommentButton alloc] init];
        commentBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 12, 85, 25);
        commentBtn.isSelected = YES;
        [fakeView addSubview:commentBtn];
        
        YXCareerSortButton *sortBtn = [[YXCareerSortButton alloc] init];
        sortBtn.frame = CGRectMake(SCREEN_WIDTH - 200, 12, 85, 25);
        sortBtn.isSelected = NO;
        [fakeView addSubview:sortBtn];
        
        UILabel *numberOfWordsLbl = [[UILabel alloc] initWithFrame:CGRectMake(19, 19, 200, 15)];
        numberOfWordsLbl.textColor = UIColorOfHex(0x849EC5);
        numberOfWordsLbl.font = [UIFont pfSCRegularFontWithSize:14];
        numberOfWordsLbl.text = @"单词：6";
        [fakeView addSubview:numberOfWordsLbl];
        
        [fakeView addSubview:shadowBg];
        [fakeView addSubview:wordTableView];
        
        [self addSubview:fakeView];
        _fakeView = fakeView;
    }
    return _bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 50; }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 42; }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 5; }

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section { return [[UIView alloc] init];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXCareerNoteWordListCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXCareerNoteWordFakeListCellID];
    cell.isDetailHidden = YES;
    YXCareerNoteWordInfoModel *model = [[YXCareerNoteWordInfoModel alloc] init];
    model.word_id = @"5";
    cell.wordInfoModel = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 42)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 100, 14)];
    headerTitleLbl.textColor = UIColorOfHex(0x849EC5);
    headerTitleLbl.font = [UIFont pfSCRegularFontWithSize:13];
    [headerView addSubview:headerTitleLbl];
    headerTitleLbl.text = @"2019-12-12";
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UIButton *)bgView {
    if (!_bgView) {
        UIButton *bgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [bgView addTarget:self action:@selector(dismissdd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgView];
        bgView.layer.mask = [self roundRectMask];
        _bgView = bgView;
    }
    return _bgView;
}

- (UILabel *)lbl1 {
    if (!_lbl1) {
        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 250, kNavHeight + 130, 210, 17)];
        lbl1.font = [UIFont pfSCRegularFontWithSize:16];
        lbl1.text = @"点击隐藏注释，进入默背模式";
        lbl1.textColor  = [UIColor whiteColor];
        [_bgView addSubview:lbl1];
        _lbl1 = lbl1;
    }
    return _lbl1;
}

- (UIImageView *)arrow1 {
    if (!_arrow1) {
        UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 172, kNavHeight + 54, 68, 71)];
        arrow1.image = [UIImage imageNamed:@"arrow1"];
        [_bgView addSubview:arrow1];
        _arrow1 = arrow1;
    }
    return _arrow1;
}

- (UIImageView *)arrow2 {
    if (!_arrow2) {
        UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(160, kNavHeight + 218, 34, 50)];
        arrow2.image = [UIImage imageNamed:@"arrow2"];
        [_bgView addSubview:arrow2];
        _arrow2 = arrow2;
    }
    return _arrow2;
}

- (UILabel *)lbl2 {
    if (!_lbl2) {
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(140, kNavHeight + 272, 230, 17)];
        lbl2.font = [UIFont pfSCRegularFontWithSize:16];
        lbl2.text = @"默背模式下，点击查看单词词义";
        lbl2.textColor  = [UIColor whiteColor];
        [_bgView addSubview:lbl2];
        _lbl2 = lbl2;
    }
    return _lbl2;
}

- (CAShapeLayer *)roundRectMask {
    //
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    //
    UIBezierPath *roundRect1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(SCREEN_WIDTH - 104, kNavHeight + 38, 93, 33)
                                                          cornerRadius:15];
    UIBezierPath *roundRect2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, kNavHeight + 172, SCREEN_WIDTH - 30, 50)
                                                         cornerRadius:8];
    [path appendPath:roundRect1];
    [path appendPath:roundRect2];
    //
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    return maskLayer;
}

@end
