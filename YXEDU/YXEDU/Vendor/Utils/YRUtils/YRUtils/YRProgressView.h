//
//  YRProgressView.h
//  pyyx
//
//  Created by Chunlin Ma on 15/5/26.
//  Copyright (c) 2015年 朋友印象. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#define HideTime 1.8



#define ProgressWith(word)    if (!progressView){progressView = [YRProgressView progressViewForView:self.view];}progressView.labelText = word;

#define Progress(word) if (!progressView){progressView = [YRProgressView progressView];}progressView.labelText = word;

//#define ProgressLoading if (!progressView){progressView = [YRProgressView progressViewForView:self.view];}[progressView show];\
progressView.labelText = @"正在载入";

//#define ProgressDefaultLoading if (!progressView){progressView = [YRProgressView progressView];}\
//progressView.labelText = @"正在默认载入"

//#define ProgressHide if (progressView){ [progressView hide:YES afterDelay:0.3]; progressView = nil;}

#define ProgressHideImmediately if (progressView){ [progressView hide:YES afterDelay:0.f]; progressView = nil;}

#define ProgressSuccess(word) if (!progressView){progressView = [YRProgressView progressViewForView:self.view];}if (progressView) {[progressView successWithString:word];progressView = nil;}

#define ProgressDetailSuccess(word) if (progressView) {[progressView successWithDetailString:word];progressView = nil;}

#define ProgressFailedWith(word)  if (!progressView){progressView = [YRProgressView progressViewForView:self.view];}if (progressView){ progressView = [progressView failedWithString:word];progressView = nil; }if (loadingView){ [loadingView stopAnimating]; loadingView = nil;}
#define ProgressFailed  if (!progressView){progressView = [YRProgressView progressView];}if (progressView){ progressView = [progressView failedWithString:@"连接失败，请重试"];progressView = nil; }
#define ProgressNetWorkError if (!progressView){progressView = [YRProgressView progressView];}if (progressView){ progressView = [progressView netWorkError];progressView = nil;}


#define ProgressErrorDefault if (!progressView){progressView = [YRProgressView progressView];}if (progressView){ progressView = [progressView failedWithString:request.errorDescription?[NSString stringWithFormat:@"%@", request.errorDescription]:@"网络未连接，请检查设置"];progressView = nil; }
#define ProgressAlertView ProgressHide; UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:ticket.serverError?[ticket.serverError descriptionForUI]:@"网络未连接，请检查设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];[alert show];[alert release]

#define YRVisibleIndicator(isShow) [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(isShow)];

@interface YRProgressView : MBProgressHUD

//
+ (void)showHUD:(UIView *)_view;
+ (void)hideHUD:(UIView *)_view;

+(id)progressView;

+(id)progressViewForView:(UIView*)view;

+(id)loadingViewForView:(UIView*)view;


-(id)netWorkError;
-(id)failedWithString:(NSString*)string;

-(id)successWithString:(NSString*)string;

-(id)successWithDetailString:(NSString*)string;

- (void)show;
@end
