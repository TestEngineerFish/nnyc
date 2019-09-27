//
//  YXStudyingBookCell.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMyBookCell.h"
#import "BSCommon.h"
#import "YXBookMaterialManager.h"
//static NSString *const kProgressValueKeyPath = @"progressValue";
@interface YXMyBookCell ()
@property (nonatomic, weak)UILabel *studyPlanL;
@property (nonatomic, weak)UIButton *downLoadButton;
@property (nonatomic, weak)UIButton *studyBookButton;
//@property (nonatomic, weak)YXDownloadProgressView *progressView;
//@property (nonatomic, weak)UIButton *controlBtn;
@end

@implementation YXMyBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
        self.layer.cornerRadius = 6;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.32;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowColor = UIColorOfHex(0xD8E1E9).CGColor;
        
        CGFloat leftMargin = iPhone5 ? 10 : 16;
        self.bookImageView = [[UIImageView alloc]init];
//        self.bookImageView.backgroundColor = UIColorOfHex(0xF97E73);
        self.bookImageView.layer.cornerRadius = 5;
        self.bookImageView.layer.shadowRadius = 5;
        self.bookImageView.layer.shadowOpacity = 0.6;
//        [self.bookImageView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
        self.bookImageView.layer.shadowOffset = CGSizeMake(2, 2);
        self.bookImageView.layer.shadowColor = UIColorOfHex(0x8DADD7).CGColor;
        [self.contentView addSubview:self.bookImageView];
        
        [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(leftMargin);
            make.top.equalTo(self.contentView).offset(16);
            make.size.mas_equalTo(CGSizeMake(91, 113));
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bookImageView);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.progressView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.font = [UIFont boldSystemFontOfSize:16];
        self.titleLab.textColor = UIColorOfHex(0x535353);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.text = @"我是词书名称";
        [self.contentView addSubview:self.titleLab];
        CGFloat titleLeftMargin = iPhone5 ? 10 : 20;
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bookImageView.mas_right).offset(titleLeftMargin);
            make.top.equalTo(self.contentView).offset(32);
        }];
        
        self.totalVocabularyLab = [[UILabel alloc]init];
        self.totalVocabularyLab.font = [UIFont systemFontOfSize:13];
        self.totalVocabularyLab.textColor = UIColorOfHex(0x8095AB);
        self.totalVocabularyLab.textAlignment = NSTextAlignmentLeft;
        self.totalVocabularyLab.text = @"总词汇：9999";
        [self.contentView addSubview:self.totalVocabularyLab];
        [self.totalVocabularyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab);
            make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        }];
        
        self.haveLearnedLab = [[UILabel alloc] init];//WithFrame:CGRectMake(225, 54, 60, 54)
        self.haveLearnedLab.font = [UIFont systemFontOfSize:13];
        self.haveLearnedLab.textColor = UIColorOfHex(0x8095AB);
        self.haveLearnedLab.textAlignment = NSTextAlignmentLeft;
        self.haveLearnedLab.text = @"已学词汇：2339";
        [self.contentView addSubview:self.haveLearnedLab];
        CGFloat labelMargin = iPhone5 ? 10 : 15;
        [self.haveLearnedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.totalVocabularyLab.mas_right).offset(labelMargin);
            make.top.equalTo(self.totalVocabularyLab);
        }];
        
        [self.manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab);
            make.top.equalTo(self.totalVocabularyLab.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(90, 28));
        }];
        
        [self.studyBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.manageBtn);
        }];
        
        [self.downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.manageBtn);
            make.size.equalTo(self.manageBtn);
            make.left.equalTo(self.manageBtn.mas_right).offset(15);
        }];
        
        
        UIView *sepLine = [[UIView alloc] init];
        sepLine.backgroundColor = UIColorOfHex(0xE9EFF4);
        [self.contentView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
            make.top.equalTo(self.bookImageView.mas_bottom).offset(15);
        }];
        
        [self.studyPlanL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bookImageView);
            make.top.equalTo(sepLine.mas_bottom).offset(15);
        }];
        
        UIButton *modifyBtn = [[UIButton alloc] init];
        [modifyBtn setTitle:@"修改>>" forState:UIControlStateNormal];
        modifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [modifyBtn addTarget:self action:@selector(changeStudyPlan:) forControlEvents:UIControlEventTouchUpInside];
        [modifyBtn setTitleColor:UIColorOfHex(0x60B6F8) forState:UIControlStateNormal];
        modifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:modifyBtn];
        [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-16);
            make.centerY.equalTo(self.studyPlanL);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
    }
    return self;
}

- (void)setStudyBookModel:(YXStudyBookModel *)studyBookModel {
    _studyBookModel = studyBookModel;
    self.titleLab.text = studyBookModel.bookName;
    self.totalVocabularyLab.text = [NSString stringWithFormat:@"总词汇:%@", studyBookModel.wordCount];
    self.haveLearnedLab.text = [NSString stringWithFormat:@"已学词汇:%@",studyBookModel.learnedCount];
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:studyBookModel.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.manageBtn.hidden = !studyBookModel.isLearning;
    self.studyBookButton.hidden = studyBookModel.isLearning;
    if (studyBookModel.materialState == kBookMaterialUnDownload) {
        self.downLoadButton.enabled = YES;
        self.progressView.hidden = YES;
    }else {
        self.downLoadButton.enabled = NO;
        NSString *title;
        if (studyBookModel.materialState == kBookMaterialDownloading) {
            self.progressView.hidden = NO;
            title = @"下载中...";
        }else {
            title = @"已下载";
            self.progressView.hidden = YES;
        }
        [self.downLoadButton setTitle:title forState:UIControlStateDisabled];
    }
//    self.downLoadButton.enabled = !studyBookModel.materialDownloaded;
    self.studyPlanL.text = [NSString stringWithFormat:@"学习计划：%@个/天",studyBookModel.planNum];
    
    self.progressView.progress = studyBookModel.progressValue;
}

- (void)setProgress:(CGFloat)progress {
    self.progressView.hidden = NO;
    self.progressView.progress = progress;
}

// 重写侧滑栏按钮,通过遍历出按钮,覆盖新的View来实现
- (void)didTransitionToState:(UITableViewCellStateMask)state {
    [super didTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        NSLog(@"%@", self.subviews);
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                for (int i = 0; i < subview.subviews.count; ++i) {
                    UIButton *btn = subview.subviews[i];
                    if (i == 0) {
                        UIView *repeatView = [[UIView alloc] initWithFrame:btn.bounds];
                        [btn addSubview:repeatView];
                        repeatView.backgroundColor = UIColorOfHex(0xA6B3C1);
                        [repeatView setUserInteractionEnabled:NO];
                        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reset_icon"]];
                        [repeatView addSubview:icon];
                        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(repeatView);
                            make.centerY.equalTo(repeatView).with.offset(-20);
                            make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
                        }];
                        UILabel *title = [[UILabel alloc] init];
                        title.font = [UIFont systemFontOfSize:AdaptSize(17.f)];
                        title.textColor = UIColor.whiteColor;
                        title.text = @"重学";
                        title.textAlignment = NSTextAlignmentCenter;
                        [repeatView addSubview:title];
                        [title mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(repeatView);
                            make.centerY.equalTo(repeatView).with.offset(20);
                            make.size.mas_equalTo(CGSizeMake(repeatView.width, 25.f));
                        }];
                    } else if (i == 1) {
                        UIView *repeatView = [[UIView alloc] initWithFrame:btn.bounds];
                        [btn addSubview:repeatView];
                        repeatView.backgroundColor = UIColorOfHex(0xFC7D8B);
                        [repeatView setUserInteractionEnabled:NO];
                        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete_icon"]];
                        [repeatView addSubview:icon];
                        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(repeatView);
                            make.centerY.equalTo(repeatView).with.offset(-20);
                            make.size.mas_equalTo(CGSizeMake(25.f, 25.f));
                        }];
                        UILabel *title = [[UILabel alloc] init];
                        title.font = [UIFont systemFontOfSize:AdaptSize(17.f)];
                        title.textColor = UIColor.whiteColor;
                        title.text = @"删除";
                        title.textAlignment = NSTextAlignmentCenter;
                        [repeatView addSubview:title];
                        [title mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(repeatView);
                            make.centerY.equalTo(repeatView).with.offset(20);
                            make.size.mas_equalTo(CGSizeMake(repeatView.width, 25.f));
                        }];
                    }
                }
            }
        }
    }
}

#pragma mark - delegate
- (void)changeBook:(id)sender {
    if (self.studyBookModel.isLearning) {
        if ([self.delegate respondsToSelector:@selector(myBookCellChangeBook:)]) {
            [self.delegate myBookCellChangeBook:self];
        }
    }
//    else {
//        if ([self.delegate respondsToSelector:@selector(myBookCellStudyThatBook:)]) {
//            [self.delegate myBookCellStudyThatBook:self];
//        }
//    }
}

- (void)changeStudyPlan:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myBookCellChangeStudyPlan:)]) {
        [self.delegate myBookCellChangeStudyPlan:self];
    }
}

- (void)studyThatBook:(id)sender {
    if ([self.delegate respondsToSelector:@selector(myBookCellStudyThatBook:)]) {
        [self.delegate myBookCellStudyThatBook:self];
    }
}

- (void)downLoadMaterial:(id)sender {
    [self startDownLoad];
    
//    [self.studyBookModel removeObserver:self forKeyPath:kProgressValueKeyPath context:nil];
//    YXStudyBookModel *model = self.studyBookModel;
//    [model addObserver:self
//            forKeyPath:kProgressValueKeyPath
//               options:NSKeyValueObservingOptionNew
//               context:nil];
//    self.studyBookModel.materialState = kBookMaterialDownloading;
//    [[YXBookMaterialManager shareManager] downloadBookMaterial:model.resPath progress:^(NSProgress *downloadProgress) {
//         model.progressValue = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//    } completion:^(YRHttpResponse *response, BOOL result) {
//        self.studyBookModel.materialState = result ? kBookMaterialDownloaded : kBookMaterialUnDownload;
//    }];
    if ([self.delegate respondsToSelector:@selector(myBookCellDownLoadMaterial:)]) {
        [self.delegate myBookCellDownLoadMaterial:self];
    }
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    YXStudyBookModel *model = (YXStudyBookModel *)object;
//    if (![model.bookId isEqualToString:self.studyBookModel.bookId]) {
////        self.progressView.progress = 0.0;
//        return;
//    }else {
//        if ([keyPath isEqualToString:kProgressValueKeyPath]) {
//            self.progressView.progress = [change[NSKeyValueChangeNewKey] floatValue];
//        }
//    }
//}


- (void)downLoadControl {
    [self pauseDownLoad];
    if ([self.delegate respondsToSelector:@selector(myBookCellDownloadStoped:)]) {
        [self.delegate myBookCellDownloadStoped:self];
    }
}

- (void)startDownLoad {
    [self.downLoadButton setTitle:@"下载中..." forState:UIControlStateDisabled];
    self.downLoadButton.enabled = NO;
    self.studyBookModel.materialState = kBookMaterialDownloading;
    self.progressView.hidden = NO;
//    NSString *resPath = [NSString stringWithFormat:@"%@/%@",[YXConfigure shared].confModel.baseConfig.cdn,self.studyBookModel.resUrl];
}

- (void)pauseDownLoad {
    self.downLoadButton.enabled = YES;
    self.progressView.hidden = YES;
}

#pragma mark - subviews
- (UIButton *)manageBtn {
    if (!_manageBtn) {
        _manageBtn = [YXCustomButton comBlueShadowBtnWithSize:CGSizeMake(90, 28)];
        [_manageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_manageBtn setTitle:@"换本书背" forState:UIControlStateNormal];
        [_manageBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_manageBtn addTarget:self action:@selector(changeBook:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_manageBtn];
    }
    return _manageBtn;
}

- (UIButton *)downLoadButton {
    if (!_downLoadButton) {
        UIButton *downLoadButton = [self borderShadowButtonWithRadius:14];
        [downLoadButton addTarget:self action:@selector(downLoadMaterial:) forControlEvents:UIControlEventTouchUpInside];
        [downLoadButton setTitle:@"下载素材包" forState:UIControlStateNormal];
        [downLoadButton setTitle:@"已下载" forState:UIControlStateDisabled];
        [self.contentView addSubview:downLoadButton];
        _downLoadButton = downLoadButton;
    }
    return _downLoadButton;
}

- (UIButton *)studyBookButton {
    if (!_studyBookButton) {
        UIButton *studyBookButton = [self borderShadowButtonWithRadius:14];
        [studyBookButton setTitle:@"学这本书" forState:UIControlStateNormal];
        [studyBookButton addTarget:self action:@selector(studyThatBook:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:studyBookButton];
        _studyBookButton = studyBookButton;
    }
    return _studyBookButton;
}

- (UILabel *)studyPlanL {
    if (!_studyPlanL) {
        UILabel *studyPlanL = [[UILabel alloc] init];
        studyPlanL.font = [UIFont systemFontOfSize:14];
        studyPlanL.textColor = UIColorOfHex(0x485461);
        studyPlanL.text = @"学习计划：20个/天";
        [self.contentView addSubview:studyPlanL];
        _studyPlanL = studyPlanL;
    }
    return _studyPlanL;
}

- (UIButton *)borderShadowButtonWithRadius:(CGFloat)radius {
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = UIColorOfHex(0xF6F8FA);
    button.layer.cornerRadius = radius;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = UIColorOfHex(0xCEDCE8).CGColor;
    button.layer.shadowRadius = 4;
    button.layer.shadowOpacity = 1;
    button.layer.shadowOffset = CGSizeMake(1, 2);
    button.layer.shadowColor = UIColorOfHex(0xD8E1E9).CGColor;
    [button setTitleColor:UIColorOfHex(0x60B6F8) forState:UIControlStateNormal];
    [button setTitleColor:UIColorOfHex(0xA4BBCF) forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    return button;
}

- (YXDownloadProgressView *)progressView {
    if (!_progressView) {
        YXDownloadProgressView *progressView = [[YXDownloadProgressView alloc] init];
        progressView.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
//        progressView.progress = 0.4;
        progressView.thicknessRatio = 1.0;
        progressView.trackTintColor = [UIColor clearColor];
        progressView.hidden = YES;
        [self.contentView addSubview:progressView];
        _progressView = progressView;
    }
    return _progressView;
}

- (UIButton *)controlBtn {
    if (!_controlBtn) {
        UIButton *controlBtn = [[UIButton alloc] init];
        [controlBtn setImage:[UIImage imageNamed:@"download_pause"] forState:UIControlStateNormal];
        [controlBtn addTarget:self action:@selector(downLoadControl) forControlEvents:UIControlEventTouchUpInside];
        [self.progressView addSubview:controlBtn];
        _controlBtn = controlBtn;
    }
    return _controlBtn;
}

@end
