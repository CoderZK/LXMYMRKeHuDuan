//
//  ALCAudioTool.h
//  AnLanBB
//
//  Created by zk on 2020/4/1.
//  Copyright © 2020 kunzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface ALCAudioTool : NSObject

+ (ALCAudioTool *)shareTool;
- (void)stopRecord;
- (void)pauaseRecord;
- (void)startRecord;
- (void)reStartRecord;
- (void)playRecord;
- (void)stopPlayRecord;
- (BOOL)isHavedata;
- (void)stopAll;
//本地音频播放
@property (nonatomic,strong) AVAudioPlayer *avaudioPlayer;
@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,assign)NSInteger timeNumber;
//音频录制
@property (nonatomic,strong) AVAudioRecorder *avaudioRecorder;

- (BOOL)checkMicrophonePermission;//判断是否开启录音
- (void)popUpMicrophonePermissionAlertView;//提示开启录音

@property(nonatomic,copy)void(^statusBlock)(BOOL isFinsh ,NSData * mediaData);
@property(nonatomic,copy)void(^averagePowerBlock)(CGFloat averagePower,NSInteger timeNumber);

- (void)palyMp3WithNSSting:(NSString *)meidaStr isLocality:(BOOL )isLocality;
@property (nonatomic, assign) CGFloat soundValue;
- (void)pauaseMp3;
- (void)palyMp3;
- (void)stopMp3;
- (void)delectPath;
@property(nonatomic,assign)BOOL isRecoreder;

@end

NS_ASSUME_NONNULL_END
