
//
//  YXSpokenView.m
//  YXEDU
//
//  Created by yao on 2018/11/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSpokenView.h"
#import "YXAudioAnimations.h"
#import "YXRecoderHelper.h"
#import "YXSpokenResultModel.h"
#import "YXRecordView.h"
#define kTimerDuration 0.2
#define kMaxRecordDuration 5
@interface YXSpokenView ()<YXRecordViewDelegate>
@property (nonatomic, weak) UILabel *wordLabel;
@property (nonatomic, weak)YXAudioAnimations *audioButton;
@property (nonatomic, weak)UILabel *pronceSymbolL;
@property (nonatomic, weak)UILabel *explainL;
@property (nonatomic, weak)UIButton *skipButton;
@property (nonatomic, weak)UIButton *recordButton;
@property (nonatomic, weak)UILabel *recordTips;
@property (nonatomic, weak)UIButton *speakButton;
@property (nonatomic, weak)YXAudioAnimations *uploadBtn;
@property (nonatomic, weak)UIButton *nextQuestion;
@property (nonatomic, weak)UIView *resultView;

@property (nonatomic, weak)UILabel *checkSymbolL;
@property (nonatomic, weak)UILabel *scoreL;
@property (nonatomic, weak)UIButton *repeatBtn;
@property (nonatomic, weak)YXNoHightButton *playRecordBtn;
@property (nonatomic, weak)UIImageView *gifImageView;

@property (nonatomic, assign) YXVoiceRecordState currentRecordState;
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, assign) CGFloat durationTime;

@property (nonatomic, weak)YXRecordView *recordSpeaker;
@property (nonatomic, weak)YXTostView *tostView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL cancleTouchEvent;
@property (nonatomic, copy)NSString *speakStart;
@property (nonatomic, copy)NSString *speakFinish;

@property (nonatomic, assign)NSInteger totalDelayTime;
@end
@implementation YXSpokenView
@dynamic delegate;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorOfHex(0xf6f8fa);
        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(-25);
            make.top.equalTo(self).offset(68);
        }];
        
        [self.audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerY.equalTo(self.wordLabel);
            make.left.equalTo(self.wordLabel.mas_right).offset(10);
        }];
        
        [self.pronceSymbolL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.wordLabel.mas_bottom).offset(20);
        }];
        
        [self.explainL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.pronceSymbolL.mas_bottom).offset(20);
        }];
        
        [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-15 - kSafeBottomMargin);
            make.size.mas_equalTo(CGSizeMake(150, 40));
        }];
        
        [self.recordTips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.skipButton.mas_top).offset(-54);
        }];
        
        [self.recordSpeaker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(129, 130));
            make.bottom.equalTo(self.recordTips.mas_top).offset(-15);
        }];
        
        [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.recordSpeaker);
        }];
        
        [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self.explainL.mas_bottom).offset(35);
            make.height.mas_equalTo(114);
        }];
        
        [self.nextQuestion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(76, 76));
            make.centerX.equalTo(self);
            make.bottom.mas_equalTo(self.skipButton.mas_top).offset(-30);
        }];
        
        [self.tostView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.explainL.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(174, 124));
        }];
    }
    return self;
}

- (void)reloadData {
    [super reloadData];
    self.wordLabel.text = self.wordDetailModel.word;
    NSString *pronceSymbol = [YXConfigure shared].isUsStyle ? self.wordDetailModel.usphone : self.wordDetailModel.ukphone;
    self.pronceSymbolL.text = pronceSymbol;
    self.explainL.text = [NSString stringWithFormat:@"%@%@",self.wordDetailModel.property,self.wordDetailModel.paraphrase];
//    [self playWordSound];
}

- (void)didEndTransAnimated {
    [super didEndTransAnimated];
    if (self.audioButton.userInteractionEnabled) {
        [self.audioButton startAnimating];
        [self playWordSound];
    }
}

#pragma mark - actions
- (void)upLoadingAnimate:(BOOL)isOn {
    self.uploadBtn.hidden = !isOn;
    self.recordSpeaker.hidden = isOn;
    self.recordSpeaker.image = [UIImage imageNamed:@"speaker_normal"];
    [self.recordSpeaker recordViewState:YES];
    if (isOn) {
        [self.uploadBtn startAnimating];
        self.recordTips.text = @"批改中...";
    }else {
        [self.uploadBtn stopAnimating];
    }
}

- (void)nextQuestionAction {
    if ([self.delegate respondsToSelector:@selector(questionBaseViewNeedAppearWordDetailThenEnterNextQuestion:)]) {
        [self.delegate questionBaseViewNeedAppearWordDetailThenEnterNextQuestion:self];
    }
}

- (void)audioButtonClicked:(YXAudioAnimations *)btn {
    [btn startAnimating];
    [self playWordSound];
}

- (void)skipSpoken {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;//[UIApplication sharedApplication].windows.lastObject;//; 
    [YXComAlertView showAlert:YXAlertCommon inView:window info:@"提示" content:@"确定跳过本组口语练习吗？" firstBlock:^(id obj) {
        [self cancleSpeakWith:self.bookOrListId];//self.wordQuestionModel.bookId
        [self traceEvent:kTraceSkipSpokenQuestions descributtion:kConfirmDesc];
    } secondBlock:^(id obj) {
        [self traceEvent:kTraceSkipSpokenQuestions descributtion:kCancleDesc];
    }];
}

- (void)recordAgain {
    [self showResultView:NO];
    [self traceEvent:kTraceRecordQuestion descributtion:@"recordAgain"];
}

- (void)playRecord:(UIButton *)playRecordBtn {
    self.gifImageView.hidden = NO;
    playRecordBtn.userInteractionEnabled = NO;
    [self.gifImageView startAnimating];
    [[YXRecoderHelper shareHelper] playRecordFinish:^{
        [self.gifImageView startAnimating];
        self.gifImageView.hidden = YES;
        playRecordBtn.userInteractionEnabled = YES;
    }];
    [self traceEvent:kTraceRecordQuestion descributtion:kPlayRecordDesc];
}
#pragma mark - handleData
- (void)cancleSpeakWith:(NSString *)bookId {
    NSString *paramKey = @"bookId";
    NSString *domain = DOMAIN_CANCLESPEAKING;
    
    if (self.exerciseType != YXExerciseNormal) {
        paramKey = @"wordListId";
        domain = DOMAIN_WORDLISTSKIPSPEAK;
    }
    NSDictionary *param = @{paramKey : bookId};
    
    [YXDataProcessCenter POST:domain
                   parameters:param
                 finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { //取消口语题成功
            if ([self.delegate respondsToSelector:@selector(spokenViewSkipCurrentGroupSpokenQuestions:)]) {
                [self.delegate spokenViewSkipCurrentGroupSpokenQuestions:self];
            }
        }
    }];
}

- (void)uploadAction {
    YRFormFile *formFile = [[YRFormFile alloc] init];
    formFile.filename = [NSString stringWithFormat:@"%@.aac",self.wordDetailModel.word];
    formFile.data = [[YXRecoderHelper shareHelper] currentRecordSoundData];
    formFile.name = @"speakFile";
    formFile.mineType = @"application/octet-stream"; // 二进制流，不知道下载文件类型
    
    NSString *domain = DOMAIN_ASYNCSPEAKING;
    NSString *wordId = self.wordQuestionModel.wordId;
    NSString *bookOrListId = self.bookOrListId;//self.wordQuestionModel.bookId;
    NSNumber *speakTime = @(self.durationTime);
    NSDictionary *baseParam = @{
                            @"wordId" : wordId,
                            @"speakStart" : _speakStart,
                            @"speakFinish" : _speakFinish,
                            @"speakTime" : speakTime,
                            @"fileName" : formFile.filename
                            };
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:baseParam];
    if (self.exerciseType != YXExerciseNormal) {
        domain = DOMAIN_WORDLISTSPEAKREPORT;
        [param setObject:bookOrListId forKey:@"wordListId"];
    }else {
        [param setObject:bookOrListId forKey:@"bookId"];
    }
    
    [self upLoadingAnimate:YES];
    
    self.totalDelayTime = 0;
    [YXDataProcessCenter upload:domain
                     parameters:param
                appendFormFiles:@[formFile]
                        headers:@{}
                 uploadProgress:^(NSProgress *uploadProgress) {
    } completion:^(YRHttpResponse *response, BOOL result) {
//        [self upLoadingAnimate:NO];
        if (result) { // 上传成功
            NSString *token = [[response.responseObject objectForKey:@"speechx"] objectForKey:@"token"];
            
            [self checkSpokenResult:token];

        }else {
            [self upLoadingAnimate:NO];
            [self showResultView:NO];
            if (response.error.type != kBADREQUEST_TYPE) { // hud添加在自己身上会导致touchbeagan调用werid
                [YXUtils showHUD:self.superview title:response.error.desc];
            }
        }
    }];
}

- (void)checkSpokenResult:(NSString *)token {
    YXSpokenCheckInterval *checkInterval = [YXConfigure shared].confModel.baseConfig.speechx;
    if(self.totalDelayTime > checkInterval.max) { // 超时
        [self upLoadingAnimate:NO];
        [self showResultView:NO];
        [YXUtils showHUD:self.superview title:@"上传失败"];
    }else {
        NSInteger delayTime = (self.totalDelayTime >= checkInterval.delay) ? checkInterval.interval : checkInterval.delay;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.totalDelayTime += delayTime;
            [self checkSpeechxWithToken:token ];
        });
    }
}

- (void)checkSpeechxWithToken:(NSString *)token {
    NSString *domain = DIMAIN_CHECKSPEECHX;
    NSDictionary *param = @{@"fileToken" : token};
    if (self.exerciseType != YXExerciseNormal) {
        domain = DOMAIN_WORDLISTSPEAKRESULT;
        param = @{
                  @"fileToken" : token,
                  @"wordListId": self.bookOrListId
               };
    }
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:domain
                  parameters:param
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
       
        if (result) {
            NSDictionary *speechxres = [response.responseObject objectForKey:@"speechxres"];
            NSInteger status = [[speechxres objectForKey:@"status"] integerValue];
            if (status == 0) { // 成功
                [self upLoadingAnimate:NO];
                YXSpokenResultModel *resultModel = [YXSpokenResultModel mj_objectWithKeyValues:[speechxres objectForKey:@"res"]];
                weakSelf.scoreL.text = resultModel.score;
                weakSelf.checkSymbolL.attributedText = resultModel.symbolAttri;
                [weakSelf showResultView:YES];
            }else if (status == 1) {
                [weakSelf checkSpokenResult:token];//[weakSelf checkSpeechxWithToken:token];
            }else { // 失败
                [self upLoadingAnimate:NO];
                [weakSelf showResultView:NO];
                [YXUtils showHUD:self.superview title:@"上传失败"];
            }
        }else {
            [self upLoadingAnimate:NO];
            [weakSelf showResultView:NO];
        }
        [self traceEvent:kTraceRecordQuestion descributtion:kSpeechXResult];
    }];
}

#pragma mark - >>>>>> 录音状态
- (void)wordSoundPlayFinished {
    [self.audioButton stopAnimating];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint touchPoint = [[touches anyObject] locationInView:self];
//    if (CGRectContainsPoint(self.recordSpeaker.frame, touchPoint)) {
//        [self checkRecord];
//    }else {
//        self.cancleTouchEvent = YES;
//    }
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.cancleTouchEvent) {
//        return;
//    }
//    CGPoint touchPoint = [[touches anyObject] locationInView:self];
//
//    if (touchPoint.y > self.recordSpeaker.frame.origin.y) {
//        self.currentRecordState = YXVoiceRecordState_Recording;
//    }else {
//        self.currentRecordState = YXVoiceRecordState_ReleaseToCancel; // 取消状态
//    }
//    [self dispatchVoiceState];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self touchEnded];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self touchEnded];
//}

- (void)recordViewSholdStartRecord:(YXRecordView *)recordView {
    [self checkRecord];
}

- (void)recodViewStateChanged:(YXRecordView *)recordView {
    if (self.cancleTouchEvent) {
        return;
    }
    self.currentRecordState = recordView.currentRecordState;
    
    [self dispatchVoiceState];
}

- (void)recordViewShouldEndRecord:(YXRecordView *)recordView {
    [self touchEnded];
}
#pragma mark - check recoder
- (void)checkRecord {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    self.currentRecordState = YXVoiceRecordState_Normal;
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
//        [YXUtils showHUD:self title:@"麦克风未打开"];
        [self macroDenied];
        self.cancleTouchEvent = YES;
    }else if (status == AVAuthorizationStatusNotDetermined){
        [[YXRecoderHelper shareHelper] statrRecord:nil];
        [[YXRecoderHelper shareHelper] stopRecord];
        self.cancleTouchEvent = YES;
    }else {
        self.cancleTouchEvent = NO;
        [[YXRecoderHelper shareHelper] statrRecord:^(BOOL success) {
            if (success) {
                self.currentRecordState = YXVoiceRecordState_Recording;
//                self.recordSpeaker.image = [UIImage imageNamed:@"speaker_press"];
                [self startTimer];
                [self dispatchVoiceState];
                self.speakStart = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
            }else {
                self.cancleTouchEvent = YES;
            }
        }];
        [self traceEvent:kTraceRecordQuestion descributtion:kRecordVoiceDesc];
    }
}

- (void)macroDenied {
    if ([self.delegate respondsToSelector:@selector(spokenViewMacrophoneWasDenied:)]) {
        [self.delegate spokenViewMacrophoneWasDenied:self];
    }
}

- (void)touchEnded {
    if (self.cancleTouchEvent) {
        [self stopTimer];
        self.cancleTouchEvent = NO;
        return;
    }
    
    [self stopTimer];
    self.speakFinish = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
    [[YXRecoderHelper shareHelper] stopRecord];
//    self.recordSpeaker.image = [UIImage imageNamed:@"speaker_normal"];

    if (self.currentRecordState == YXVoiceRecordState_Recording) { // 结束touch结束时录制状态
        if (self.durationTime < 0.5) {
            self.currentRecordState = YXBVoiceRecordState_RecordTooShort;
        } else { //可以提交
            [self uploadAction];
            self.currentRecordState = YXVoiceRecordState_Normal;
        }
    }
    [self dispatchVoiceState];
    
    if(self.currentRecordState == YXVoiceRecordState_ReleaseToCancel || self.currentRecordState == YXBVoiceRecordState_RecordTooShort) { //无效资源需删除资源
        [[YXRecoderHelper shareHelper] deleteOldRecordFile];
        self.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tostView.hidden = YES;
            self.userInteractionEnabled = YES;
        });
    }
    self.durationTime = 0.0; // 计时归零
}


- (void)dispatchVoiceState { // 只更新吐司
    self.tostView.currentRecordState = self.currentRecordState;
}

- (void)uploadRefreshView {
    
}
#pragma mark - timer
- (void)counting {
    self.durationTime += kTimerDuration;
    CGFloat remainTime = kMaxRecordDuration - self.durationTime;
    if (remainTime <= 0) {
        [self stopTimer]; // 停止录音
        [self.tostView showRecordCounting:0];
        [[YXRecoderHelper shareHelper] stopRecord];
        self.cancleTouchEvent = YES;
        self.speakFinish = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
        [self uploadAction];
        self.currentRecordState = YXVoiceRecordState_Normal;
        self.durationTime = 0.0; // 计时归零
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tostView.hidden = YES;
        });
        
    } else  { // 正在录音，更新数字
        [self.tostView showRecordCounting:remainTime];
    }
}

- (void)startTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerDuration target:self selector:@selector(counting) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)resetState {
    [self stopTimer];
    self.durationTime = 0;
}

#pragma mark - refreshView
- (void)showResultView:(BOOL)isShow {
    self.resultView.hidden = !isShow;
    self.nextQuestion.hidden = !isShow;
    
    self.recordSpeaker.hidden = isShow;
    self.recordTips.hidden = isShow;
    NSString *tips = isShow ? @"" : @"按住开始跟读英文";
    self.recordTips.text = tips;
}

#pragma mark -subviews
- (UILabel *)wordLabel {
    if (!_wordLabel) {
        UILabel *wordLabel = [[UILabel alloc] init];
        wordLabel.font = [UIFont boldSystemFontOfSize:30];
        wordLabel.textColor = UIColorOfHex(0x485461);
        wordLabel.text = @"Coffee";
        [self addSubview:wordLabel];
        _wordLabel = wordLabel;
    }
    return _wordLabel;
}

- (YXAudioAnimations *)audioButton {
    if (!_audioButton) {
        YXAudioAnimations *audioButton = [YXAudioAnimations playAudioAnimation:NO];
        audioButton.backgroundColor = [UIColor clearColor];
        [audioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:audioButton];
        _audioButton = audioButton;
    }
    return _audioButton;
}

- (YXAudioAnimations *)uploadBtn {
    if (!_uploadBtn) {
        YXAudioAnimations *uploadBtn = [YXAudioAnimations uploadAudioAnimation];
        uploadBtn.backgroundColor = [UIColor clearColor];
        uploadBtn.hidden = YES;
        [uploadBtn addTarget:self action:@selector(uploadAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:uploadBtn];
        _uploadBtn = uploadBtn;
    }
    return _uploadBtn;
}

- (UILabel *)pronceSymbolL {
    if (!_pronceSymbolL) {
        UILabel *pronceSymbolL = [[UILabel alloc] init];
//        pronceSymbolL.text = @"英[kksd]";
        pronceSymbolL.textAlignment = NSTextAlignmentCenter;
        pronceSymbolL.textColor = UIColorOfHex(0x849EC5);
        pronceSymbolL.font = [UIFont systemFontOfSize:15];
        pronceSymbolL.backgroundColor = [UIColor clearColor];
        [self addSubview:pronceSymbolL];
        _pronceSymbolL = pronceSymbolL;
    }
    return _pronceSymbolL;
}

- (UILabel *)explainL {
    if (!_explainL) {
        UILabel *explainL = [[UILabel alloc] init];
        explainL.text = @"n. 咖啡，咖啡店，咖啡";
        explainL.textAlignment = NSTextAlignmentCenter;
        explainL.textColor = UIColorOfHex(0x485461);
        explainL.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:explainL];
        _explainL = explainL;
    }
    return _explainL;
}

- (UILabel *)recordTips {
    if (!_recordTips) {
        UILabel *recordTips = [[UILabel alloc] init];
        recordTips.text = @"按住开始跟读英文";
        recordTips.textAlignment = NSTextAlignmentCenter;
        recordTips.textColor = UIColorOfHex(0x485461);
        recordTips.font = [UIFont systemFontOfSize:17];
        [self addSubview:recordTips];
        _recordTips = recordTips;
    }
    return _recordTips;
}

- (UIButton *)skipButton{
    if (!_skipButton) {
        UIButton *skipButton = [[UIButton alloc] init];
        [skipButton setTitleColor:UIColorOfHex(0x8095ab) forState:UIControlStateNormal];
        [skipButton setTitle:@"跳过本组口语练习" forState:UIControlStateNormal];
        skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [skipButton addTarget:self action:@selector(skipSpoken) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:skipButton];
        _skipButton = skipButton;
    }
    return _skipButton;
}

- (UIButton *)speakButton{
    if (!_speakButton) {
        UIButton *speakButton = [[UIButton alloc] init];
        [speakButton setBackgroundImage:[UIImage imageNamed:@"speaker_normal"] forState:UIControlStateNormal];
        [speakButton setBackgroundImage:[UIImage imageNamed:@"speaker_press"] forState:UIControlStateHighlighted];
        [self addSubview:speakButton];
        _speakButton = speakButton;
    }
    return _speakButton;
}

- (YXRecordView *)recordSpeaker {
    if (!_recordSpeaker) {
        YXRecordView *recordSpeaker = [[YXRecordView alloc] init];
        recordSpeaker.delegate = self;
        [self addSubview:recordSpeaker];
        _recordSpeaker = recordSpeaker;
    }
    return _recordSpeaker;
}

- (UIButton *)nextQuestion{
    if (!_nextQuestion) {
        UIButton *nextQuestion = [[UIButton alloc] init];
        nextQuestion.hidden = YES;
        [nextQuestion setImage:[UIImage imageNamed:@"nextSpoken"] forState:UIControlStateNormal];
        [nextQuestion addTarget:self action:@selector(nextQuestionAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextQuestion];
        _nextQuestion = nextQuestion;
    }
    return _nextQuestion;
}

- (UIView *)resultView {
    if (!_resultView) {
        UIView *resultView = [[UIView alloc] init];
        resultView.hidden = YES;
        [self addSubview:resultView];
        _resultView = resultView;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorOfHex(0xE9EFF4);
        [resultView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.equalTo(resultView);
            make.height.mas_equalTo(1.0);
        }];
        
        
        [self.checkSymbolL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(resultView).offset(30);
            make.left.equalTo(resultView);
        }];
        UILabel *scorTip = [[UILabel alloc] init];
        scorTip.text = @"得分：";
        scorTip.textColor = UIColorOfHex(0x485461);
        scorTip.font = [UIFont systemFontOfSize:17];
        [resultView addSubview:scorTip];
        [scorTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(resultView);
            make.top.equalTo(self.checkSymbolL.mas_bottom).offset(30);
        }];
        
        [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(scorTip);
            make.left.equalTo(scorTip.mas_right);
            make.size.mas_equalTo(CGSizeMake(50, 25));
        }];
        
        CGFloat margin = iPhone5 ? 10 : 20;
        [self.playRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scoreL.mas_right).offset(margin);
            make.centerY.equalTo(self.scoreL).offset(2);
            make.size.mas_equalTo(CGSizeMake(91, 36));
        }];
        
        [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playRecordBtn.mas_right).offset(iPhone5 ? 10 : 15);
            make.centerY.equalTo(self.scoreL);
            make.size.mas_equalTo(CGSizeMake(85, 32));
        }];
    }
    return _resultView;
}

- (UILabel *)checkSymbolL {
    if (!_checkSymbolL) {
        UILabel *checkSymbolL = [[UILabel alloc] init];
        checkSymbolL.text = @"英[kksd]";
        checkSymbolL.font = [UIFont systemFontOfSize:17];
        checkSymbolL.backgroundColor = [UIColor clearColor];
        [self.resultView addSubview:checkSymbolL];
        _checkSymbolL = checkSymbolL;
    }
    return _checkSymbolL;
}

- (UILabel *)scoreL {
    if (!_scoreL) {
        UILabel *scoreL = [[UILabel alloc] init];
        scoreL.text = @"9.2";
        scoreL.font = [UIFont systemFontOfSize:24];
        scoreL.textColor = UIColorOfHex(0x485461);
        [self.resultView addSubview:scoreL];
        _scoreL = scoreL;
    }
    return _scoreL;
}

- (UIButton *)repeatBtn{
    if (!_repeatBtn) {
        UIButton *repeatBtn = [[UIButton alloc] init];
        repeatBtn.backgroundColor = [UIColor whiteColor];
        [repeatBtn setTitleColor:UIColorOfHex(0x60B6F8) forState:UIControlStateNormal];
        [repeatBtn setTitle:@" 重录" forState:UIControlStateNormal];
        [repeatBtn setImage:[UIImage imageNamed:@"repeat_image"] forState:UIControlStateNormal];
        repeatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        repeatBtn.layer.cornerRadius = 16;
        repeatBtn.layer.borderWidth = 1.0;
        repeatBtn.layer.borderColor = UIColorOfHex(0xCEDCE8).CGColor;
        repeatBtn.layer.shadowColor = UIColorOfHex(0x6D8FBC).CGColor;
        repeatBtn.layer.shadowRadius = 2;
        repeatBtn.layer.shadowOffset = CGSizeMake(0, 2);
        repeatBtn.layer.shadowOpacity = 0.2;
        [repeatBtn addTarget:self action:@selector(recordAgain) forControlEvents:UIControlEventTouchUpInside];
        [self.resultView addSubview:repeatBtn];
        _repeatBtn = repeatBtn;
    }
    return _repeatBtn;
}


- (YXNoHightButton *)playRecordBtn{
    if (!_playRecordBtn) {
        YXNoHightButton *playRecordBtn = [[YXNoHightButton alloc] init];
        [playRecordBtn setBackgroundImage:[UIImage imageNamed:@"playRecord"] forState:UIControlStateNormal];
        
        [self.resultView addSubview:playRecordBtn];
        _playRecordBtn = playRecordBtn;
        
        [self.gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(playRecordBtn).offset(-1);
            make.centerY.equalTo(playRecordBtn).offset(-1);
            make.size.mas_equalTo(CGSizeMake(85, 30));
        }];
        [playRecordBtn addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playRecordBtn;
}

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        UIImageView *gifImageView = [[UIImageView alloc] init];
        gifImageView.animationDuration = 1.0;
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i <= 5; i++) {
            NSString *name = [NSString stringWithFormat:@"audioFrequency%d",i];
            UIImage *image = [UIImage imageNamed:name];
            [images addObject:image];
        }
        
        [images addObjectsFromArray:images];
        gifImageView.image = images.firstObject;
        gifImageView.animationImages = images;
        gifImageView.userInteractionEnabled = NO;
        gifImageView.hidden = YES;
        gifImageView.backgroundColor = [UIColor redColor];
        gifImageView.layer.cornerRadius = 15;
        gifImageView.layer.masksToBounds = YES;
        [self.playRecordBtn addSubview:gifImageView];
        _gifImageView = gifImageView;
    }
    return _gifImageView;
}

- (YXTostView *)tostView {
    if (!_tostView) {
        YXTostView *tostView = [[YXTostView alloc] init];
        tostView.hidden = YES;
        [self addSubview:tostView];
        _tostView = tostView;
    }
    return _tostView;
}
@end



//    if (CGRectContainsPoint(self.recordSpeaker.frame, touchPoint)) { // 标记状态
//        self.currentRecordState = YXVoiceRecordState_Recording;
//    } else {
//        self.currentRecordState = YXVoiceRecordState_ReleaseToCancel; // 取消状态
//    }

//    NSLog(@"%f----%@",touchPoint.y,NSStringFromCGRect(self.recordSpeaker.frame));


//            YXSpokenResultModel *resultModel = [YXSpokenResultModel mj_objectWithKeyValues:response.responseObject];
//            self.scoreL.text = resultModel.score;
//            self.checkSymbolL.attributedText = resultModel.symbolAttri;
//            [self showResultView:YES];
