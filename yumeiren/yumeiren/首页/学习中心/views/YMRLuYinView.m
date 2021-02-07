//
//  YMRLuYinView.m
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRLuYinView.h"

@interface YMRLuYinView()


@property (nonatomic, assign) NSInteger timeNumer;

@end


@implementation YMRLuYinView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.whiteViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
        self.whiteViewOne.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteViewOne];
        
        UIView * vone = [[UIView alloc] initWithFrame:CGRectMake(15, 15, ScreenW - 30, 70)];
        vone.layer.borderWidth = 0.8;
        vone.layer.borderColor = CharacterGrayColor.CGColor;
        vone.layer.cornerRadius = 5;
        vone.clipsToBounds = YES;
        [self.whiteViewOne addSubview:vone];
        
        UIButton * playBt = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        [playBt setImage:[UIImage imageNamed:@"neiPlay"] forState:UIControlStateNormal];
        [vone addSubview:playBt];
        [playBt addTarget:self action:@selector(playMP3Action:) forControlEvents:UIControlEventTouchUpInside];
        
        self.playBt = playBt;
        self.playListBt = [[UIButton alloc] init];
        [vone addSubview:self.playListBt];
        [self.playListBt setImage:[UIImage imageNamed:@"playList"] forState:UIControlStateNormal];
        [self.playListBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playBt);
            make.height.width.equalTo(@30);
            make.right.equalTo(vone).offset(-15);
        }];
        
        self.playBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.playListBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.nameLB = [[UILabel alloc] init];
        [self.whiteViewOne addSubview:self.nameLB];
        self.nameLB.font = [UIFont systemFontOfSize:12];
        self.nameLB.text = @"歌名";
        [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playBt);
            make.left.equalTo(self.playBt.mas_right).offset(0);
            make.right.equalTo(self.playListBt.mas_left).offset(0);
            
        }];
        
        UIButton * soundBt = [[UIButton alloc] initWithFrame:CGRectMake(15, 70-35, 30, 30)];
        [soundBt setImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
        [vone addSubview:soundBt];
        soundBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
  
        
         
        
        self.LB = [[UILabel alloc] init];
        self.LB.font = [UIFont systemFontOfSize:12];
        self.LB.textColor = CharacterGrayColor;
        self.LB.text = @"20%";
        self.LB.textAlignment = NSTextAlignmentRight;
        [vone addSubview:self.LB];
        [self.LB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(soundBt);
            make.width.mas_greaterThanOrEqualTo(@30);
            make.right.equalTo(vone).offset(-15);
        }];
        
//        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 10, ScreenW - 60 - 50- 15, 20)];
        UISlider *slider = [[UISlider alloc] init];
        self.slider = slider;
        /// 添加Slider
        [vone addSubview:slider];
        
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLB.mas_left);
            make.centerY.equalTo(soundBt);
            make.right.equalTo(self.LB.mas_left).offset(-5);
        }];
        
        /// 属性配置
        // minimumValue  : 当值可以改变时，滑块可以滑动到最小位置的值，默认为0.0
        slider.minimumValue = 0.0;
        // maximumValue : 当值可以改变时，滑块可以滑动到最大位置的值，默认为1.0
        slider.maximumValue = 1.0;
        // 当前值，这个值是介于滑块的最大值和最小值之间的，如果没有设置边界值，默认为0-1；
        slider.value = 0.2;
        
        // continuous : 如果设置YES，在拖动滑块的任何时候，滑块的值都会改变。默认设置为YES
        [slider setContinuous:YES];

        // minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
        slider.minimumTrackTintColor = RGB(234, 104, 118);
        // maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
        slider.maximumTrackTintColor = CharacterLightGrayColor;
        // thumbTintColor : 当前滑块的颜色，默认为白色
        slider.thumbTintColor = CharacterLightGrayColor ;
        
        UIImage *imagea=[self OriginImage:[UIImage imageNamed:@"lvdian"] scaleToSize:CGSizeMake(12, 12)];
        [slider  setThumbImage:imagea forState:UIControlStateNormal];
         [self.slider addTarget:self action:@selector(sliderValChanged) forControlEvents:UIControlEventValueChanged];
        
        
        self.whiteViewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.whiteViewOne.frame), ScreenW, 130)];
        self.whiteViewTwo.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteViewTwo];
        
        self.luYinBt = [[UIButton alloc] init];
        [self.luYinBt setBackgroundImage:[UIImage imageNamed:@"luyin"] forState:UIControlStateNormal];
        [self.whiteViewTwo addSubview:self.luYinBt];
        [self.luYinBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.whiteViewTwo);
            make.height.width.equalTo(@80);
            make.top.equalTo(self.whiteViewTwo).offset(20);
        }];
        self.luYinBt.tag = 102;
        [self.luYinBt addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        self.timeLB = [[UILabel alloc] init];
        self.timeLB.font = [UIFont systemFontOfSize:10];
        self.timeLB.textColor = CharacterDarkColor;
        self.timeLB.text = @"开始跟读";
        [self.whiteViewTwo addSubview:self.timeLB];
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.luYinBt).offset(5);
            make.top.equalTo(self.luYinBt.mas_bottom).offset(5);
        }];
        self.redV = [[UIView alloc] init];
        self.redV.layer.cornerRadius = 2;
        self.redV.clipsToBounds = YES;
        self.redV.backgroundColor = RGB(234, 104, 118);
        [self.whiteViewTwo addSubview:self.redV];
        [self.redV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@4);
            make.centerY.equalTo(self.timeLB);
            make.right.equalTo(self.timeLB.mas_left).offset(-6);
        }];
        
        CGFloat ww = 26;
        CGFloat spce = (ScreenW - 80 - ww * 4)/6;
        
        self.shiTingBt = [[UIButton alloc] init];
        [self.shiTingBt setBackgroundImage:[UIImage imageNamed:@"shiting"] forState:UIControlStateNormal];
        [self.whiteViewTwo addSubview:self.shiTingBt];
        self.shiTingBt.tag = 101;
        [self.shiTingBt addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.shiTingBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@26);
            make.centerY.equalTo(self.luYinBt);
            make.right.equalTo(self.luYinBt.mas_left).offset(-spce);
        }];
        UILabel *lb1 = [[UILabel alloc] init];
        lb1.font = [UIFont systemFontOfSize:12];
        lb1.textColor = CharacterDarkColor;
        lb1.text = @"试听";
        [self.whiteViewTwo addSubview:lb1];
        [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.shiTingBt);
            make.top.equalTo(self.shiTingBt.mas_bottom);
        }];
        
        
        self.musicBt = [[UIButton alloc] init];
        [self.musicBt setBackgroundImage:[UIImage imageNamed:@"peiyue"] forState:UIControlStateNormal];
        [self.whiteViewTwo addSubview:self.musicBt];
        self.musicBt.tag = 100;
        [self.musicBt addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.musicBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@26);
            make.centerY.equalTo(self.luYinBt);
            make.right.equalTo(self.shiTingBt.mas_left).offset(-spce);
        }];
        UILabel *lb2 = [[UILabel alloc] init];
        lb2.font = [UIFont systemFontOfSize:12];
        lb2.textColor = CharacterDarkColor;
        lb2.text = @"配乐";
        [self.whiteViewTwo addSubview:lb2];
        [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.musicBt);
            make.top.equalTo(self.musicBt.mas_bottom);
        }];
        
        self.chongduBt = [[UIButton alloc] init];
        [self.chongduBt setBackgroundImage:[UIImage imageNamed:@"chongxin"] forState:UIControlStateNormal];
        [self.whiteViewTwo addSubview:self.chongduBt];
        self.chongduBt.tag = 103;
        [self.chongduBt addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.chongduBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@26);
            make.centerY.equalTo(self.luYinBt);
            make.left.equalTo(self.luYinBt.mas_right).offset(spce);
        }];
        UILabel *lb3 = [[UILabel alloc] init];
        lb3.font = [UIFont systemFontOfSize:12];
        lb3.textColor = CharacterDarkColor;
        lb3.text = @"重读";
        [self.whiteViewTwo addSubview:lb3];
        [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.chongduBt);
            make.top.equalTo(self.chongduBt.mas_bottom);
        }];
        
        
        self.saveBt = [[UIButton alloc] init];
        [self.saveBt setBackgroundImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
        [self.whiteViewTwo addSubview:self.saveBt];
        self.saveBt.tag = 104;
        [self.saveBt addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [self.saveBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@26);
            make.centerY.equalTo(self.luYinBt);
            make.left.equalTo(self.chongduBt.mas_right).offset(spce);
        }];
        UILabel *lb4 = [[UILabel alloc] init];
        lb4.font = [UIFont systemFontOfSize:12];
        lb4.textColor = CharacterDarkColor;
        lb4.text = @"保存";
        [self.whiteViewTwo addSubview:lb4];
        [lb4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.saveBt);
            make.top.equalTo(self.saveBt.mas_bottom);
        }];
        
        self.whiteViewOne.hidden = YES;
        
        
    }
    return self;
}

- (void)playMP3Action:(UIButton *)button {
    
//    if (![[ALCAudioTool shareTool].avaudioRecorder isRecording]) {
//        [SVProgressHUD showErrorWithStatus:@"请先开启录音"];
//        return;
//    }
    
    if ([button.currentImage isEqual:[UIImage imageNamed:@"zantingnei"]]) {
        [[ALCAudioTool shareTool] pauaseMp3];
        [self.playBt setImage:[UIImage imageNamed:@"neiPlay"] forState:UIControlStateNormal];
    }else {
        [[ALCAudioTool shareTool] palyMp3];
        [self.playBt setImage:[UIImage imageNamed:@"zantingnei"] forState:UIControlStateNormal];
    }
}

- (void)setShowViewOne:(BOOL)showViewOne {
    _showViewOne = showViewOne;
    self.whiteViewOne.hidden = !showViewOne;
//    [self.playBt setImage:[UIImage imageNamed:@"zantingnei"] forState:UIControlStateNormal];
}

- (void)sliderValChanged {
    
    self.LB.text = [NSString stringWithFormat:@"%0.0f%%",self.slider.value*100];
    [ALCAudioTool shareTool].soundValue = self.slider.value;
}


-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (void)action:(UIButton *)button {
    
    if (button.tag == 100) {
        if (self.clickButtonBlock != nil) {
            self.clickButtonBlock(button.tag);
        }
    }else if (button.tag == 101) {
        //试听
        [[ALCAudioTool shareTool] pauaseRecord];
        [[ALCAudioTool shareTool] playRecord];
        [[ALCAudioTool shareTool] pauaseMp3];
        [self.luYinBt setBackgroundImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
        [self.playBt setImage:[UIImage imageNamed:@"neiPlay"] forState:UIControlStateNormal];
        
    }else if (button.tag == 102) {
        AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession respondsToSelector:@selector(requestRecordPermission:)];
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {}];
            return;
        }
        
        if (![[ALCAudioTool shareTool] checkMicrophonePermission]) {
            [[ALCAudioTool shareTool] popUpMicrophonePermissionAlertView];
            return;
        }
        if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"luyin"]] || [button.currentBackgroundImage isEqual:[UIImage imageNamed:@"zanting"]]) {
            // 开始录音
            [[ALCAudioTool shareTool] startRecord];
            WeakObj(self);
            [[ALCAudioTool shareTool] setAveragePowerBlock:^(CGFloat averagePower, NSInteger timeNumber) {
                selfWeak.timeLB.text = [NSString stringWithFormat:@"正在跟读%02ld:%02ld",timeNumber/60,timeNumber%60];
                selfWeak.timeNumer = timeNumber;
            }];
            
            [button setBackgroundImage:[UIImage imageNamed:@"luyinzhong"] forState:UIControlStateNormal];
        }else if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"luyinzhong"]]) {
            // 暂停录音
            [[ALCAudioTool shareTool] pauaseRecord];
            [[ALCAudioTool shareTool] pauaseMp3];
            [self.playBt setImage:[UIImage imageNamed:@"neiPlay"] forState:UIControlStateNormal];
            [self.luYinBt setBackgroundImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
        }
        
    }else if (button.tag == 103) {
        
        [[ALCAudioTool shareTool] reStartRecord];
        [[ALCAudioTool shareTool] stopMp3];
        [self.luYinBt setBackgroundImage:[UIImage imageNamed:@"luyinzhong"] forState:UIControlStateNormal];
        self.showViewOne = NO;
        [self.playBt setImage:[UIImage imageNamed:@"neiPlay"] forState:UIControlStateNormal];
    } else if (button.tag == 104){
        
        if (self.timeNumer <= 0) {
            [SVProgressHUD showErrorWithStatus:@"无录音"];
            return;
        }
        WeakObj(self);
        // 保存
        [[ALCAudioTool shareTool] stopRecord];
        
        [[ALCAudioTool shareTool] setStatusBlock:^(BOOL isFinsh, NSData * _Nonnull mediaData) {
            if (selfWeak.sendDataBlock != nil) {
                self.sendDataBlock(selfWeak.timeNumer, mediaData);
            }
        }];
        
        
       
    }

}

@end
