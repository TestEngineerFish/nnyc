//
//  YXReadHistoryVC.m
//  YXEDU
//
//  Created by jukai on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXReadHistoryVC.h"
#import "YXReadHistoryCell.h"
#import "YXReadHistoryModel.h"
#import "NSDate+Extension.h"
#import "YXArticleDetailViewController.h"


static NSString *const kYXReadHistoryCellID = @"YXReadHistoryCellID";

@interface YXReadHistoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myArticleTV;
@property (nonatomic, strong) NSMutableArray *textLearnHistoryArray;
@end

@implementation YXReadHistoryVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"读背历史";
    self.textLearnHistoryArray = [NSMutableArray array];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [self.myArticleTV reloadData];
    [self netArticleList];
    
}




- (UITableView *)myArticleTV {
    
    if (!_myArticleTV) { //UITableViewStylePlain 悬停
        
        CGFloat leftMargin = iPhone5 ? 0 : 0;
        
        _myArticleTV = [[UITableView alloc] initWithFrame:CGRectMake(leftMargin,0, SCREEN_WIDTH - 2 * leftMargin, SCREEN_HEIGHT-kNavHeight) style:UITableViewStylePlain];
        
        [_myArticleTV registerClass:[YXReadHistoryCell class] forCellReuseIdentifier:kYXReadHistoryCellID];
        
        _myArticleTV.delegate = self;
        _myArticleTV.dataSource = self;
        
        _myArticleTV.backgroundColor = [UIColor whiteColor];
        _myArticleTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myArticleTV.rowHeight =  AdaptSize(145.0);
        
        [self.view addSubview:_myArticleTV];
    }
    return _myArticleTV;
}

-(void)netArticleList{
    
    [YXDataProcessCenter GET:DOMAIN_TEXTLEARNHISTORY
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result)
     {
         if (result) {
             
             if (self.textLearnHistoryArray.count>0) {
                 [self.textLearnHistoryArray removeAllObjects];
             }
             NSArray *textLearnHistory = [response.responseObject objectForKey:@"textLearnHistory"];
             
             for (NSDictionary *textLearnDict in textLearnHistory) {
                 
                 YXReadHistoryModel *model = [YXReadHistoryModel mj_objectWithKeyValues:textLearnDict];
                 
                 [self.textLearnHistoryArray addObject:model];
                 
             }
             
             [self.myArticleTV reloadData];
         }
     }];
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textLearnHistoryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YXReadHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXReadHistoryCellID forIndexPath:indexPath];
    
    YXReadHistoryModel *model  = self.textLearnHistoryArray[indexPath.row];
    [cell.lastLearnL setText:[NSString stringWithFormat:@"上次学习时间:%@",[NSDate cPointStringFromTimestamp:[NSString stringWithFormat:@"%ld",model.lastLearnTime]]]];
    [cell.titleL setText:model.textTitle];
    [cell.bookL setText:[NSString stringWithFormat:@"from: %@", model.from]];
    [cell.progressL setText:[NSString stringWithFormat:@"已跟读:%ld%%   已背诵%ld%%",model.followRank,model.reciteRank]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YXReadHistoryModel *model  = self.textLearnHistoryArray[indexPath.row];
    //跳转到文章详情
    YXArticleDetailViewController *articleDetailViewController = [YXArticleDetailViewController alloc];
    
    articleDetailViewController.jsonUrl = model.textJson;
    
    [self.navigationController pushViewController:articleDetailViewController animated:YES];
    
}



@end
