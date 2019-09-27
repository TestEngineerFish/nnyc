//
//  YXVocabularyView.m
//  YXEDU
//
//  Created by yao on 2018/12/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXVocabularyView.h"
@interface YXVocabularyView ()
@property (nonatomic, weak)UIImageView *leftImage;
@property (nonatomic, weak)UIImageView *rightImage;
@property (nonatomic, weak)UIImageView *vsImage;

@property (nonatomic, weak)UIImageView *myLearnBGImage;
@property (nonatomic, weak)UIImageView *averageBGImage;
@end

@implementation YXVocabularyView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *leftImage = [[UIImageView alloc] init];
        leftImage.image = [UIImage imageNamed:@"reportLearnedImage"];
        [self addSubview:leftImage];
        _leftImage = leftImage;
        
        UIImageView *rightImage = [[UIImageView alloc] init];
        rightImage.image = [UIImage imageNamed:@"reportAverageImage"];
        [self addSubview:rightImage];
        _rightImage = rightImage;
        
        UIImageView *vsImage = [[UIImageView alloc] init];
        vsImage.image = [UIImage imageNamed:@"VSImage"];
        [self addSubview:vsImage];
        _vsImage = vsImage;
        
        
        UIImageView *myLearnBGImage = [[UIImageView alloc] init];
        myLearnBGImage.image = [UIImage imageNamed:@"myLearnedBGImage"];
        [leftImage addSubview:myLearnBGImage];
        _myLearnBGImage = myLearnBGImage;
        
        UIImageView *averageBGImage = [[UIImageView alloc] init];
        averageBGImage.image = [UIImage imageNamed:@"myLearnedBGImage"];
        [rightImage addSubview:averageBGImage];
        _averageBGImage = averageBGImage;
        
        
        UILabel *myLearnedL = [[UILabel alloc] init];
//        myLearnedL.text = @"100";
        myLearnedL.textAlignment = NSTextAlignmentCenter;
        myLearnedL.font = [UIFont boldSystemFontOfSize:AdaptSize(25)];
        myLearnedL.textColor = UIColorOfHex(0x168DF2);
        [myLearnBGImage addSubview:myLearnedL];
        _myLearnedL = myLearnedL;
        
        UILabel *averageL = [[UILabel alloc] init];
//        averageL.text = @"100";
        averageL.textAlignment = NSTextAlignmentCenter;
        averageL.font = [UIFont boldSystemFontOfSize:AdaptSize(25)];
        averageL.textColor = UIColorOfHex(0x8158F0);
        [averageBGImage addSubview:averageL];
        _averageL = averageL;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    
    CGFloat margin = AdaptSize(10);
    CGFloat lImageW =  AdaptSize(151);
    self.leftImage.frame = CGRectMake(margin, AdaptSize(40),lImageW, AdaptSize(160));
    CGRect rightFrame = self.leftImage.frame;
    rightFrame.origin.x = size.width- margin - rightFrame.size.width;
    self.rightImage.frame = rightFrame;
    
    CGFloat vsWH = AdaptSize(61);
    CGFloat x = (size.width - vsWH) * 0.5;
    self.vsImage.frame = CGRectMake(x, self.leftImage.top, vsWH, vsWH);
    
    CGSize bgSize = MakeAdaptCGSize(146, 67);
    CGFloat bgX = (lImageW - bgSize.width) * 0.5;
    self.myLearnBGImage.frame = CGRectMake(bgX,AdaptSize(73),bgSize.width ,bgSize.height);
    self.averageBGImage.frame = self.myLearnBGImage.frame;
    
    
    self.myLearnedL.frame = CGRectMake(0, 0, bgSize.width, AdaptSize(25) + 1);
    self.myLearnedL.center = CGPointMake(bgSize.width * 0.5, bgSize.height * 0.5);
    self.averageL.frame = self.myLearnedL.frame;
}
@end
