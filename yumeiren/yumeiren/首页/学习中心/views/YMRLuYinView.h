//
//  YMRLuYinView.h
//  yumeiren
//
//  Created by zk on 2021/2/2.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMRLuYinView : UIView
@property(nonatomic,strong)UIView *whiteViewOne,*whiteViewTwo;
@property(nonatomic,strong)UIButton *playBt,*playListBt;
@property(nonatomic,strong)UILabel * LB,*timeLB,*nameLB;
@property(nonatomic,strong)UIView * redV;
@property(nonatomic,strong)UISlider *slider;
@property(nonatomic,strong)UIButton *musicBt,*shiTingBt,*luYinBt,*chongduBt,*saveBt;

@property(nonatomic,copy)void(^clickButtonBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
