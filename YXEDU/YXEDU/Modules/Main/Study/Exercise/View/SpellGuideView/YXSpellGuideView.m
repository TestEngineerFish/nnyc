//
//  YXSpellGuideView.m
//  YXEDU
//
//  Created by jukai on 2019/4/17.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXSpellGuideView.h"

@interface YXSpellGuideView ()
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, weak) UIImageView *tipsImageView;
@property (nonatomic, weak) UIImageView *handImageView;
@end

@implementation YXSpellGuideView

+ (YXSpellGuideView *)spellGuideShowToView:(UIView *)view delegate:(id<YXSpellGuideViewDelegate>)delegate {
    YXSpellGuideView *guideView = [[YXSpellGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    guideView.delegate = delegate;
    [view addSubview:guideView];
    return guideView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.step = 0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextStepEnd)];
        [self addGestureRecognizer:tap];
        [self nextStep];
    }
    return self;
}
- (void)nextStepEnd {
    if ([self.delegate respondsToSelector:@selector(spellGuideView:guideStep:)]) {
        [self.delegate spellGuideView:self guideStep:self.step];
    }
    [self spellGuideShowed:self.spellGuideKey];
    [self removeFromSuperview];
}

- (void)nextStep {
    self.step ++;
    if (self.step > 2) { //finish
        self.step = 1;
    }
    NSString *name = [NSString stringWithFormat:@"答题引导%zd@2x.png",self.step];
    NSString *imagePath =[[NSBundle mainBundle] pathForResource:name ofType:nil];
    self.tipsImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    if (kIsIPhoneXSerious) {
        [self iphoneXSeriousGuideStep];
    }else {
        self.tipsImageView.frame = CGRectMake(0, 0, AdaptSize(282), AdaptSize(524));
        self.tipsImageView.center = CGPointMake(self.center.x, self.center.y+20.0);
    }
    
    [self.handImageView setImage:[UIImage imageNamed:@"小手拷贝2"]];
    [self.handImageView setFrame:CGRectMake(AdaptSize(282)-AdaptSize(30),AdaptSize(450.0), AdaptSize(46), AdaptSize(41))];
    [self.handImageView  setAlpha:0.0];
    [self.handImageView setHidden:NO];
    
    [self performSelector:@selector(nextStep000) withObject:nil afterDelay:1.5];
    [self performSelector:@selector(nextStep001) withObject:nil afterDelay:1.5+0.5];
    [self performSelector:@selector(nextStep002) withObject:nil afterDelay:1.5+0.5+0.5];
    
}

-(void)nextStep000{
    [UIView animateWithDuration:0.5 animations:^{
        [self.handImageView  setAlpha:1.0];
        [self.handImageView setFrame:CGRectMake(AdaptSize(130.0),AdaptSize(320.0), AdaptSize(46), AdaptSize(41))];
    }];
}

-(void)nextStep001{
    [UIView animateWithDuration:0.5 animations:^{
        [self.handImageView setImage:[UIImage imageNamed:@"小手拷贝2"]];
    }];
}

-(void)nextStep002{
    [self nextStep];
}


- (void)iphoneXSeriousGuideStep {
    self.tipsImageView.frame = CGRectMake(0, 0, AdaptSize(282), AdaptSize(524));
    self.tipsImageView.center = CGPointMake(self.center.x, self.center.y+20.0);
}

#pragma mark - subviews
- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        UIImageView *tipsImageView = [[UIImageView alloc] init];
        tipsImageView.userInteractionEnabled = YES;
        [self addSubview:tipsImageView];
        _tipsImageView = tipsImageView;
    }
    return _tipsImageView;
}

- (UIImageView *)handImageView {
    if (!_handImageView) {
        UIImageView *handImageView = [[UIImageView alloc] init];
        handImageView.userInteractionEnabled = YES;
        [handImageView setHidden:YES];
        [self.tipsImageView addSubview:handImageView];
        _handImageView = handImageView;
    }
    return _handImageView;
}



#pragma mark - guideView
+ (BOOL)isspellGuideShowedWith:(NSString *)spellKey {
    BOOL isShow = [[[NSUserDefaults standardUserDefaults] objectForKey:spellKey] boolValue];
    return isShow;
}

- (void)spellGuideShowed:(NSString *)spellKey {
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:spellKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
