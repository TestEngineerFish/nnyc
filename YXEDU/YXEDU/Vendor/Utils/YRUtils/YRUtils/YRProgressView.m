//
//  YRProgressView.m
//  pyyx
//
//  Created by Chunlin Ma on 15/5/26.
//  Copyright (c) 2015年 朋友印象. All rights reserved.
//

#import "YRProgressView.h"

@interface YRProgressView ()<MBProgressHUDDelegate>

@end

@implementation YRProgressView

+ (void)showHUD:(UIView *)_view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    //当需要消失的时候:
    [hud hideAnimated:YES afterDelay:60];
}

+ (void)hideHUD:(UIView *)_view {
    [MBProgressHUD hideHUDForView:_view animated:YES];
}


+(id)progressViewForView:(UIView*)view{
    
    if(!view) return nil;
    YRProgressView *newView = [[self alloc] initWithView:view];
    newView.removeFromSuperViewOnHide = YES;
    [view addSubview:newView];
    [newView showAnimated:YES];
    return newView;
}

+(id)progressView{
    
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
    //topWindow.windowLevel = UIWindowLevelStatusBar + 2;
    return [self progressViewForView:topWindow];
    
}

+(id)loadingViewForView:(UIView*)view{
    YRProgressView *progress = [self progressViewForView:view];
    progress.label.text = @"正在载入";
    return progress;
    
}



- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}

-(id)successWithString:(NSString*)string{
    self.label.text = string;
    self.minSize = CGSizeMake(125, 0);
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojo_weixiao.png"]];
    // Set custom view mode
    self.mode = MBProgressHUDModeCustomView;
    [self hideAnimated:YES afterDelay:HideTime];
    return nil;
    
}

-(id)successWithDetailString:(NSString*)string{
    self.detailsLabel.text = string;
    self.minSize = CGSizeMake(125, 0);
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojo_weixiao.png"]];
    // Set custom view mode
    self.mode = MBProgressHUDModeCustomView;
    [self hideAnimated:YES afterDelay:HideTime];
    return nil;
    
}

-(id)failedWithString:(NSString*)string{
    
    self.label.text = nil;
    self.detailsLabel.text = string;
    self.minSize = CGSizeMake(125, 0);
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojo_ku.png"]];
    // Set custom view mode
    self.mode = MBProgressHUDModeCustomView;
    [self hideAnimated:YES afterDelay:HideTime];
    return nil;
    
}

-(id)netWorkError{

    return [self failedWithString:@"网络未连接，请检查设置"];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)forceHide{
    
    self.alpha = 0.f;
}

- (void)show
{
    self.alpha = 1.0;
}

-(void)tapped:(UITapGestureRecognizer*)gesture{
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self performSelector:@selector(forceHide) withObject:nil afterDelay:5.0];
    }
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    NSString *message = [[NSUserDefaults standardUserDefaults] objectForKey:@"YRHTTPSUCCESSMESSAGE"];
    if (message.length > 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"YRHTTPSUCCESSMESSAGE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self successWithString:message];
        
    } else {
        [super hide:animated afterDelay:delay];
    }
}
@end
