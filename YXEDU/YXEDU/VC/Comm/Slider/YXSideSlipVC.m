//
//  YXSliderBackVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSideSlipVC.h"

#import "BSCommon.h"

@interface YXSideSlipVC ()

@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation YXSideSlipVC
@synthesize frontVC = _frontVC;

- (instancetype)initFrontVC:(UIViewController *)frontVC
{
    self = [super init];
    if (self) {
        _frontVC = frontVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    self.frontVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addChildViewController:self.frontVC];
    [self.view addSubview:self.frontVC.view];
    [self.frontVC didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.frontVC.view];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.frontVC.view addGestureRecognizer:pan];
}

- (void)pan:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.currentPoint = [gesture locationInView:self.frontVC.view];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.frontVC.view.frame.origin.x >= 0 && self.frontVC.view.frame.origin.x <= [self sliderWidth]) {
            CGFloat diff = [gesture locationInView:self.frontVC.view].x - self.currentPoint.x;
            CGFloat x = self.frontVC.view.frame.origin.x + diff;
            if (x <= 0) {
                self.frontVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } else if (x >= [self sliderWidth]) {
                self.frontVC.view.frame = CGRectMake([self sliderWidth], 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } else {
                self.frontVC.view.frame = CGRectMake(x, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        [UIView animateKeyframesWithDuration:0.1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            if (self.frontVC.view.frame.origin.x < [self sliderWidth]/2.0) {
                self.frontVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } else {
                self.frontVC.view.frame = CGRectMake([self sliderWidth], 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
        } completion:^(BOOL finished) {
            
        }];
    } 
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.frontVC beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.frontVC endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.frontVC beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.frontVC endAppearanceTransition];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (CGFloat)sliderWidth {
    if ([self.dataSource respondsToSelector:@selector(sliderWidth)]) {
        return [self.dataSource sliderWidth];
    } return SCREEN_WIDTH/3.0;
}

- (UIViewController *)frontVC {
    if (!_frontVC) {
        _frontVC = [[UIViewController alloc]init];
    }
    return _frontVC;
}

- (void)setFrontVC:(UIViewController *)frontVC {
    _frontVC = frontVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
