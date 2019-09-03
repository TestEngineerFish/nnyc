//
//  YXHomeUnitCell.m
//  YXEDU
//
//  Created by shiji on 2018/6/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHomeUnitCell.h"
#import "BSCommon.h"
#import "YXBookModel.h"
#import "YXUtils.h"
@interface YXHomeUnitCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) YXUnitNameModel*nameModel;
@end

@implementation YXHomeUnitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(28, 5, SCREEN_WIDTH-56, 78)];
        self.backView.backgroundColor = UIColorOfHex(0xF6F6F6);
        self.backView.layer.cornerRadius = 8.0f;
        self.backView.clipsToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        self.startView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 78)];
        self.startView.backgroundColor = UIColorOfHex(0xF97E73);
        self.startView.clipsToBounds = YES;
        [self.backView addSubview:self.startView];
        
        self.startLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, 70, 14)];
        self.startLab.textColor = UIColorOfHex(0xffffff);
        self.startLab.textAlignment = NSTextAlignmentCenter;
        self.startLab.font = [UIFont systemFontOfSize:10];
        self.startLab.text = @"Starter Unit";
        [self.startView addSubview:self.startLab];
        
        self.unitLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 70, 28)];
        self.unitLab.textColor = UIColorOfHex(0xffffff);
        self.unitLab.textAlignment = NSTextAlignmentCenter;
        self.unitLab.font = [UIFont boldSystemFontOfSize:20];
        self.unitLab.text = @"1";
        [self.startView addSubview:self.unitLab];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, CGRectGetWidth(self.backView.frame)-120, 35)];
        self.titleLab.textColor = UIColorOfHex(0x535353);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
//        self.titleLab.backgroundColor = [UIColor redColor];
        self.titleLab.font = [UIFont boldSystemFontOfSize:14];
        self.titleLab.numberOfLines = 2;
        self.titleLab.text = @"What's this in English?";
        [self.backView addSubview:self.titleLab];
        
        self.haveLearnLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.backView.frame)-73, 52, 73, 14)];
        self.haveLearnLab.textColor = UIColorOfHex(0x666666);
        self.haveLearnLab.textAlignment = NSTextAlignmentLeft;
        self.haveLearnLab.font = [UIFont systemFontOfSize:10];
        self.haveLearnLab.text = @"已学习 10/20";
        [self.backView addSubview:self.haveLearnLab];
        
        self.flowerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.backView.frame)-27, 14, 15, 20)];
        self.flowerImageView.image = [UIImage imageNamed:@"home_flower"];
        [self.backView addSubview:self.flowerImageView];
        
        self.progressView = [[UIView alloc]initWithFrame:CGRectMake(90, 52, CGRectGetWidth(self.backView.frame)-190, 13)];
        self.progressView.backgroundColor = UIColorOfHex(0xE0E0E0);
        self.progressView.layer.cornerRadius = 6.5f;
        self.progressView.clipsToBounds = YES;
        [self.backView addSubview:self.progressView];
        
        self.progressYellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backView.frame)-190, 13)];
        self.progressYellowView.backgroundColor = UIColorOfHex(0xE0E0E0);
        self.progressYellowView.clipsToBounds = YES;
        [self.progressView addSubview:self.progressYellowView];
        
    }
    return self;
}

- (void)insertModel:(id)model {
    YXUnitModel *unitModel = model;
    self.nameModel = [YXUnitNameModel modelWithName:unitModel.name];
    
    self.startLab.text = self.nameModel.line1;
    self.unitLab.text = self.nameModel.line2;
    self.titleLab.text = unitModel.desc;
    self.haveLearnLab.text = [NSString stringWithFormat:@"已学习 %@/%@", unitModel.learned.length==0?@"0":unitModel.learned, unitModel.word.length==0?@"0":unitModel.word];
    if ([unitModel.learned isEqualToString:unitModel.word]) {
        self.flowerImageView.hidden = NO;
    } else {
        self.flowerImageView.hidden = YES;
    }
    
    CGFloat percent = 0;
    if (unitModel.word.intValue == 0) {
        percent = 0;
    } else {
        percent = unitModel.learned.floatValue / unitModel.word.floatValue;
    }
    
    CGRect progressRect = self.progressView.frame;
    CGRect yellowRect = CGRectMake(0, 0, progressRect.size.width * percent, progressRect.size.height);
    self.progressYellowView.frame = yellowRect;
    [self resetGraident];
}

- (void)resetGraident {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.progressYellowView.frame.size.width, self.progressYellowView.frame.size.height);  // 设置显示的frame
    gradientLayer.colors = @[(id)UIColorOfHex(0xFFBE4C).CGColor,(id)UIColorOfHex(0xFFE083).CGColor];  // 设置渐变颜色
    gradientLayer.startPoint = CGPointMake(0, 0);   //
    gradientLayer.endPoint = CGPointMake(1, 0);     //
    [self.progressYellowView.layer addSublayer:gradientLayer];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        if (self.nameModel.visited.length) {
            NSString *hexStr = [self.nameModel.visited substringFromIndex:1];
            long long int hex = [YXUtils numberWithHexString:hexStr];
            self.startView.backgroundColor = UIColorOfHex(hex);
        }
    } else {
        if (self.nameModel.bgcolor.length) {
            NSString *hexStr = [self.nameModel.bgcolor substringFromIndex:1];
            long long int hex = [YXUtils numberWithHexString:hexStr];
            self.startView.backgroundColor = UIColorOfHex(hex);
        }
    }
}



@end
