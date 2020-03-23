//
//  YXWordDetailToolkitView.m
//  YXEDU
//
//  Created by jukai on 2019/5/15.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXWordDetailToolkitView.h"
#import "YXWordDetailChoiceCell.h"
#import "YXDataProcessCenter.h"
#import "NSDate+Extension.h"
#import "BSUtils.h"

@interface  YXWordDetailToolkitView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)YXWordToolkitModel *toolkitModelodel;
@property (nonatomic, weak)UIImageView *bgImgView; //背景图片
@property (nonatomic, weak)UIImageView *tookkitBoxView; //工具箱图片
@property (nonatomic, weak)UILabel *tookkitNameLabel;//工具箱名字
@property (nonatomic, weak)UILabel *endTimeLabel;//结束时间
@property (nonatomic, weak)UILabel *noteLabel;//提示

@property (nonatomic, weak)UILabel *myCreditsLabel; //我的积分
@property (nonatomic, strong)UITableView *toolkitChoiceTV;//选择开通的天数与积分
@property (nonatomic, weak)UIButton *sureBtn;//确定btn
@property (nonatomic, weak)UIButton *quitBtn;//退出btn
@property (nonatomic, strong)UILabel *noEnoughCreditsLabel; //积分提示


@property (nonatomic, copy) NSMutableArray *comments;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, copy) NSString *code;

@end

@implementation YXWordDetailToolkitView

+ (YXWordDetailToolkitView *)showShareInView:(UIView *)view
                                  toolkitModel:(YXWordToolkitModel *)toolkitModelodel block:(YXWordDetailToolBlock)block{
    
    YXWordDetailToolkitView *toolkitView = [[self alloc] initWithFrame:view.bounds];
    toolkitView.toolkitModelodel = toolkitModelodel;
    toolkitView.toolkitBlock = block;
    [view addSubview:toolkitView];
    return toolkitView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.selectedRow = 0;
        
        self.comments = [NSMutableArray array];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(kStatusBarHeight+AdaptSize(137.0));
            make.left.mas_equalTo(self).offset(AdaptSize(40.0));
            make.right.mas_equalTo(self).offset(AdaptSize(-40.0));
            make.height.mas_equalTo(400.0);
        }];
        
        
        [self.tookkitBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView).offset(24.0);
            make.left.mas_equalTo(self.bgImgView).offset(20.0);
            make.width.mas_equalTo(31.0);
            make.height.mas_equalTo(26.0);
        }];
        
        [self.tookkitNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView).offset(21.0);
            make.left.mas_equalTo(self.bgImgView).offset(64.0);
            make.right.mas_equalTo(self.bgImgView);
            make.height.mas_equalTo(15.0);
        }];
        
        [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView).offset(41);
            make.left.right.height.mas_equalTo(self.tookkitNameLabel);
        }];
        
        [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView).offset(41);
            make.left.right.height.mas_equalTo(self.tookkitNameLabel);
        }];
        
        [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView).offset(70);
            make.left.mas_equalTo(self.bgImgView).offset(17.0);
            make.right.mas_equalTo(self.bgImgView).offset(-17.0);
        }];
        
        [self.myCreditsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView).offset(166);
            make.left.mas_equalTo(self.bgImgView).offset(22.0);
            make.right.mas_equalTo(self.bgImgView).offset(-22.0);
        }];
        
        
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgImgView).offset(-24.0);
            make.left.mas_equalTo(self.bgImgView).offset(62.0);
            make.right.mas_equalTo(self.bgImgView).offset(-62.0);
            make.height.mas_equalTo(38.0);
        }];
        
        
        
        
        [self.toolkitChoiceTV  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView).offset(190.0);
            make.left.mas_equalTo(self.bgImgView).offset(0.0);
            make.right.mas_equalTo(self.bgImgView).offset(0.0);
            make.height.mas_equalTo(125.0);
//            make.bottom.mas_equalTo(self.bgImgView).offset(-90.0);
        }];
        
        [self.noEnoughCreditsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.toolkitChoiceTV.mas_bottom).offset(14.0);
            make.left.mas_equalTo(self.bgImgView).offset(19.0);
            make.right.mas_equalTo(self.bgImgView).offset(-19.0);
            make.height.mas_equalTo(12.0);
        }];
        
        [self.toolkitChoiceTV reloadData];
        [self addSubview:self.quitBtn];
        
        [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImgView.mas_bottom).offset(10.0);
            make.centerX.mas_equalTo(self);
        }];
        
    }
    return self;
}


-(UIImageView *)tookkitBoxView{
    if (!_tookkitBoxView) {
        UIImageView *tookkitBoxView = [[UIImageView alloc]init];
        [tookkitBoxView setImage:[UIImage imageNamed:@"toolkit工具箱"]];
        [self.bgImgView addSubview:tookkitBoxView];
        _tookkitBoxView = tookkitBoxView;
    }
    return _tookkitBoxView;
}



-(UIButton *)quitBtn{
    
    if (!_quitBtn) {
        
        UIButton *quitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,self.bgImgView.origin.y+ self.bgImgView.size.height+17.0, 34,34)];
        
        [quitBtn setBackgroundImage:[UIImage imageNamed:@"toolkit关闭"] forState:UIControlStateNormal];
        quitBtn.centerX = self.centerX;
        
        [quitBtn addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
        
        _quitBtn = quitBtn;
    }
    return _quitBtn;
}



-(UIButton *)sureBtn{
    
    if (!_sureBtn) {
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bgImgView.size.height-77.0, 170.0,38.0)];
        sureBtn.centerX = self.bgImgView.width/2.0;
        
        [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_disable"] forState:UIControlStateNormal];
        
        [sureBtn setUserInteractionEnabled:NO];
        
        [sureBtn.layer setCornerRadius:19.0];
        [sureBtn setClipsToBounds:YES];
        
        [sureBtn setTitle:@"确定开通" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bgImgView addSubview:sureBtn];
        _sureBtn = sureBtn;
    }
    return _sureBtn;
}


-(UILabel *)myCreditsLabel{
    
    if (!_myCreditsLabel) {
        
        UILabel *myCreditsLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, AdaptSize(166.0), self.bgImgView.frame.size.width - 44.0, 20.0)];
        
        myCreditsLabel.text = @"我的积分：";
        
        [myCreditsLabel setFont:[UIFont pfSCMediumFontWithSize:13.0]];
        
        [myCreditsLabel setTextColor:UIColorOfHex(0x485461)];
        
        [self.bgImgView addSubview:myCreditsLabel];
        
        _myCreditsLabel = myCreditsLabel;
        
    }
    return _myCreditsLabel;
}

-(UILabel *)noteLabel{
    
    if (!_noteLabel) {
        
        UILabel *noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(19, 70, self.bgImgView.frame.size.width - 64.0, 75.0)];
        noteLabel.numberOfLines = 0;
        
        [noteLabel setFont:[UIFont pfSCMediumFontWithSize:13.0]];
        
        [noteLabel setTextColor:[UIColor whiteColor]];
        
        NSString *noteStr = @"词汇工具箱，由念念词汇小组根据中考内容精心准备；解锁后即可查看 \"识记方法\" 与 \"中考考点\"";
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:noteStr];
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFFFE93) range:NSMakeRange(attrStr.length-7, 6)];
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFFFE93) range:NSMakeRange(attrStr.length-15, 6)];
        
        [noteLabel setAttributedText:attrStr];
        
        [self.bgImgView addSubview:noteLabel];
        
        _noteLabel = noteLabel;
        
    }
    return _noteLabel;
}


-(UILabel *)endTimeLabel{
    
    if (!_endTimeLabel) {
        
        UILabel *endTimeLabel = [[UILabel alloc]init];
        endTimeLabel.text = @"有效期至 2019-10-20";
        
        [endTimeLabel setFont:[UIFont pfSCMediumFontWithSize:12.0]];
        
        [endTimeLabel setTextColor:[UIColor whiteColor]];
        
        [self.bgImgView addSubview:endTimeLabel];
        
        _endTimeLabel = endTimeLabel;
        
    }
    return _endTimeLabel;
}

-(UILabel *)tookkitNameLabel{
    
    if (!_tookkitNameLabel) {
        UILabel *tookkitNameLabel = [[UILabel alloc]init];
        tookkitNameLabel.text = @"中考词汇工具箱";
        
        [tookkitNameLabel setFont:[UIFont pfSCMediumFontWithSize:15.0]];
        
        [tookkitNameLabel setTextColor:[UIColor whiteColor]];
        
        [self.bgImgView addSubview:tookkitNameLabel];
        
        _tookkitNameLabel = tookkitNameLabel;
    }
    return _tookkitNameLabel;
}


- (UILabel *)noEnoughCreditsLabel{
    if (!_noEnoughCreditsLabel) {
        
        UILabel *noEnoughCreditsLabel = [[UILabel alloc]init];
        [noEnoughCreditsLabel setText:@"*当前积分不足，“完成每日任务”可获取更多积分"];
        [noEnoughCreditsLabel setTextColor:UIColorOfHex(0xFC7D8B)];
        [noEnoughCreditsLabel setTextAlignment:NSTextAlignmentCenter];
        [noEnoughCreditsLabel setFont:[UIFont systemFontOfSize:12.0]];
        [noEnoughCreditsLabel setHidden:YES];
        [noEnoughCreditsLabel setAdjustsFontSizeToFitWidth:YES];
        [self.bgImgView addSubview:noEnoughCreditsLabel];
        _noEnoughCreditsLabel = noEnoughCreditsLabel;
    }
    return _noEnoughCreditsLabel;
}

- (UIImageView *)bgImgView {

    if (!_bgImgView) {
        UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(40.0), kStatusBarHeight+137.0, SCREEN_WIDTH-AdaptSize(80.0), 400.0)];
        [bgImgView setImage:[UIImage imageNamed:@"toolkitBG"]];
        [self addSubview:bgImgView];
        [bgImgView setUserInteractionEnabled:YES];
        _bgImgView = bgImgView;
    }
    return _bgImgView;
}

- (UITableView *)toolkitChoiceTV {
    
    if (!_toolkitChoiceTV) {
        
        UITableView *toolkitChoiceTV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.myCreditsLabel.frame.origin.y + self.myCreditsLabel.frame.size.height + 20.0 , 200.0, 125) style:UITableViewStylePlain];
        
        [toolkitChoiceTV registerNib:[UINib nibWithNibName:@"YXWordDetailChoiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YXWordDetailChoiceCell"];
        
        toolkitChoiceTV.delegate = self;
        toolkitChoiceTV.dataSource = self;
        toolkitChoiceTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        toolkitChoiceTV.rowHeight = AdaptSize(41);
        toolkitChoiceTV.sectionHeaderHeight = AdaptSize(0.01);
        toolkitChoiceTV.showsVerticalScrollIndicator = NO;
        [self.bgImgView addSubview:toolkitChoiceTV];
        _toolkitChoiceTV = toolkitChoiceTV;
        
    }
    return _toolkitChoiceTV;
}



-(void)configCareer{
    
}

//确定开通
-(void)sureBtnAction{
    
    //网络请求
    __weak typeof (self) weakSelf = self;
    [YXDataProcessCenter POST:DOMAIN_USERWORDHANDLEWORDTOOLKIT parameters:@{@"code":self.code} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        
        if (result) {
            [YXUtils showHUD:self title:@"开通成功！"];
            if (weakSelf.toolkitBlock) {
                weakSelf.toolkitBlock(weakSelf);
            }
            [weakSelf cancleShare];
        }
        else {
            NSString *msg = [response.responseObject objectForKey:@"msg"];
            [YXUtils showHUD:self title:msg];
        }
    }];
    
}

#pragma mark - UITableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.comments[indexPath.row];
    
    YXWordDetailChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXWordDetailChoiceCell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (!cell) {
        cell = [[YXWordDetailChoiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YXWordDetailChoiceCell"];
    }
    
    [cell.dayNumLabel setText:[NSString stringWithFormat:@"%@天",[dict objectForKey:@"time"]]];
    
    [cell.creditsLabel setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"credits"]]];
    
    
    if (_selectedRow == indexPath.row)
    {
        [cell.selectedImgView setImage:[UIImage imageNamed:@"toolkitSel"]];
        NSInteger needCredits = [[dict objectForKey:@"credits"]longLongValue];
        self.code = [dict objectForKey:@"code"];
        if ([self.toolkitModelodel.userCredits longLongValue] < needCredits ) {
            [self.noEnoughCreditsLabel setHidden:NO];
            [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_disable"] forState:UIControlStateNormal];
            [self.sureBtn setUserInteractionEnabled:NO];
            [self.sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.bgImgView).offset(-20.0);
            }];
        }
        else{
            [self.noEnoughCreditsLabel setHidden:YES];
            [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_normal"] forState:UIControlStateNormal];
            [self.sureBtn setUserInteractionEnabled:YES];
            [self.sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.bgImgView).offset(-39.0);
            }];
        }
        
    }else{
        [cell.selectedImgView setImage:[UIImage imageNamed:@"toolkitNor"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.comments[indexPath.row];
    
    self.code = [dict objectForKey:@"code"];
    
    self.selectedRow = indexPath.row;
    
    [self.toolkitChoiceTV reloadData];
    
    NSInteger needCredits = [[dict objectForKey:@"credits"]longLongValue];
    
    if ([self.toolkitModelodel.userCredits longLongValue] < needCredits ) {
        [self.noEnoughCreditsLabel setHidden:NO];
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_disable"] forState:UIControlStateNormal];
        [self.sureBtn setUserInteractionEnabled:NO];
        [self.sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgImgView).offset(-20.0);
        }];
    }
    else{
        [self.noEnoughCreditsLabel setHidden:YES];
        [self.sureBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_normal"] forState:UIControlStateNormal];
        [self.sureBtn setUserInteractionEnabled:YES];
        [self.sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgImgView).offset(-39.0);
        }];
    }
}


-(void)setToolkitModelodel:(YXWordToolkitModel *)toolkitModelodel{
    _toolkitModelodel = toolkitModelodel;
    [self updateUIs];
}

-(void)updateUIs{
    YXLog(@"updateUIs");

    self.comments = [_toolkitModelodel.comment copy];
    
//    [self.tookkitNameLabel setText:_toolkitModelodel.name];
    [self.tookkitNameLabel setText:@"中考词汇工具箱"];
    NSString *userCredits = @"";
    if(![BSUtils isBlankString:_toolkitModelodel.userCredits]){
        userCredits = _toolkitModelodel.userCredits;
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"我的积分：%@",userCredits]];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0x485461) range:NSMakeRange(0, attrStr.length)];
    
    UIImage *image = [UIImage imageNamed:@"toolkit豆"];
    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -5, 31, 21);
    
    NSAttributedString *attrStr1 = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [attrStr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:5];
    
    [attrStr insertAttributedString:attrStr1 atIndex:6];
    [attrStr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:7];
    
    

    [self.myCreditsLabel setAttributedText:attrStr];
    
    NSString *wordToolkitState = _toolkitModelodel.wordToolkitState;
    if ([wordToolkitState isEqualToString:@"1"]) {
        [self.endTimeLabel setText:@"未解锁"];
    }
    else if ([wordToolkitState isEqualToString:@"3"]) {
        [self.endTimeLabel setText:@"未解锁"];
    }
    else {
        [self.endTimeLabel setText:[NSString stringWithFormat:@"有效期至：%@",[NSDate cStringFromTimestamp: _toolkitModelodel.endTime]]];
    }
    
//    [self.toolkitChoiceTV reloadData];
}


- (void)cancleShare {

    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self cancleShare];
}


@end
