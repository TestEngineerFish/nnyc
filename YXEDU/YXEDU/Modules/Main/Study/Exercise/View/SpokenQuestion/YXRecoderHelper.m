

//
//  YXRecoderHelper.m
//  YXEDU
//
//  Created by yao on 2018/11/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRecoderHelper.h"

static YXRecoderHelper *sharedHelper = nil;
@interface YXRecoderHelper () <AVAudioPlayerDelegate>
@property (nonatomic, strong)AVAudioSession *session;
@property (nonatomic, strong)AVAudioRecorder *recoder;
@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, strong)NSURL *recordFileUrl;
@property (nonatomic, copy)NSString *recordFilePath;
@property (nonatomic, copy) void(^playFinishBlock)(void);
@end
@implementation YXRecoderHelper
+ (YXRecoderHelper *)shareHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (NSString *)recordFilePath {
    if (!_recordFilePath) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        _recordFilePath = [path stringByAppendingPathComponent:@"myVoice.aac"];
    }
    return _recordFilePath;
}

- (NSURL *)recordFileUrl {
    if (!_recordFileUrl) {
        _recordFileUrl = [NSURL fileURLWithPath:self.recordFilePath];
    }
    return _recordFileUrl;
}

- (NSDictionary *)audioRecordingSettings{
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat:44100.0],AVSampleRateKey ,    //采样率 8000/44100/96000
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,  //录音格式
                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,   //线性采样位数  8、16、24、32
                              [NSNumber numberWithInt:2],AVNumberOfChannelsKey,      //声道 1，2
                              [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey, //录音质量
                              nil];
    return settings;
}

/**
 *  初始化音频检查
 */
-(void)initRecordSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}

/**
 *  开始录音
 */
- (void)statrRecord:(void (^)(BOOL))startSuccessBlock
{
    [self initRecordSession];
    NSError *error = nil;
    AVAudioRecorder *newRecorder = [[AVAudioRecorder alloc]  initWithURL:self.recordFileUrl settings:[self audioRecordingSettings] error:&error];
    self.recoder = newRecorder;
    if (self.recoder != nil) {
        self.recoder.meteringEnabled = YES;
        if ([self.recoder prepareToRecord]) {
            if ([self.recoder record]) {
                if (startSuccessBlock) {
                    startSuccessBlock(YES);
                }
                return;
            }
        }
    }
    if (startSuccessBlock) {
        startSuccessBlock(YES);
    }
}

- (void)stopRecord {
    if (self.recoder) {
        if (self.recoder.isRecording) {
            [self.recoder stop];
        }
        self.recoder = nil;
    }
    [self stopPlaying];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (BOOL)isAvailableWithDeviveMediaType:(AVMediaType)mediaType {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}

- (void)playRecord {
    [self.recoder stop];
//    NSLog(@"%@",self.recordFilePath);
//    BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:self.recordFilePath];
//    if (isExist) { //NSLog(@"存在");
//    }
    [self stopPlaying];
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:&error];
    if (error) {
        [self resetPlayer];
        return;
    }
    self.player.delegate = self;
    //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if ([self.player prepareToPlay]) {
        [self.player play];
    }
}

-(void)deleteOldRecordFile {
    BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:self.recordFilePath];
    if (isExist) { //NSLog(@"存在");
        [[NSFileManager defaultManager] removeItemAtPath:self.recordFilePath error:nil];
    }
}

#pragma mark -
- (void)stopPlaying {
    if (self.player != nil) {
        if ([self.player isPlaying] == YES) {
            [self.player stop];
        }
        self.player = nil;
        [self resetPlayer];
    }
}
- (void)playRecordFinish:(void (^)(void))playFinishBlock {
    self.playFinishBlock = [playFinishBlock copy];
    [self playRecord];
}

- (void)resetPlayer {
    if (self.playFinishBlock) {
        self.playFinishBlock();
    }
    self.player = nil;
    self.playFinishBlock = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self resetPlayer];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self resetPlayer];
}

- (NSData *)currentRecordSoundData {
//    NSURL *url = self.recordFileUrl;
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSLog(@"%@",response.MIMEType);
//    }];
    NSData *data = [NSData dataWithContentsOfFile:self.recordFilePath];
    return data;
}
@end
