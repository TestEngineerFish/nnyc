



#import "WBQRCodeVC.h"
#import "SGQRCode.h"
#import "YXBaseWebViewController.h"


@interface WBQRCodeVC () {
    SGQRCodeObtain *obtain;
}
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL stop;
@end

@implementation WBQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (_stop) {
        [obtain startRunningWithBefore:nil completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}

- (void)dealloc {
    YXEventLog(@"WBQRCodeVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self setupNavigationBar];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
}

- (void)checkVideoAccess:(void (^)(void))authorizedHander {
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [YXUtils showHUD:self.view title:@"当前相机不可用"];
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if (authorizedHander) {
                    authorizedHander();
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YXUtils showHUD:self.view title:@"获取权限失败"];
                });                
            }
        }];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        if (authorizedHander) {
            authorizedHander();
        }
    } else {
        YXComAlertView *alertView = [YXComAlertView showAlert:YXAlertCommon inView:kWindow info:@"无相机权限" content:@"是否去设置中开启相机权限" firstBlock:^(id obj) {
            NSURL *url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } secondBlock:nil];
        [alertView.firstBtn setTitle:@"去开启" forState:UIControlStateNormal];
        [alertView.secondBtn setTitle:@"算了" forState:UIControlStateNormal];
        YXEventLog(@"没权限啊");
    }
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    [self checkVideoAccess:^{
        SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
        configure.openLog = YES;
        configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
        // 这里只是提供了几种作为参考（共：13）；需什么类型添加什么类型即可
        NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        configure.metadataObjectTypes = arr;

        [obtain establishQRCodeObtainScanWithController:self configure:configure];
        [obtain startRunningWithBefore:^{
            //        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:@"正在加载..." toView:weakSelf.view];
        } completion:^{
            //        [MBProgressHUD SG_hideHUDForView:weakSelf.view];
        }];

        [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {

            if (result) {

                [obtain stopRunning];
                weakSelf.stop = YES;
                [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];

                //判断block是否为空
                if (weakSelf.WBQRCodeVCBlock) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    weakSelf.WBQRCodeVCBlock(result);
                }
            }
        }];
    }];

}

- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
}

- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:self];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    else{
        [YXUtils showHUD:kWindow title:@"暂未识允许相册权限"];
    }
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
    }];
    
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result == nil) {
            YXEventLog(@"暂未识别出二维码");
            [YXUtils showHUD:kWindow title:@"暂未识别出二维码"];
        } else {
            
            [obtain stopRunning];
            weakSelf.stop = YES;
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            
            //判断block是否为空
            if (weakSelf.WBQRCodeVCBlock) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.WBQRCodeVCBlock(result);
            }
            
            
//            //判断block是否为空
//            if (weakSelf.WBQRCodeVCBlock) {
//                weakSelf.WBQRCodeVCBlock(result);
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
            
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        // 静态库加载 bundle 里面的资源使用 SGQRCode.bundle/QRCodeScanLineGrid
        // 动态库加载直接使用 QRCodeScanLineGrid
        _scanView.scanImageName = @"SGQRCode.bundle/QRCodeScanLineGrid";
        _scanView.scanAnimationStyle = ScanAnimationStyleGrid;
        _scanView.cornerLocation = CornerLoactionOutside;
        _scanView.cornerColor = [UIColor colorWithRed:85.0/255.0 green:167.0/255.0 blue:253.0/255.0 alpha:1.0];
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

@end
