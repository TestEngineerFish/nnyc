//
//  YXPersonalMyBadgesCell.m
//  YXEDU
//
//  Created by Jake To on 10/19/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXPersonalSectionCell.h"
#import "YXPersonalBadgeCell.h"

@interface YXPersonalSectionCell()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation YXPersonalSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorOfHex(0xF6F8FA);
        self.colorView = [[UIView alloc] init];
        
        self.sectionNameLabel = [[UILabel alloc] init];
        self.sectionNameLabel.textColor = UIColorOfHex(0x434A5D);
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = UIColor.whiteColor;
        self.containerView.layer.borderWidth = 1;
        self.containerView.layer.borderColor = UIColor.whiteColor.CGColor;
        self.containerView.layer.cornerRadius = 8;
        self.containerView.layer.masksToBounds = NO;
        self.containerView.layer.shadowColor = UIColorOfHex(0xAED7E3).CGColor;
        self.containerView.layer.shadowRadius = 2.5;
        self.containerView.layer.shadowOpacity = 0.44;
        self.containerView.layer.shadowOffset = CGSizeMake(0, 3);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(72, 100);
//        layout.minimumInteritemSpacing = 40;
        layout.minimumLineSpacing = 20;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = UIColor.clearColor;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[YXPersonalBadgeCell class] forCellWithReuseIdentifier:@"YXPersonalBadgeCell"];
        
        [self.contentView addSubview:self.colorView];
        [self.contentView addSubview:self.sectionNameLabel];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.collectionView];
        
        [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(2);
            make.height.mas_equalTo(14);
            make.left.equalTo(self.contentView).offset(16);
            make.top.equalTo(self.contentView).offset(20);
        }];
        
        [self.sectionNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.colorView).offset(6);
            make.centerY.equalTo(self.colorView);
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(156);
            make.left.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-16);
            make.top.equalTo(self.colorView.mas_bottom).offset(16);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView);
            make.right.equalTo(self.containerView);
            make.top.equalTo(self.containerView).offset(20);
            make.bottom.equalTo(self.containerView).offset(-20);
        }];

        
    }
    
    return self;
}

@end
