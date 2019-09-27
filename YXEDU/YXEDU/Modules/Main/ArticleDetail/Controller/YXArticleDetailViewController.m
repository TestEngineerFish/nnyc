//
//  YXArticleDetailViewController.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleDetailViewController.h"
#import "YXArticleModel.h"
#import "YXArticleContentView.h"
#import "YXArticleBottomView.h"
#import "AVAudioPlayerManger.h"
#import "YXWordDetailViewController.h"
#import "YXRemotePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "YXPlayAudioControllerView.h"
#import "YXKeyPointPhraseCell.h"
#import "YXKeyPointWordCell.h"
#import "YXKeyPointHeaderView.h"
#import "YXWordModelManager.h"
#import "YXArticleDetailFresherGuideView.h"

@interface YXArticleDetailViewController ()<TYAttributedLabelDelegate,UIScrollViewDelegate,ArticleDelegate, UITableViewDelegate, UITableViewDataSource, YXArticleDetailFresherGuideViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YXArticleContentView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YXArticleBottomView *bottomView;
@property (nonatomic, strong) YXPlayAudioControllerView *playControllerView;

@property (nonatomic, strong) YXArticleModel *articleModel;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, weak)   YXArticleDetailFresherGuideView *fresherGuideView;
@end

@implementation YXArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initUI];
    [kNotificationCenter addObserver:self selector:@selector(stopArticleAudio) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[AVAudioPlayerManger shared] stop];
}

- (void)initUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"课文详情";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 50.f + kSafeBottomMargin, 0));
        make.bottom.equalTo(self.tableView).with.offset(AdaptSize(125));
    }];

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.scrollView).with.offset(15.f);
        make.right.equalTo(self.scrollView).with.offset(-15.f);
        make.height.mas_equalTo(self.contentView.maxY);
        make.width.equalTo(self.view).with.offset(-30.f);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.scrollView);
        make.top.equalTo(self.contentView.mas_bottom).with.offset(20.f);
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).with.offset(-50 - kSafeBottomMargin);
        make.height.mas_equalTo(50.f + kSafeBottomMargin);
    }];

    [self.playControllerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30.f, 95));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).with.offset(kSafeBottomMargin);
    }];
    [self.view bringSubviewToFront:self.bottomView];

    [self.tableView registerClass:[YXKeyPointWordCell class] forCellReuseIdentifier:@"kYXKeyPointWordCell"];
    [self.tableView registerClass:[YXKeyPointPhraseCell class] forCellReuseIdentifier:@"kYXKeyPointPhraseCell"];

    if (![YXArticleDetailFresherGuideView isFresherGuideShowed]) {
        _fresherGuideView = [YXArticleDetailFresherGuideView showGuideViewToView:self.tabBarController.view delegate:self];
    }
}

- (void)loadData {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.jsonUrl]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"articleModel.json" ofType:nil];
//    data = [NSData dataWithContentsOfFile:path];
    self.articleModel = [YXArticleModel mj_objectWithKeyValues:data];
    self.contentView.articleModel = self.articleModel;
    CGFloat height = (self.articleModel.keyPoint.phrase.count + self.articleModel.keyPoint.word.count) * 45.f + 45.f;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self.tableView reloadData];
}

#pragma mark - Subview

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

- (YXArticleContentView *)contentView {
    if (!_contentView) {
        _contentView = [[YXArticleContentView alloc] init];
        _contentView.delegate = self;
        [_contentView setUserInteractionEnabled:YES];
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        [self.scrollView addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (YXArticleBottomView *)bottomView {
    if (!_bottomView) {
        YXArticleBottomView *bottomView = [[YXArticleBottomView alloc] init];
        bottomView.delegate = self;
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (YXPlayAudioControllerView *)playControllerView {
    if (!_playControllerView) {
        YXPlayAudioControllerView *playControllerView = [[YXPlayAudioControllerView alloc] init];
        playControllerView.layer.cornerRadius = 10.f;
        playControllerView.layer.borderColor = UIColorOfHex(0xA3BFD5).CGColor;
        playControllerView.layer.borderWidth = 1.f;
        playControllerView.playing = self.playing;
        playControllerView.delegate = self;
        [playControllerView setHidden:YES];
        playControllerView.totalUseTime = self.contentView.totalUseTime;
        [self.view addSubview:playControllerView];
        _playControllerView = playControllerView;
    }
    return _playControllerView;
}

#pragma mark - Event

- (void)showPlayControllerView {
    if (!self.playControllerView.isHidden) {
        return;
    }
    self.bottomView.isShow = YES;
    [self.view layoutIfNeeded];//别删
    CGRect frame = self.playControllerView.frame;
    [self.playControllerView setHidden:NO];
    [UIView animateWithDuration:0.5f animations:^{
        self.playControllerView.frame = CGRectMake(frame.origin.x, self.view.height - 160.f - kSafeBottomMargin, frame.size.width, frame.size.height);
    }];
}

- (void)hidePlayControllerView {
    if (self.playControllerView.isHidden) {
        return;
    }
    CGRect frame = self.playControllerView.frame;
    [UIView animateWithDuration:0.5f animations:^{
        self.playControllerView.frame = CGRectMake(frame.origin.x, CGRectGetMaxY(self.bottomView.frame) + kSafeBottomMargin, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        [self.playControllerView setHidden:YES];
    }];
}

- (void)adjustingContentView: (TYAttributedLabel *)label {
    CGRect rect = [label convertRect:label.bounds toView: self.contentView];
    CGPoint point = CGPointMake(0, rect.origin.y + rect.size.height/2);
    if (point.y > self.scrollView.contentSize.height/2.f && point.y < self.scrollView.contentSize.height - self.scrollView.bounds.size.height/2.f) {
        point.y = point.y - self.scrollView.bounds.size.height/2.f;
        [self.scrollView setContentOffset:point animated:YES];
    }

//    CGRect rectWithWindow = [label convertRect:label.frame toView:[UIApplication sharedApplication].keyWindow.maskView];
////    CGRect rectWithScrollView = [label convertRect:label.frame toView:self.scrollView];
//    CGPoint point = CGPointMake(0, rectWithWindow.origin.y + rectWithWindow.size.height/2);
//    if (point.y < SCREEN_HEIGHT*0.3) {
//        CGFloat gap = SCREEN_HEIGHT*0.3 - point.y;
//        point.y = point.y - gap;
//    }
//    if (point.y > SCREEN_HEIGHT * 0.7) {
//        CGFloat gap = point.y - SCREEN_HEIGHT * 0.7;
//        point.y = point.y - gap;
//    }
}

#pragma mark - tableView delegate && datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.articleModel.keyPoint.word.count;
    } else if (section == 1){
        return self.articleModel.keyPoint.phrase.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YXKeyPointWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kYXKeyPointWordCell" forIndexPath:indexPath];
        cell.delegate = self;
        YXKeyPointWordModel *model = self.articleModel.keyPoint.word[indexPath.row];
        [cell setCell:model];
        return cell;
    } else if (indexPath.section == 1) {
        YXKeyPointPhraseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kYXKeyPointPhraseCell" forIndexPath:indexPath];
        YXKeyPointPhraseModel *model = self.articleModel.keyPoint.phrase[indexPath.row];
        [cell setCell:model];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        YXKeyPointHeaderView *headerView = [[YXKeyPointHeaderView alloc] init];
        return headerView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YXKeyPointWordModel *wordModel = self.articleModel.keyPoint.word[indexPath.row];
        //查找本地单词详情
        [YXWordModelManager quardWithWordId:wordModel.wordId.stringValue completeBlock:^(id obj, BOOL result) {
            if (result) {
                [self stopArticleAudio];
                YXWordDetailModel *wordModel = obj;//词单列表
                YXWordDetailViewController *detailVC = [YXWordDetailViewController wordDetailWith:wordModel bookId:wordModel.bookId withBackBlock:^{
                    [self.navigationController setNavigationBarHidden:NO];
                }];
                [self.navigationController pushViewController:detailVC animated:YES];
            } else {
                NSLog(@"查询数据失败");
            }
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 50.f : 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - ArticleDelegate
- (void)playArticleAudioWithFrom:(NSInteger)index {
    if (!self.playing) {
        self.playing = YES;
        [self showPlayControllerView];
    }
    self.playControllerView.playing = self.playing;
    //超过最后一句,则不走播放逻辑
    if (index >= self.contentView.attriStrModelList.count) {
        [self.contentView resetAttributionString];
        [self.playControllerView setPlaying:NO];
        return;
    }
    // 播放文章
    YXArticleDetailAttributionStringModel *sentence = self.contentView.attriStrModelList[index];
    [self.bottomView showSpeakerAnimation];
    // 播放控制器开始倒计时
    [self.playControllerView startCoundDownFrom:sentence.sentenceTextStorage.useTimeRange.location];
    [self adjustingContentView:sentence.attributedLabel];
    NSLog(@"当前播放的SentenceID是:%zd", sentence.sentenceTextStorage.realIndex);
    [self.contentView selectSentence:sentence];
    __weak typeof(self) weakSelf = self;
    [[AVAudioPlayerManger shared] startPlaySentence:[NSURL URLWithString:sentence.sentenceTextStorage.audioUrl] finish:^(BOOL isSuccess) {
        [weakSelf playArticleAudioWithFrom:index + 1];
    }];
}

- (void)playSentenceWith:(float)times isPlay:(BOOL)isPlay {
    for (YXArticleDetailAttributionStringModel *model in self.contentView.attriStrModelList) {
        NSRange range = model.sentenceTextStorage.useTimeRange;
        if (times >= range.location && times <= (range.location + range.length)) {
            [self.contentView selectSentence:model];
            [self adjustingContentView:model.attributedLabel];
            if (isPlay) {
                [self playArticleAudioWithFrom:model.sentenceTextStorage.realIndex];
            }
        }
    }
}

- (void)continueplayArticle {
    NSInteger currentIndex = self.contentView.selectedAttrModel.sentenceTextStorage.realIndex;
    [self playArticleAudioWithFrom:currentIndex];
}

- (void)stopArticleAudio {
    self.playing = NO;
    self.playControllerView.playing = NO;
    [[AVAudioPlayerManger shared] stop];
    [self.playControllerView stopCoundDown];
    [self.bottomView stopSpeakerAnimation];
}

- (void)playPreviousSentence {
    NSInteger index = self.contentView.selectedAttrModel.sentenceTextStorage.realIndex - 1;
    if (index < 0) {
        index = 0;
    }
    [self playArticleAudioWithFrom: index];
}

- (void)playNextSenceten {
    NSInteger index = 0;
    if (self.contentView.selectedAttrModel.sentenceTextStorage) {
        index = self.contentView.selectedAttrModel.sentenceTextStorage.realIndex + 1;
    }
    if (index >= self.contentView.attriStrModelList.count) {
        index = self.contentView.attriStrModelList.count - 1;
    }
    [self playArticleAudioWithFrom: index];
}

- (void)showPlayControllerView:(BOOL)isShow {
    if (isShow) {
        [self showPlayControllerView];
    } else {
        [self hidePlayControllerView];
    }
}

- (void)showWordDetailCard:(nonnull YXWordTextStorage *)textStorage point:(CGPoint)point {

    // 显示单词详情
}

- (void)translateArticle:(BOOL)isShow {
    // 显示译文
    [self.contentView setContent:self.articleModel showTranslate:isShow];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentView.maxY);
    }];
}

- (void)showWordDetailView:(YXWordDetailModel *)wordModel bookId:(NSString *)bookId {
    YXWordDetailViewController *detailVC = [YXWordDetailViewController wordDetailWith:wordModel bookId:bookId withBackBlock:^{
        [self.navigationController setNavigationBarHidden:NO];
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)setPreviousBtn:(BOOL)isEnable {
    [self.playControllerView.previousBtn setEnabled:isEnable];
}

- (void)setNextBtn:(BOOL)isEnable {
    [self.playControllerView.nextBtn setEnabled:isEnable];
}

#pragma mark - YXArticleDetailFresherGuideViewDelegate

- (CGRect)fresherGuideViewBlankArea:(YXArticleDetailFresherGuideView *)frensherVIew stepIndex:(NSInteger)step {
    if (step == 1) {
        CGRect rect = [self.playControllerView convertRect:self.playControllerView.frame toView:self.view];
        rect = CGRectMake((SCREEN_WIDTH - rect.size.width)/2 - 5, self.view.height - 160.f - kSafeBottomMargin + kNavHeight - 50.f, rect.size.width + 10, rect.size.height + 60.f);
        return rect;
    }
    return CGRectZero;
}
- (void)stepPrecondition:(NSInteger)step {
    if (step == 1) {
        [self showPlayControllerView];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > 80) {
        self.title = self.articleModel.textTitle;
    } else {
        self.title = @"课文详情";
    }
}

@end
