//
//  ALCAudioTool.m
//  AnLanBB
//
//  Created by zk on 2020/4/1.
//  Copyright © 2020 kunzhang. All rights reserved.
//

#import "ALCAudioTool.h"
#import "ConvertAudioFile.h"
#define kRecordAudioFile @"myRecord.caf"
#define ETRECORD_RATE 96000
static ALCAudioTool *tool = nil;

@interface ALCAudioTool()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>



//背景
@property (nonatomic,strong) UIImageView *viewBg;

//音量
@property (nonatomic,strong) UIProgressView *progressView;

//开始录制
@property (nonatomic,strong) UIButton *start;

//暂停录制
@property (nonatomic,strong) UIButton *pause;

//停止录制
@property (nonatomic,strong) UIButton *stop;

//播放录音
@property (nonatomic,strong) UIButton *play;

//播放网络音频
@property (nonatomic,strong) UIButton *playNetAudio;

//定时器
@property (nonatomic,weak) NSTimer *timer;


@property(nonatomic,strong)NSData *audioData;


@property(nonatomic,strong)AVPlayer *avPlayer;
@property(nonatomic,strong)AVPlayerItem *mp3PlayerItem;

@property(nonatomic,assign)BOOL isPlayingMap3;

@property(nonatomic,strong)NSString *pathNameStr;

@end


@implementation ALCAudioTool

+ (ALCAudioTool *)shareTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ALCAudioTool alloc] init];
    });
    return tool;
}



- (BOOL)checkMicrophonePermission{
    
    //    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    //    return permission == AVAudioSessionRecordPermissionGranted;
    __block BOOL bCanRecord = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
            
            bCanRecord = NO;
            // 未询问用户是否授权
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                    if (granted) {//用户选择允许
                        bCanRecord = YES;
                    } else {//用户选择不允许
                        bCanRecord = NO;
                        
                    }
                }];
            }
        } else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
            bCanRecord = NO;//用户在第一次系统弹窗后选择不允许之后，再次录音的时候会走这里“麦克风权限未授权”
            // 未授权
        } else{
            bCanRecord = YES;
            // 已授权
            NSLog(@"已授权");
            
            
        }
    }
    return bCanRecord;
}


- (void)popUpMicrophonePermissionAlertView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"麦克风权限未开启"message:@"麦克风权限未开启,请进入系统【设置】>【隐私】>【麦克风】中打开开关,开启麦克风功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定");
            //跳入当前App设置界面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController animated:YES completion:nil];
    });
}




#pragma mark - OverRide Method
- (AVAudioRecorder*)avaudioRecorder
{
    if (!_avaudioRecorder) {
        
        AVAudioSession* session = [AVAudioSession sharedInstance];
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
        [session setActive:YES error:nil];
        
        
        
        NSError *error = nil;
        _avaudioRecorder = [[AVAudioRecorder alloc]initWithURL:[self getSavePath] settings:[self recordConfigure] error:&error];
        
        _avaudioRecorder.delegate = self;
        
        //如果要监控声波则必须设置为YES
        _avaudioRecorder.meteringEnabled = YES;
        
        // 把录音文件加载到缓冲区
        [_avaudioRecorder prepareToRecord];
        
        if (error) {
            
            NSAssert(YES, @"录音机初始化失败,请检查参数");
            
        }
        
        
        
    }
    
    return _avaudioRecorder;
    
}//录音机


//- (AVAudioPlayer*)avaudioPlayer
//{
//    if (!_avaudioPlayer) {
//
//        NSError *error = nil;
//
//        _avaudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[self getSavePath] error:&error];
//
//        //设置代理
//        _avaudioPlayer.delegate = self;
//
//        //将播放文件加载到缓冲区
//        [_avaudioPlayer prepareToPlay];
//
//    }
//
//    return _avaudioPlayer;
//}


- (NSTimer*)timer
{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDataProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer  forMode:NSRunLoopCommonModes];
    }
    
    return _timer;
    
}//定时器

- (NSURL*)getSavePath
{
    
    //    //获取沙盒根目录
    //    NSString *homePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //
    //    NSString *filePath =  [homePath stringByAppendingPathComponent:recordPath];
    //
    //    return [NSURL URLWithString:filePath];
    
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
    
    
}//设置存储路径

- (void)delectPath  {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"kRecordAudioFile"];
    
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    
    if (bRet) {
        
        //
        
        NSError *err;
        
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
        
    }
    
}


- (NSMutableDictionary*)recordConfigure
{
    NSMutableDictionary *configure = [NSMutableDictionary dictionary];
    
    //设置录音格式
    [configure setObject:@(kAudioFormatAppleIMA4) forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [configure setObject:@8000 forKey:AVSampleRateKey];
    //设置通道
    [configure setObject:@1 forKey:AVNumberOfChannelsKey];
    //设置采样点位数 ，分别 8、16、24、32
    [configure setObject:@32 forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [configure setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //设置录音质量:中等质量
    [configure setObject:@(AVAudioQualityMax) forKey:AVEncoderAudioQualityKey];
    
    // ... 其他设置
    return configure;
    
}//录音配置

// 重新录音
- (void)reStartRecord {
    self.timeNumber = 0;
    [self.avaudioRecorder deleteRecording];
    [self startRecord];
}

- (void)startRecord
{
    if (![self.avaudioRecorder isRecording]) {
        [self.avaudioRecorder record];
        self.timer.fireDate = [NSDate distantPast];
        
    }
    [self stopPlayRecord];
}//开始录音


- (void)pauaseRecord
{
    
    if ([self.avaudioRecorder isRecording]) {
        
        [self.avaudioRecorder pause];
        
        self.timer.fireDate = [NSDate distantFuture];
        
    }
    
}//暂停录音

- (void)stopRecord
{
    //调用这个方法后，直接执行录制完成的代理方法
    [self.avaudioRecorder stop];
    
    self.timer.fireDate = [NSDate distantFuture];
    self.timeNumber = 0;
    //    [self.progressView setProgress:0 animated:YES];
    
    
}//停止录音


- (void)upDataProgress
{
    
    //更新测量值
    [self.avaudioRecorder updateMeters];
    //取得第一个通道的音频，注意音频强度范围时-160到0
    float power= [self.avaudioRecorder averagePowerForChannel:0];
    
    NSLog(@"power ===== %f\n",power);
    
    
    CGFloat progress = 40+power;
    //    [self.progressView setProgress:progress animated:YES];
    
    self.timeNumber++;
    NSLog(@"progress ===== %f\n",progress);
    
    if (self.averagePowerBlock != nil) {
        self.averagePowerBlock(progress,self.timeNumber);
    }
    
}//显示音波强度

- (void)playRecord
{
    NSError *error = nil;
    
    //     self.avaudioPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData error:&error];
    self.avaudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[self getSavePath] error:&error];
    
    //设置代理
    self.avaudioPlayer.delegate = self;
    
    //将播放文件加载到缓冲区
    [self.avaudioPlayer prepareToPlay];
    
    
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:(AVAudioSessionPortOverrideSpeaker) error:&error];;
    self.avaudioPlayer.numberOfLoops = 0;
    self.avaudioPlayer.volume =1;
    [self.avaudioPlayer prepareToPlay];
    [self.avaudioPlayer play];
    
    
    
}


- (void)stopPlayRecord {
    [self.avaudioPlayer stop];
}

#pragma mark -  AVAudioRecorder  Delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
    NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];//
    [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];//采样率
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];//声音通道，这里必须为双通道
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];//音频质量
    [recordSetting setValue:@32 forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:@(YES) forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue:@(YES) forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue:@(AVAudioQualityMax) forKey:AVEncoderAudioQualityKey];

    
    NSString *cafFilePath = recorder.url.path;    //caf文件路径
    NSLog(@"\n录音文件位置%@",cafFilePath);
    
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:@"33333.mp3"];
    
    WeakObj(self);
    
    [ConvertAudioFile conventToMp3WithCafFilePath:cafFilePath mp3FilePath:urlStr sampleRate:8000 callback:^(BOOL result) {
       
        NSLog(@"%@",@"录音转码成功");
        
        selfWeak.audioData = [NSData dataWithContentsOfFile:urlStr];
        
        if (selfWeak.statusBlock != nil) {
            selfWeak.statusBlock(NO,selfWeak.audioData);
        }
        [selfWeak.avaudioRecorder deleteRecording];
        NSLog(@"录音完成");
    }];
    
   
    
    
    
    
    
}//录音完成

#pragma mark - AVAudioPlayer  Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放完成");
    
}//播放器完成

- (void)palyMp3WithNSSting:(NSString *)meidaStr isLocality:(BOOL )isLocality {
    if (isLocality) {
        
    }else {
        
        
        
        //        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        //
        //        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        NSURL * url = [[NSURL alloc] initWithString:[meidaStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]]];
        //        NSData * data = [[NSData alloc] initWithContentsOfURL:url];
        //        self.player = [[AVAudioPlayer alloc] initWithData:data  error:nil];
        //        self.player.delegate = self;
        //
        //        self.avPlayer =  [[AVPlayer alloc] initWithURL:url];
        //        self.avPlayer.volume = 0.2;
        //        AVPlayerLayer * jj = nil;
        //        [self.avPlayer play];
        //        NSError * error;
        //        [[AVAudioSession sharedInstance] overrideOutputAudioPort:(AVAudioSessionPortOverrideSpeaker) error:&error];
        //        NSLog(@"error===== %@",error);
        //
        //        self.player.numberOfLoops = -1;
        //        self.player.volume = 0.2;
        //        [self.player prepareToPlay];
        //        [self.player play];
        
        
        AVURLAsset *movieAsset    = [[AVURLAsset alloc]initWithURL:url options:nil];
        self.mp3PlayerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        [self.mp3PlayerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
        self.avPlayer = [AVPlayer playerWithPlayerItem:self.mp3PlayerItem];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        self.avPlayer.volume = 0.2;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        [self.avPlayer setAllowsExternalPlayback:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError * error;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        
        
        
        
        
    }
    
    
}

- (void)playbackFinished:(NSNotification *)notice {
    //    BASE_INFO_FUN(@"播放完成");
    [self.avPlayer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"])
    {
        if (AVPlayerItemStatusReadyToPlay == self.avPlayer.currentItem.status)
        {
            [self.avPlayer pause];
            self.isPlayingMap3 = NO;
        }
    }
}

- (void)setSoundValue:(CGFloat)soundValue {
    self.avPlayer.volume = [NSString stringWithFormat:@"%0.1f",soundValue].floatValue;
    
}

- (void)pauaseMp3 {
    [self.avPlayer pause];
    self.isPlayingMap3 = NO;
}

- (void)palyMp3 {
    if (self.avPlayer != nil && self.isPlayingMap3 == NO) {
        [self.avPlayer play];
        self.isPlayingMap3 = YES;
    }
}

- (void)stopMp3 {
    if (self.avPlayer != nil) {
        [self.avPlayer pause];
        self.avPlayer = nil;
        self.isPlayingMap3 = NO;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

- (void)stopAll {
    if (self.avPlayer != nil) {
        [self.avPlayer pause];
        self.avPlayer = nil;
        self.isPlayingMap3 = NO;
    }
    if (self.avaudioPlayer != nil ) {
        [self.avaudioPlayer stop];
        [self.avaudioRecorder deleteRecording];
        [self delectPath];
        
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}


@end
