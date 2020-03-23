
#import "BSRootVC.h"
#import "YXLoadingView.h"
#import "YXWordDetailViewControllerOld.h"
#import "BSUtils.h"
#import "YXUserSaveTool.h"
#import "YXStudyProgressView.h"
#import "YXPosterShareView.h"
#import "YXMyWordListDetailModel.h"
#import "YXWordDetailShareView.h"
#import "YXMyWordBookDetailVC.h"
#import "UIViewController+YXTrace.h"
#import "YRRouter.h"

@interface BSRootVC ()<YXWordDetailShareViewDelegate>
@property(nonatomic, weak) YXTipsBaseView *noNetworkView;
@property(nonatomic, weak) YXTipsBaseView *noDataView;
@property(nonatomic, weak) YXLoadingView *loadingAnimaterView;
@end

@implementation BSRootVC
- (instancetype)init {
    if (self = [super init]) {
        self.popGestureRecognizerEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = UIColorOfHex(0xf0f0f0);
    
#if DEBUG
    // 摇一摇功能
    [self becomeFirstResponder];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[self controllerName]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[self controllerName]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.noNetworkView) {
        self.noNetworkView.frame = self.view.bounds;
    }

    if (self.noDataView) {
        self.noDataView.frame = self.view.bounds;
    }
}

- (void)dealloc {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showNoNetWorkView:(YXTouchBlock)touchBlock {
    if (!self.noNetworkView) {
        self.noNetworkView = [YXTipsBaseView showTipsToView:self.view image:[UIImage imageNamed:@"noNetwork"] tips:@"网络有问题\n点击屏幕重试" touchBlock:[touchBlock copy]];
    }
}

- (void)hideNoNetWorkView {
    if (self.noNetworkView) {
        [self.noNetworkView removeFromSuperview];
        self.noNetworkView = nil;
    }
}

- (void)showNoDataView:(NSString *)tips {
    if (!self.noDataView) {
        tips = tips ? tips : @"暂无数据";
        self.noDataView = [YXTipsBaseView showTipsToView:self.view image:[UIImage imageNamed:@"blankPage"] tips:@"暂无单词数据" touchBlock:nil];
    }
}

- (void)showNoDataView:(NSString *)tips image:(UIImage *)image {
    if (!self.noDataView) {
        tips = tips ? tips : @"暂无数据";
        self.noDataView = [YXTipsBaseView showTipsToView:self.view image:image tips:@"暂无单词数据" touchBlock:nil];
    }
}

- (void)showNoDataView {
    [self showNoDataView:nil];
}

- (void)hideNoDataView {
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
}

- (BOOL)isNetworkAvaiable {
    NetWorkStatus status = [[NetWorkRechable shared] netWorkStatus];
    return (status == NetWorkStatusReachableViaWWAN || status == NetWorkStatusReachableViaWiFi);
}


- (void)showLoadingView {
    if (!_loadingAnimaterView) {
        YXLoadingView *loadingAnimaterView = [[YXLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:loadingAnimaterView];
        _loadingAnimaterView = loadingAnimaterView;
    }
}

- (void)hideLoadingView {
    if (self.loadingAnimaterView) {
        [self.loadingAnimaterView removeFromSuperview];
    }
}

- (void)back {
    if (self.transType == TransationPresent && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;//白色
}





-(void)checkPasteboard
{
    //获取复制内容
    NSString *string = [UIPasteboard generalPasteboard].string;
    
    //获取正则规则
    NSString *popUpRule = [YXConfigure shared].confModel.baseConfig.popUpRule;
    if (![BSUtils isBlankString:popUpRule]) {
        [YXUserSaveTool setObject:popUpRule forKey:@"popUpRule"];
    }
    else {
        popUpRule = [YXUserSaveTool valueForKey:@"popUpRule"];
    }
    
    if ((![BSUtils isBlankString:string]) && (![BSUtils isBlankString:popUpRule])){
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",string];
        NSString *result = [self subStringComponentsSeparatedByStrContent:tempStr strPoint:@"￥" firstFlag:1 secondFlag:2];
        YXLog(@"result %@",result);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", popUpRule];
        
        if ([predicate evaluateWithObject:result]) {
            [self showWordListView:result];
        }
    }
    
}


//查询复制码 对应的词单

-(void)showWordListView:(NSString *)code{
    
    if (code.length) {
        NSDictionary *param = @{@"shareCode" : code};
        [YXDataProcessCenter GET:DOMAIN_SHARECODEWORDLIST
                      parameters:param
                    finshedBlock:^(YRHttpResponse *response, BOOL result)
         {
             if (result) {
                 
                 NSDictionary *details = [response.responseObject objectForKey:@"wordListSimplifiedDetails"];
                 YXLog(@"details %@",details);
                 
                 YXMyWordListDetailModel *detailModel = [YXMyWordListDetailModel mj_objectWithKeyValues:details];
                 
                 //移除 YXWordDetailShareView
                 for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
                     if ([view isKindOfClass:[YXWordDetailShareView class]]) {
                         [view removeFromSuperview];
                     }
                 }
                 
                 
                 [YXWordDetailShareView showShareInView:[UIApplication sharedApplication].keyWindow delegate:self detailModel:detailModel];
                 
             }else {
                 
                 YXMyWordListDetailModel *detailModel =  [YXMyWordListDetailModel alloc];
                 detailModel.code = response.error.code;
                 
                 //移除 YXWordDetailShareView
                 for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
                     if ([view isKindOfClass:[YXWordDetailShareView class]]) {
                         [view removeFromSuperview];
                     }
                 }
                 
                 [YXWordDetailShareView showShareInView:[UIApplication sharedApplication].keyWindow delegate:self detailModel:detailModel];
                 //                 [YXUtils showHUD:nil title:response.error.desc];
             }
         }];
    }
}


#pragma mark - 封装一个截取字符串中同一个字符之间的字符串
/**
 参数说明：
 1.strContent:传入的目标字符串
 2.strPoint:标记位的字符
 3.firstFlag:从第几个目标字符开始截取
 4.secondFlag:从第几个目标字符结束截取
 */
- (NSString *)subStringComponentsSeparatedByStrContent:(NSString *)strContent strPoint:(NSString *)strPoint firstFlag:(int)firstFlag secondFlag:(int)secondFlag
{
    // 初始化一个起始位置和结束位置
    NSRange startRange = NSMakeRange(0, 1);
    NSRange endRange = NSMakeRange(0, 1);
    
    // 获取传入的字符串的长度
    NSInteger strLength = [strContent length];
    // 初始化一个临时字符串变量
    NSString *temp = nil;
    // 标记一下找到的同一个字符的次数
    int count = 0;
    // 开始循环遍历传入的字符串，找寻和传入的 strPoint 一样的字符
    for(int i = 0; i < strLength; i++)
    {
        // 截取字符串中的每一个字符,赋值给临时变量字符串
        temp = [strContent substringWithRange:NSMakeRange(i, 1)];
        // 判断临时字符串和传入的参数字符串是否一样
        if ([temp isEqualToString:strPoint]) {
            // 遍历到的相同字符引用计数+1
            count++;
            if (firstFlag == count)
            {
                // 遍历字符串，第一次遍历到和传入的字符一样的字符
                YXLog(@"第%d个字是:%@", i, temp);
                // 将第一次遍历到的相同字符的位置，赋值给起始截取的位置
                startRange = NSMakeRange(i, 1);
            }
            else if (secondFlag == count)
            {
                // 遍历字符串，第二次遍历到和传入的字符一样的字符
                YXLog(@"第%d个字是:%@", i, temp);
                // 将第二次遍历到的相同字符的位置，赋值给结束截取的位置
                endRange = NSMakeRange(i, i);
            }
        }
    }
    // 根据起始位置和结束位置，截取相同字符之间的字符串的范围
    //异常处理、未找到开始结束的位置、或者只找到开头
    if ((startRange.location == endRange.location)||(startRange.location > endRange.location)) {
        return @"";
    }
    NSRange rangeMessage = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    // 根据得到的截取范围，截取想要的字符串，赋值给结果字符串
    NSString *result = [strContent substringWithRange:rangeMessage];
    // 打印一下截取到的字符串，看看是否是想要的结果
    YXLog(@"截取到的 strResult = %@", result);
    // 最后将结果返回出去
    return result;
}


#pragma mark - YXWordDetailShareViewDelegate
- (void)YXWordDetailShareViewSureDetailModel:(YXMyWordListDetailModel *)detailModel{
    YXMyWordBookDetailVC *detailVC = [[YXMyWordBookDetailVC alloc] initWithMyWordBookModel:detailModel];
    detailVC.isOwnWordList = detailModel.isSelf;
    
    for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
        
        if ([view isKindOfClass:[YXStudyProgressView class]] || [view isKindOfClass:[YXComAlertView class]] || [view isKindOfClass:[YXPosterShareView class]] || [view isKindOfClass:[YXTipsBaseView class]] )
            [view removeFromSuperview];
    }
    
    for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
        
        if ([view isKindOfClass:[YXStudyProgressView class]] || [view isKindOfClass:[YXComAlertView class]] || [view isKindOfClass:[YXPosterShareView class]] || [view isKindOfClass:[YXTipsBaseView class]] )
            [view removeFromSuperview];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)YXWordDetailShareViewSureDetailReload{
    //获取复制内容
    NSString *string = [UIPasteboard generalPasteboard].string;
    if (![BSUtils isBlankString:string]){
        [self showWordListView:string];
    }
}

#pragma mark - 摇一摇，切换环境
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
#if DEBUG
    if (event.subtype == UIEventSubtypeMotionShake && ![[[YRRouter sharedInstance] currentViewController] isKindOfClass:[YYEnvChangeViewController class]]) {
//        UIViewController.currentViewController?.classForCoder != YYEnvChangeViewController.classForCoder()) {
        YYEnvChangeViewController *envCtrl = [[YYEnvChangeViewController alloc] initWithNibName:nil bundle:nil];
        [[[YRRouter sharedInstance] currentNavigationController] pushViewController:envCtrl animated:YES];
        
        
//        self.navigationController?.pushViewController(YYEnvChangeViewController(), animated: true)
    }
#endif
}

@end
