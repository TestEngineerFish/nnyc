//
//  YXWordDetailShareView.m
//  YXEDU
//
//  Created by jukai on 2019/4/25.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXWordDetailShareView.h"
#import "BSUtils.h"

@interface YXWordDetailShareView()

@property (nonatomic, strong)YXMyWordListDetailModel *detailModel;
@property (nonatomic, weak) UIImageView *wordListBGView;
@property (nonatomic, weak) UILabel *wordListTitleLabel;
@property (nonatomic, weak) UILabel *wordListNumLabel;
@property (nonatomic, weak) UIButton *sureBtn;
@property (nonatomic, weak) UIImageView *noNetImgView;
@property (nonatomic, weak) UIImageView *noWordImgView;
@property (nonatomic, weak) UILabel *noWordLabel;

@end

@implementation YXWordDetailShareView

+ (YXWordDetailShareView *)showShareInView:(UIView *)view delegate:(id<YXWordDetailShareViewDelegate>)delegate
                               detailModel:(YXMyWordListDetailModel *)detailModel{
    
    YXWordDetailShareView *shareView = [[self alloc] initWithFrame:view.bounds];
    shareView.detailModel = detailModel;
    shareView.delegate = delegate;
    [view addSubview:shareView];
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        UIImageView *shareBGView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+AdaptSize(197.0), AdaptSize(260.0), AdaptSize(235.0))];
        [shareBGView setImage:[UIImage imageNamed:@"shareWordListBG"]];
        [self addSubview:shareBGView];
        shareBGView.layer.cornerRadius = 13;
        shareBGView.layer.masksToBounds = YES;
        shareBGView.centerX = self.centerX;
        [shareBGView setUserInteractionEnabled:YES];
        
        UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(6, AdaptSize(448.0), AdaptSize(34.0), AdaptSize(34.0))];
        [cancleBtn setImage:[UIImage imageNamed:@"shareWordList关闭"] forState:UIControlStateNormal];
        [cancleBtn setImage:[UIImage imageNamed:@"shareWordList关闭"] forState:UIControlStateSelected];
        [cancleBtn addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
        
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(shareBGView.mas_bottom).with.offset(10);
            make.centerX.equalTo(shareBGView);
        }];
        
        UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(15.0), AdaptSize(16.0), AdaptSize(27.0), AdaptSize(27.0))];
        [logoView setImage:[UIImage imageNamed:@"shareWordList口令图标"]];
        [shareBGView addSubview:logoView];
        
        
        UILabel *codeWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(50.0), AdaptSize(22.0), AdaptSize(60.0), AdaptSize(13.0))];
        codeWordLabel.text = @"念念口令";
        codeWordLabel.textColor = UIColorOfHex(0x8095AB);
        [codeWordLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [shareBGView addSubview:codeWordLabel];
        
        
        UIImageView *wordListBGView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(18.0), AdaptSize(71.0), AdaptSize(60.0), AdaptSize(60.0))];
        [wordListBGView setImage:[UIImage imageNamed:@"shareWordList词单封面"]];
        [shareBGView addSubview:wordListBGView];
        [wordListBGView setHidden:YES];
        self.wordListBGView = wordListBGView;
        
        UILabel *wordListTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(88.0), AdaptSize(81.0), shareBGView.size.width-AdaptSize(88.0), AdaptSize(16.0))];
        wordListTitleLabel.text = @"旅游常用语句";
        wordListTitleLabel.textColor = UIColorOfHex(0x434A5D);
        [wordListTitleLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular]];
        [shareBGView addSubview:wordListTitleLabel];
        [wordListTitleLabel setHidden:YES];
        self.wordListTitleLabel = wordListTitleLabel;
        
        
        UILabel *wordListNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(88.0), AdaptSize(108.0), shareBGView.size.width-AdaptSize(88.0), AdaptSize(13.0))];
        wordListNumLabel.text = @"共30个单词";
        wordListNumLabel.textColor = UIColorOfHex(0x8095AB);
        [wordListNumLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular]];
        [shareBGView addSubview:wordListNumLabel];
        [wordListNumLabel setHidden:YES];
        self.wordListNumLabel = wordListNumLabel;
        
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptSize(45.0), AdaptSize(172.0), AdaptSize(170.0), AdaptSize(38.0))];
        
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"com_btn_normal"] forState:UIControlStateNormal];
        [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [sureBtn setTitle:@"查看词单详情" forState:UIControlStateNormal];
        sureBtn.layer.cornerRadius = AdaptSize(38.0)/2.0 - 1.0;
        [sureBtn setClipsToBounds:YES];
        
        [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [shareBGView addSubview:sureBtn];
        [sureBtn setHidden:YES];
        self.sureBtn = sureBtn;
        
        UIImageView *noNetImgView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(18.0), AdaptSize(60.0), AdaptSize(203.0*0.5), AdaptSize(191.0*0.5))];
        [noNetImgView setImage:[UIImage imageNamed:@"shareWordList网络不给力"]];
        [shareBGView addSubview:noNetImgView];
        noNetImgView.centerX = AdaptSize(260.0)*0.5;
        [noNetImgView setHidden:YES];
        self.noNetImgView = noNetImgView;
        
        UIImageView *noWordImgView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptSize(18.0), AdaptSize(60.0), AdaptSize(218.0*0.5), AdaptSize(176.0*0.5))];
        [noWordImgView setImage:[UIImage imageNamed:@"shareWordList词单不存在"]];
        noWordImgView.centerX = shareBGView.frame.size.width*0.5;
        [shareBGView addSubview:noWordImgView];
        noWordImgView.centerX = AdaptSize(260.0)*0.5;
        [noWordImgView setHidden:YES];
        self.noWordImgView = noWordImgView;
        
        UILabel *noWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(AdaptSize(88.0), AdaptSize(184.0), shareBGView.size.width-AdaptSize(88.0), AdaptSize(15.0))];
        noWordLabel.text = @"词单不存在";
        noWordLabel.textColor = UIColorOfHex(0x8095AB);
        [noWordLabel setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular]];
        [noWordLabel setTextAlignment:NSTextAlignmentCenter];
        [shareBGView addSubview:noWordLabel];
        [noWordLabel setHidden:YES];
        noWordLabel.centerX = AdaptSize(260.0)*0.5;
        self.noWordLabel = noWordLabel;
        
    }
    return self;
}

-(void)setDetailModel:(YXMyWordListDetailModel *)detailModel{
    
    _detailModel = detailModel;
    
    //网络错误
    if (_detailModel.code == -1009) {
        
        [self.noNetImgView setHidden:NO];
        [self.sureBtn setHidden:NO];
        [self.sureBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        
        [self.wordListTitleLabel setHidden:YES];
        [self.wordListNumLabel setHidden:YES];
        [self.wordListBGView setHidden:YES];
        [self.noWordLabel setHidden:YES];
        [self.noWordImgView setHidden:YES];
    }
    //找不到词单
    else if (_detailModel.code == 13031) {
        
        [self.noWordLabel setHidden:NO];
        [self.noWordImgView setHidden:NO];
        
        [self.sureBtn setHidden:YES];
        [self.noNetImgView setHidden:YES];
        [self.wordListTitleLabel setHidden:YES];
        [self.wordListNumLabel setHidden:YES];
        [self.wordListBGView setHidden:YES];
    }
    
    else if (![BSUtils isBlankString:_detailModel.wordListId]){
        [self.wordListTitleLabel setText:_detailModel.wordListName];
        [self.wordListTitleLabel setHidden:NO];
        [self.wordListNumLabel setText:[NSString stringWithFormat:@"共%ld个单词",(long)_detailModel.total]];
        [self.wordListNumLabel setHidden:NO];
        [self.wordListBGView setHidden:NO];
        [self.sureBtn setHidden:NO];
        [self.noNetImgView setHidden:YES];
        [self.noWordLabel setHidden:YES];
        [self.noWordImgView setHidden:YES];
    }
    
}


-(void)sureBtnAction{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    }];
    
    if (_detailModel.code == -1009) {
        if ([self.delegate respondsToSelector:@selector(YXWordDetailShareViewSureDetailReload)]) {
            [self.delegate YXWordDetailShareViewSureDetailReload];
        }
        return ;
    }
    //清除复制板内容
    [[UIPasteboard generalPasteboard] setString:@""];
    
    if ([self.delegate respondsToSelector:@selector(YXWordDetailShareViewSureDetailModel:)]) {
        
        [self.delegate YXWordDetailShareViewSureDetailModel:_detailModel];
    }
    
}

- (void)cancleShare {
    
    //清除复制板内容
    [[UIPasteboard generalPasteboard] setString:@""];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
        }];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
