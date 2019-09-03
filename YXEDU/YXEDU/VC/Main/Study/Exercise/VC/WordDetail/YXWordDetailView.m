//
//  YXGraphSelectTipThreeView.m
//  YXEDU
//
//  Created by shiji on 2018/4/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordDetailView.h"
#import "YXGraphConfuseWordCell.h"
#import "YXGraphExampleSentenceCell.h"
#import "YXGraphIllustationCell.h"
#import "YXGraphTranslateCell.h"
#import "YXGraphWordCell.h"
#import "BSCommon.h"
#import "YXGraphTipThreeViewModel.h"
#import "YXStudyCmdCenter.h"
#import "UIImageView+WebCache.h"
#import "YXConfigure.h"
#import "YXUtils.h"
#import "NSString+YX.h"
#import "YXCommHeader.h"

@interface YXWordDetailView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *accountTalbe;
@property (nonatomic, strong) UIView *bottomHeadView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *affirmBtn;
@property (nonatomic, strong) YXGraphTipThreeViewModel *viewModel;
@end

@implementation YXWordDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorOfHex(0xf0f0f0);
    }
    return self;
}


- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        [self recreateSubViews];
    } else {
        [self removeAllSubViews];
    }
}

- (void)recreateSubViews {
    [self containerView];
    [self.accountTalbe registerClass:[YXGraphWordCell class]
              forCellReuseIdentifier:@"YXGraphWordCell"];
    [self.accountTalbe registerClass:[YXGraphConfuseWordCell class]
              forCellReuseIdentifier:@"YXGraphConfuseWordCell"];
    [self.accountTalbe registerClass:[YXGraphExampleSentenceCell class]
              forCellReuseIdentifier:@"YXGraphExampleSentenceCell"];
    [self.accountTalbe registerClass:[YXGraphIllustationCell class]
              forCellReuseIdentifier:@"YXGraphIllustationCell"];
    [self.accountTalbe registerClass:[YXGraphTranslateCell class]
              forCellReuseIdentifier:@"YXGraphTranslateCell"];
    _accountTalbe.delegate = self;
    _accountTalbe.dataSource = self;
    
    [self bottomHeadView];
    [self bottomView];
    [self lineView];
    [self affirmBtn];
    [self viewModel];
    [self.accountTalbe layoutIfNeeded];
}

- (void)removeAllSubViews {
    RELEASE(_bottomHeadView);
    RELEASE(_lineView);
    RELEASE(_bottomView);
    RELEASE(_affirmBtn);
    RELEASE(_containerView);
    RELEASE(_accountTalbe);
    if (_viewModel) {
        _viewModel = nil;
    }
}


- (void)affirmBtnClicked:(id)sender {
    [[YXStudyCmdCenter shared]studyAction:YXActionSelectImageContinue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel rowCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel rowHeight:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GraphTipThreeCellType cellType = [self.viewModel rowIdx:indexPath.row];
    switch (cellType) {
        case GraphTipThreeWord: {
            YXGraphWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXGraphWordCell" forIndexPath:indexPath];
            cell.wordLab.text = [YXStudyCmdCenter shared].curUnitInfo.word;
            if ([YXConfigure shared].isUSVoice) {
                cell.phoneticLab.text = [YXStudyCmdCenter shared].curUnitInfo.usphone;
            } else {
                cell.phoneticLab.text = [YXStudyCmdCenter shared].curUnitInfo.ukphone;
            }
            [cell reloadData];
            return cell;
        }
        case GraphTipThreeTranslate: {
            YXGraphTranslateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXGraphTranslateCell" forIndexPath:indexPath];
            cell.translateLab.text = [NSString stringWithFormat:@"%@ %@", [YXStudyCmdCenter shared].curUnitInfo.property, [YXStudyCmdCenter shared].curUnitInfo.paraphrase];
            return cell;
        }
        case GraphTipThreeSentence: {
            YXGraphExampleSentenceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXGraphExampleSentenceCell" forIndexPath:indexPath];
            [cell refreshModelInfo];
            return cell;
        }
            
        case GraphTipThreeIllustration: {
            YXGraphIllustationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXGraphIllustationCell" forIndexPath:indexPath];
            YXStudyBookUnitModel *unitModel = [YXConfigure shared].bookUnitModel;
            NSString *name = [[unitModel.bookid DIR:unitModel.unitid]DIR:unitModel.filename];
            NSString *resourcePath = [[YXUtils resourcePath]DIR:name];
            NSURL *imagePath = [NSURL fileURLWithPath:[resourcePath DIR:[YXStudyCmdCenter shared].curUnitInfo.image]];
            [cell.exampleImageView sd_setImageWithURL:imagePath];
            return cell;
        }
        case GraphTipThreeConfusionWord: {
            YXGraphConfuseWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXGraphConfuseWordCell" forIndexPath:indexPath];
            cell.sentenceLab.text = [YXStudyCmdCenter shared].curUnitInfo.confusion;
            return cell;
        }
        default:
            break;
    }
    YXGraphConfuseWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXGraphConfuseWordCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark -lazy load view-
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(16, 2, SCREEN_WIDTH-32, SCREEN_HEIGHT-NavHeight-18-SafeBottomMargin)];
        _containerView.backgroundColor = UIColorOfHex(0xF7F6F2);
        _containerView.layer.cornerRadius = 8.0;
        _containerView.layer.shadowOpacity = 0.5f;
        _containerView.layer.shadowRadius = 2.f;
        _containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _containerView.layer.shadowOffset = CGSizeMake(2,2);
        [self addSubview:_containerView];
    }
    return _containerView;
}

- (UITableView *)accountTalbe {
    if (!_accountTalbe) {
        CGFloat containWidth = CGRectGetWidth(self.containerView.frame);
        CGFloat containHeight = CGRectGetHeight(self.containerView.frame);
        _accountTalbe = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, containWidth, containHeight-86) style:UITableViewStylePlain];
//        _accountTalbe.delegate = self;
//        _accountTalbe.dataSource = self;
        _accountTalbe.backgroundColor = [UIColor clearColor];
        _accountTalbe.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.containerView addSubview:_accountTalbe];
    }
    return _accountTalbe;
}

- (UIView *)bottomHeadView {
    if (!_bottomHeadView) {
        CGFloat containWidth = CGRectGetWidth(self.containerView.frame);
        CGFloat containHeight = CGRectGetHeight(self.containerView.frame);
        _bottomHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, containHeight-86, containWidth, 16)];
        _bottomHeadView.backgroundColor = UIColorOfHex(0xffffff);
        [self.containerView addSubview:_bottomHeadView];
    }
    return _bottomHeadView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        CGFloat containWidth = CGRectGetWidth(self.containerView.frame);
        CGFloat containHeight = CGRectGetHeight(self.containerView.frame);
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, containHeight-86, containWidth, 86)];
        _bottomView.backgroundColor = UIColorOfHex(0xffffff);
        _bottomView.layer.cornerRadius = 8.0;
        [self.containerView addSubview:_bottomView];
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bottomView.frame), 0.5)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.3;
        [self.bottomView addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)affirmBtn {
    if (!_affirmBtn) {
        CGFloat containWidth = CGRectGetWidth(self.containerView.frame);
        _affirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_affirmBtn setTitle:@"继续" forState:UIControlStateNormal];
        [_affirmBtn setBackgroundImage:[UIImage imageNamed:@"study_continue_btn"] forState:UIControlStateNormal];
        [_affirmBtn setTitleColor:UIColorOfHex(0xffffff) forState:UIControlStateNormal];
        _affirmBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _affirmBtn.frame = CGRectMake((containWidth-200)/2.0, 16, 200, 54);
        _affirmBtn.layer.cornerRadius = 27.0f;
        _affirmBtn.backgroundColor = [UIColor clearColor];
        [_affirmBtn addTarget:self action:@selector(affirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_affirmBtn];
    }
    return _affirmBtn;
}

- (YXGraphTipThreeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YXGraphTipThreeViewModel alloc]init];
    }
    return _viewModel;
}

@end
