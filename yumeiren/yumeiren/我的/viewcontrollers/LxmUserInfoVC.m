//
//  LxmUserInfoVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/22.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmUserInfoVC.h"
#import "LxmJieDanPublishVC.h"
#import "LxmUserInfoView.h"
#import "LxmMyAddressVC.h"
#import "LxmShengJiVC.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "LxmBandPhoneVC.h"

#import "LxmSearchVC.h"

@interface LxmUserInfoVC ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) LxmUserHeaderImgView *headerImgView;//头像

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *nameCell;//姓名

@property (nonatomic, strong) LxmJieDanPublishSelectedCell *sexCell;//姓别

@property (nonatomic, strong) LxmUserCodeCell *wechatCell;//微信号

@property (nonatomic, strong) LxmJieDanPublishSelectedCell *shdzCell;//收货地址

@property (nonatomic, strong) LxmUserCodeCell *phoneCell;//手机号

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *yhdjCell;//用户等级

@property (nonatomic, strong) LxmUserCodeCell *wdtjmCell;//我的授权码

@property (nonatomic, strong) LxmJieDanPublishTextFieldCell *sqzsCell;//授权证书


@end

@implementation LxmUserInfoVC

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (LxmUserHeaderImgView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [LxmUserHeaderImgView new];
    }
    return _headerImgView;
}

- (LxmJieDanPublishTextFieldCell *)nameCell {
    if (!_nameCell) {
        _nameCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _nameCell.titleLabel.text = @"姓名";
        _nameCell.textField.textColor = CharacterDarkColor;
        _nameCell.textField.userInteractionEnabled = NO;
    }
    return _nameCell;
}

- (LxmJieDanPublishSelectedCell *)sexCell {
    if (!_sexCell) {
        _sexCell = [[LxmJieDanPublishSelectedCell alloc] init];
        _sexCell.titleLabel.text = @"姓别";
        [_sexCell addTarget:self action:@selector(changeSex) forControlEvents:UIControlEventTouchUpInside];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [_sexCell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(_sexCell);
            make.height.equalTo(@0.5);
        }];
    }
    return _sexCell;
}

- (LxmUserCodeCell *)wechatCell {
    if (!_wechatCell) {
        _wechatCell = [[LxmUserCodeCell alloc] init];
        _wechatCell.titleLabel.text = @"微信";
    }
    return _wechatCell;
}

- (LxmUserCodeCell *)phoneCell {
    if (!_phoneCell) {
        _phoneCell = [[LxmUserCodeCell alloc] init];
        _phoneCell.titleLabel.text = @"手机号码";
    }
    return _phoneCell;
}

- (LxmJieDanPublishSelectedCell *)shdzCell {
    if (!_shdzCell) {
        _shdzCell = [[LxmJieDanPublishSelectedCell alloc] init];
        _shdzCell.titleLabel.text = @"收货地址";
        [_shdzCell addTarget:self action:@selector(addressClick) forControlEvents:UIControlEventTouchUpInside];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [_shdzCell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(_shdzCell);
            make.height.equalTo(@0.5);
        }];
    }
    return _shdzCell;
}

- (LxmJieDanPublishTextFieldCell *)yhdjCell {
    if (!_yhdjCell) {
        _yhdjCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _yhdjCell.titleLabel.text = @"用户等级";
        _yhdjCell.textField.textColor = CharacterDarkColor;
        _yhdjCell.textField.userInteractionEnabled = NO;
    }
    return _yhdjCell;
}

- (LxmUserCodeCell *)wdtjmCell {
    if (!_wdtjmCell) {
        _wdtjmCell = [[LxmUserCodeCell alloc] init];
        _wdtjmCell.titleLabel.text = @"我的授权码";
    }
    return _wdtjmCell;
}

- (LxmJieDanPublishTextFieldCell *)sqzsCell {
    if (!_sqzsCell) {
        _sqzsCell = [[LxmJieDanPublishTextFieldCell alloc] init];
        _sqzsCell.titleLabel.text = @"授权证书";
        _sqzsCell.textField.userInteractionEnabled = NO;
        _sqzsCell.hidden = YES;
    }
    return _sqzsCell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_headerImgView.iconImgView sd_setImageWithURL:[NSURL URLWithString:[LxmTool ShareTool].userModel.userHead] placeholderImage:[UIImage imageNamed:@"moren"]];
    _nameCell.textField.text = [LxmTool ShareTool].userModel.username;
    _phoneCell.detailLabel.text = [LxmTool ShareTool].userModel.telephone;
    _wdtjmCell.detailLabel.text = [LxmTool ShareTool].userModel.recoCode;
    _wechatCell.detailLabel.text = [LxmTool ShareTool].userModel.chatStatus.intValue == 1 ? @"未绑定" : @"已绑定";
    _sexCell.subTitleLabel.text = [LxmTool ShareTool].userModel.sex.intValue == 0 ? @"未知" : [LxmTool ShareTool].userModel.sex.intValue == 1 ? @"男" : @"女";
    [_wechatCell addTarget:self action:@selector(wechatClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView reloadData];
    if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"-0.5"]) {
        _yhdjCell.textField.text = @"减肥单项-vip会员";
    } else if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"-0.5"]) {
        _yhdjCell.textField.text = @"减肥单项-高级会员";
    } else if ([[LxmTool ShareTool].userModel.roleType isEqualToString:@"-0.5"]) {
        _yhdjCell.textField.text = @"减肥单项-荣誉会员";
    } else {
        switch ([LxmTool ShareTool].userModel.roleType.intValue) {
            case 0: {
                [self.yhdjCell addTarget:self action:@selector(shengjirightnow) forControlEvents:UIControlEventTouchUpInside];
                 _yhdjCell.textField.text = @"立刻升级";
            }
                break;
            case 1:
                _yhdjCell.textField.text = @"县代";
                break;
            case 2:
                _yhdjCell.textField.text = @"市代";
                break;
            case 3:
                _yhdjCell.textField.text = @"省代";
                break;
            case 4:
                _yhdjCell.textField.text = @"CEO";
                break;
                
            default:
                break;
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    [self initSubviews];
    [self setConstrains];
    self.contentView.frame = CGRectMake(0, 0, ScreenW, 50 * 8 + 20 + 100);
    self.tableView.tableHeaderView = self.contentView;
    [self.headerImgView addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
}

/**
 添加视图
 */
- (void)initSubviews {
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.nameCell];
    [self.contentView addSubview:self.sexCell];
    [self.contentView addSubview:self.wechatCell];
    [self.contentView addSubview:self.shdzCell];
    [self.contentView addSubview:self.phoneCell];
    [self.contentView addSubview:self.yhdjCell];
    [self.contentView addSubview:self.wdtjmCell];
    [self.contentView addSubview:self.sqzsCell];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@100);
    }];
    [self.nameCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.sexCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.wechatCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.shdzCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wechatCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.phoneCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shdzCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.yhdjCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.wdtjmCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yhdjCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.sqzsCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wdtjmCell.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
}
/**
 修改头像
 */
- (void)modify {
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:@"选择图片上传方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            if (image) {
                self.headerImgView.iconImgView.image = image;
                [self upLoadFile:image];
            }else {
                [SVProgressHUD showErrorWithStatus:@"相片获取失败"];
            }
        }];
    }];
    
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoPickerControllerAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            if (image) {
                [self upLoadFile:image];
            }else {
                [SVProgressHUD showErrorWithStatus:@"相片获取失败"];
            }
        }];
    }];
    UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [actionController addAction:a3];
    [self presentViewController:actionController animated:YES completion:nil];
}

/**
 上传图片
 */
- (void)upLoadFile:(UIImage *)image {
    [SVProgressHUD show];
    [LxmNetworking NetWorkingUpLoad:up_user_head image:image parameters:@{@"token" : SESSION_TOKEN} name:@"file" success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"头像已更新!"];
            self.headerImgView.iconImgView.image = image;
            [self loadMyUserInfoWithOkBlock:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 选择收货地址
 */
- (void)addressClick {
    LxmMyAddressVC *vc = [[LxmMyAddressVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 立刻升级
 */
- (void)shengjirightnow {
    LxmShengJiVC *vc = [[LxmShengJiVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 绑定微信
 */
- (void)wechatClick {
    //chatStatus 1:未绑定，2-已绑定
    if ([LxmTool ShareTool].userModel.chatStatus.intValue == 1) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            UMSocialUserInfoResponse *resp = result;
            // 第三方登录数据(为空表示平台未提供)
            // 授权数据
            NSLog(@" uid: %@", resp.uid);
            NSLog(@" openid: %@", resp.openid);
            NSLog(@" accessToken: %@", resp.accessToken);
            NSLog(@" refreshToken: %@", resp.refreshToken);
            NSLog(@" expiration: %@", resp.expiration);
            
            // 用户数据
            NSLog(@" name: %@", resp.name);
            NSLog(@" iconurl: %@", resp.iconurl);
            NSLog(@" gender: %@", resp.unionGender);
            
            // 第三方平台SDK原始数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
            if (!error) {
                [self bandWiexin:resp];
            }
        }];
    } else {//解绑微信
        [self loseBindChat];
    }
}

/**
 绑定微信
 */
- (void)bandWiexin:(UMSocialUserInfoResponse *)resp {
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"openId"] = resp.openid;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:bind_chat parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"已绑定"];
            _wechatCell.detailLabel.text = @"已绑定" ;
            [selfWeak loadMyUserInfoWithOkBlock:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 改变性别
 */
- (void)changeSex {
    //选择性别
    WeakObj(self);
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak updateUserInfo:@1];
        
    }];
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak updateUserInfo:@2];
        
    }];
    UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [actionController addAction:a3];
    [self presentViewController:actionController animated:YES completion:nil];
}

/**
 修改个人信息
 */
- (void)updateUserInfo:(NSNumber *)num {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:up_base_info parameters:@{@"token":SESSION_TOKEN,@"sex":num} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"性别已更新!"];
            selfWeak.sexCell.subTitleLabel.text = num.integerValue == 1 ? @"男" : @"女";
            [selfWeak loadMyUserInfoWithOkBlock:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 解绑微信
 */
- (void)loseBindChat {
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:lose_bind_chat parameters:@{@"token":SESSION_TOKEN} returnClass:LxmBaseModel.class success:^(NSURLSessionDataTask *task, LxmBaseModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [SVProgressHUD showSuccessWithStatus:@"未绑定"];
            _wechatCell.detailLabel.text = @"未绑定" ;
            [selfWeak loadMyUserInfoWithOkBlock:nil];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end


