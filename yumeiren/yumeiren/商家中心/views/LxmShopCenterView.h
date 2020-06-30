//
//  LxmShopCenterView.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmShopCenterView : UIView

@end

@interface LxmShopCenterTopView : UIControl

@property (nonatomic, strong) UILabel *nameLabel;//商家名称

@property (nonatomic, strong) UILabel *detailLabel;//手机号 推荐人

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@property (nonatomic, strong) UIImageView *sexImgView;//性别

@property (nonatomic, strong) UIButton *roleButton;//角色

@property (nonatomic, strong) LxmUserInfoModel *infoModel;

@property (nonatomic, strong) LxmShopCenterUserInfoModel *shopInfoModel;/* 商家个人中心 */

@property (nonatomic, copy) void(^likeshengjiBlock)(void);

@end


@interface LxmShopCenterKaoHeCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterUserInfoModel *shopInfoModel;/* 商家个人中心 */

@property (nonatomic, strong) NSMutableArray <LxmShopCenterUserListModel *>*dataArr;

@end

@interface LxmShopCenterItemCell : UITableViewCell

@property (nonatomic, strong) LxmShopCenterUserInfoModel *shopInfoModel;/* 商家个人中心 */

@property (nonatomic, copy) void(^selectItemBlock)(NSInteger index);

@end

//年度考核view
@interface LxmNianDuKaoHeHeaderView : UIView

@property (nonatomic, strong) LxmNianDuKaoHeModel *model;

@end
