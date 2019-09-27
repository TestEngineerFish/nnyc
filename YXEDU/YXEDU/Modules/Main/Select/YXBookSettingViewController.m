//
//  YXBookSettingViewController.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookSettingViewController.h"
#import "YXSetProgressView.h"

@interface YXBookSettingViewController () <YXSetProgressViewDelegate>
@property (nonatomic, weak)UIVisualEffectView *blurView;
@property (nonatomic, weak)UIButton *closeBtn;
@property (nonatomic, weak)YXSetProgressView *setProgressView;
@property (nonatomic, weak)UIImageView *imageView;
@end

@implementation YXBookSettingViewController
- (instancetype)initWith:(YXBookInfoModel *)bookModel
     setPlanSuccessBlock:(void (^)(NSString *))setPlanSuccessBlock
{
    if (self = [super init]) {
        self.bookModel = bookModel;
        self.setPlanSuccessBlock = [setPlanSuccessBlock copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.blurView.frame = self.view.bounds;
    self.closeBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - 40, kStatusBarHeight + 2, 40, 40);
    
    CGRect desRect = self.bookTransHelper.transModel.destionationRect;
    CGFloat x = CGRectGetMidX(desRect);
    CGFloat centerY = CGRectGetMaxY(desRect) + 25;
    UILabel *bookNameL = [[UILabel alloc] init];
    
    bookNameL.textAlignment = NSTextAlignmentCenter;
    bookNameL.text = self.bookModel.bookName;//@"人教版七年级上册";
    bookNameL.textColor = [UIColor mainTitleColor];
    bookNameL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:bookNameL];
    bookNameL.frame = CGRectMake(0, 0, 200, 14);
    bookNameL.center = CGPointMake(x, centerY);
    
    UILabel *totolWordL = [[UILabel alloc] init];
    totolWordL.text = [NSString stringWithFormat:@"总词汇：%@",self.bookModel.wordCount];
    totolWordL.textColor = [UIColor secondTitleColor];
    totolWordL.textAlignment = NSTextAlignmentCenter;
    totolWordL.font = [UIFont systemFontOfSize:12];
    totolWordL.frame = CGRectMake(0, 0, 200, 12);
    [self.view addSubview:totolWordL];
    totolWordL.center = CGPointMake(x, bookNameL.bottom + 15);
    [self setProgressView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"1111");
}

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - <YXSetProgressViewDelegate>
//- (void)setProgressViewAffirmBtn:(YXSetProgressView *)pView {
//}

- (void)setProgressViewSetPlan:(YXSetProgressView *)pView withHttpResponse:(YRHttpResponse *)response {
    if (!response.error) { // 设置成功
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.setPlanSuccessBlock) {
                self.setPlanSuccessBlock(self.bookModel.bookId);
            }
        }];
    }
}

#pragma mark - subView
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *closeBtn = [[UIButton alloc] init];
        closeBtn.titleLabel.font = [UIFont iconFontWithSize:17];
        [closeBtn setTitle:kIconFont_error forState:UIControlStateNormal];
        [closeBtn setTitleColor:UIColorOfHex(0x707070) forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
        _closeBtn = closeBtn;
    }
    return _closeBtn;
}

- (UIVisualEffectView *)blurView {
    if (!_blurView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self.view addSubview:blurView];
        _blurView = blurView;
    }
    return _blurView;
}

#pragma mark - bgView
- (YXSetProgressView *)setProgressView {
    if (!_setProgressView) {
        YXBookPlanModel *planModel = [YXBookPlanModel
                                      planModelWith:self.bookModel.bookId
                                      planNum:0
                                      leftWords:[self.bookModel.wordCount integerValue]
                                      todayLeftWords:0];
        YXSetProgressView *setProgressView = [YXSetProgressView setProgressViewWithPlanModel:planModel withDelegate:self];
        setProgressView.layer.borderWidth = 0.5;
        setProgressView.layer.borderColor = UIColorOfHex(0xE1EBF0).CGColor;
        CGFloat showHeight = iPhone5 ? 322 : 352;
        setProgressView.frame = CGRectMake(0, self.view.height - showHeight - kSafeBottomMargin, SCREEN_WIDTH, 420);
        [self.view addSubview:setProgressView];
        _setProgressView = setProgressView;
    }
    return _setProgressView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.bookTransHelper.transModel.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        imageView.layer.shadowColor = UIColorOfHex(0x8DADD7).CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 0);
        imageView.layer.shadowOpacity = 5;
        imageView.layer.shadowRadius = 2;
        imageView.layer.shadowOpacity = 0.6;
        [self.view addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

@end
