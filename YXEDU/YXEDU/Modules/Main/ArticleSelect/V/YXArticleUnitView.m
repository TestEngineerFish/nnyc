//
//  YXArticleUnitView.m
//  YXEDU
//
//  Created by jukai on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleUnitView.h"
#import "YXASRecommendCell.h"
#import "YXASTitleHeader.h"
#import "YXArticleDetailModel.h"
#import "YXUnitDetailModel.h"
#import "YXUnitDetailTextModel.h"
#import "YXArticleUnitCell.h"
#import "YXUnitIdModel.h"
#import "YXArticleDetailViewController.h"


static NSString *const kYXArticleUnitCellID = @"YXArticleUnitCellID";

@interface YXArticleUnitView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UIView *bgView;

@property (nonatomic,weak) UILabel *titleL;

@property (nonatomic,strong) UITableView *myArticleTV;

@property (nonatomic,strong) NSMutableArray *sectionTitles;

@property (nonatomic, weak) UIButton *quitBtn;//退出btn

@property (nonatomic, retain) YXArticleDetailModel *articleDetailModel;


@end

@implementation YXArticleUnitView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(kStatusBarHeight+AdaptSize(185.0));
            make.left.mas_equalTo(self).offset(AdaptSize(0.0));
            make.right.mas_equalTo(self).offset(AdaptSize(0.0));
            make.height.mas_equalTo(SCREEN_HEIGHT - (kStatusBarHeight+AdaptSize(185.0)));
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_top).offset(15);
            make.left.mas_equalTo(self).offset(AdaptSize(10.0));
            make.right.mas_equalTo(self).offset(AdaptSize(-50.0));
        }];
        
        [self.myArticleTV mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(self.bgView.mas_top).offset(45);
            make.left.mas_equalTo(self).offset(AdaptSize(0.0));
            make.right.mas_equalTo(self).offset(AdaptSize(0.0));
            make.height.mas_equalTo(SCREEN_HEIGHT - (kStatusBarHeight+AdaptSize(185.0))-45.0);
        }];
        
        [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_top).offset(10);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-10);
            make.height.width.mas_equalTo(34.0);
        }];
        
        
        self.sectionTitles = [[NSMutableArray alloc]init];
        [self.myArticleTV reloadData];
        
    }
    return self;
}

- (UIView *)bgView {
    
    if (!_bgView) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.0, kStatusBarHeight+AdaptSize(185.0), SCREEN_WIDTH, SCREEN_HEIGHT - (kStatusBarHeight+AdaptSize(185.0)))];
        
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bgView];
        [bgView setUserInteractionEnabled:YES];
        
        //设置所需的圆角位置以及大小
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        bgView.layer.mask = maskLayer;
        
        _bgView = bgView;
        
    }
    return _bgView;
}


-(UILabel *)titleL{
    
    if (!_titleL) {

        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 34,34)];
        [titleL setText:@""];
        [titleL setTextColor:[UIColor blackColor]];
        [self addSubview:titleL];
        _titleL = titleL;
    }
    return _titleL;
}


- (UITableView *)myArticleTV {
    
    if (!_myArticleTV) { //UITableViewStylePlain 悬停
        
        CGFloat leftMargin = iPhone5 ? 0 : 15;
        
        _myArticleTV = [[UITableView alloc] initWithFrame:CGRectMake(leftMargin,0, SCREEN_WIDTH - 2 * leftMargin, SCREEN_HEIGHT-kNavHeight) style:UITableViewStyleGrouped];
        [_myArticleTV setBackgroundColor:[UIColor whiteColor]];
        
        [_myArticleTV registerClass:[YXArticleUnitCell class] forCellReuseIdentifier:kYXArticleUnitCellID];
        

        [_myArticleTV registerClass:[YXASTitleHeader class] forHeaderFooterViewReuseIdentifier:@"YXASTitleHeader"];
        
        _myArticleTV.delegate = self;
        _myArticleTV.dataSource = self;
        
        _myArticleTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myArticleTV.rowHeight =  AdaptSize(80);

        [self addSubview:_myArticleTV];
        
    }
    return _myArticleTV;
}


-(UIButton *)quitBtn{
    
    if (!_quitBtn) {
        
        UIButton *quitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 34,34)];
        
        [quitBtn setImage:[UIImage imageNamed:@"closeBtn"] forState:UIControlStateNormal];
        
        [quitBtn addTarget:self action:@selector(cancleShow) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:quitBtn];
        
        _quitBtn = quitBtn;
    }
    return _quitBtn;
}

-(void)setBookID:(NSInteger)bookID{
    _bookID = bookID;
    [self netBookLearnRankBookID:bookID];
}


//查询用户对一本词书的的学习进度情况
-(void)netBookLearnRankBookID:(NSInteger)bookID{
    
    [YXDataProcessCenter GET:DOMAIN_TEXTBOOKLEARNRANK
                  parameters:@{@"bookId":@(bookID)}
                finshedBlock:^(YRHttpResponse *response, BOOL result)
     {
         if (result) {
             
             if (self.sectionTitles.count>0) {
                 [self.sectionTitles removeAllObjects];
             }
             
             self.articleDetailModel = [YXArticleDetailModel mj_objectWithKeyValues:response.responseObject];
             
             [self.titleL setText:self.articleDetailModel.bookName];
             
             for (YXUnitIdModel *model in self.articleDetailModel.unitIds) {
                 [self.sectionTitles addObject:model.brief];
             }
             
             [self.myArticleTV reloadData];
         }
     }];
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.articleDetailModel.unit.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YXUnitDetailModel *detailModel = self.articleDetailModel.unit[section];
    return detailModel.text.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YXUnitDetailModel *detailModel = self.articleDetailModel.unit[indexPath.section];
    
    YXUnitDetailTextModel *detailTextModel = detailModel.text[indexPath.row];
    
    YXArticleUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXArticleUnitCellID forIndexPath:indexPath];
    
    [cell.titleL setText:detailTextModel.textTitle];
    
    [cell.progressL setText:[NSString stringWithFormat:@"已跟读:%ld%%   已背诵%ld%%",detailTextModel.followRank,detailTextModel.reciteRank]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    YXUnitDetailModel *detailModel = self.articleDetailModel.unit[section];
    
    CGSize labelsize  = [detailModel.unitName
                         boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-54.0, MAXFLOAT)
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:[UIFont pfSCMediumFontWithSize:16.0]}
                         context:nil].size;
    return labelsize.height + 26.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    YXASTitleHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXASTitleHeader"];
    
    [header.nameLab setText:@""];
    [header.nameLab setTextColor:UIColorOfHex(0x55A7FD)];
    
    YXUnitDetailModel *detailModel = self.articleDetailModel.unit[section];
    [header.nameLab setText:detailModel.unitName];
        
    return header;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YXUnitDetailModel *detailModel = self.articleDetailModel.unit[indexPath.section];
    
    YXUnitDetailTextModel *detailTextModel = detailModel.text[indexPath.row];
    
    //跳转到文章详情
    YXArticleDetailViewController *articleDetailViewController = [YXArticleDetailViewController alloc];
    
    articleDetailViewController.jsonUrl = detailTextModel.textJson;
    
    [self setHidden:YES];
    
    [[[UIViewController alloc]init].currentVC.navigationController pushViewController:articleDetailViewController animated:YES];
    
    
}

// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

// 点击目录
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancleShow];
}





- (void)cancleShow{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
