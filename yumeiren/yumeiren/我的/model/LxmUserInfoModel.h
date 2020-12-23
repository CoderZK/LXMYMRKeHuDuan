//
//  LxmUserInfoModel.h
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmUserShopInfoModel : NSObject<NSCoding>

@property (nonatomic , strong) NSString *addressDetail;//姓名

@property (nonatomic , strong) NSString *city;//姓别

@property (nonatomic , strong) NSString *id;//姓别

@property (nonatomic , strong) NSString *district;//头像

@property (nonatomic , strong) NSString *latitude;//姓别

@property (nonatomic , strong) NSString *longitude;//头像

@property (nonatomic , strong) NSString *province;//姓别

@property (nonatomic , strong) NSString *telephone;//头像

@property (nonatomic , strong) NSString *showName;//姓别

@end


@interface LxmUserInfoModel : NSObject<NSCoding>
@property (nonatomic , strong) NSString *top_name;//上级的名字
@property (nonatomic , strong) NSString *username;//姓名

@property (nonatomic , strong) NSString *sex;//姓别
@property (nonatomic , strong) NSString *suType; // 是否操作过束宣   
@property (nonatomic , strong) NSString *userHead;//头像

@property (nonatomic , strong) NSString *chatCode;//微信号

@property (nonatomic , strong) NSString *cashRate;//提现手续费

@property (nonatomic , strong) NSString *authorPic;//授权图片

@property (nonatomic , strong) NSString *deposit;// 保证金

@property (nonatomic , strong) NSString *realName;// 真实姓名 用于判断是否已经实名认证

@property (nonatomic , strong) NSString *telephone;//手机号

@property (nonatomic , strong) NSString *recoCode;// 授权码

@property (nonatomic , strong) NSString *roleType;// -1:无 0：vip门店，1：高级门店，2：市服务商，3：省服务商，4：CEO

@property (nonatomic , strong) NSString *balance;// 余额

@property (nonatomic , strong) NSString *redBalance;// 红包余额

@property (nonatomic , strong) NSString *id;// 用户id

@property (nonatomic , strong) NSString *cashMoney;// 提现最低金额

@property (nonatomic , strong) NSString *inMoney;// 销售收入
@property (nonatomic , strong) NSString *sendScore;// 积分
@property (nonatomic , strong) NSString *my_score; //小溪
@property (nonatomic , strong) NSString *shopStatus;// 0:未付保证金，1：已付保证金，2：已填信息,4：申请省级中，5：后台通过省长审核待升级 6-可以购买， 7-不可以购买，需要先升级

@property (nonatomic, strong) NSString *chatStatus;//1:未绑定，2-已绑定

@property (nonatomic, strong) NSString *sendStatus;//0:推送关，1:推送开

@property (nonatomic, strong) NSString *depositMoney;//0:不需要补齐保证金，1:需要补齐保证金

@property (nonatomic , strong) NSString *province;//省

@property (nonatomic , strong) NSString *city;//市

@property (nonatomic , strong) NSString *district;//区

@property (nonatomic , strong) NSString *lowMoney;//最低金额要求

@property (nonatomic , strong) NSString *postMoney;//邮费

@property (nonatomic , strong) NSString *upPayMoney;//升级最低金额要求

@property (nonatomic , strong) NSString *serviceName;//客服微信号

@property (nonatomic , strong) NSString *thirdStatus;//1-已同意，2-未同意

@property (nonatomic , strong) NSString *idCode;//身份证号

@property (nonatomic , strong) NSString *direct_score;//直属小煜

@property (nonatomic , strong) NSString *group_score;//团队待转小煜

@property (nonatomic , strong) NSString *top_status;//1-顶头的，2-不是顶头的

@property (nonatomic , strong) NSString *topStatus;//1-顶头的，2-不是顶头的

@property (nonatomic , strong) NSString *rank;//排名 如果返回-1，就不显示同级别排名



@property (nonatomic , strong) LxmUserShopInfoModel *shopInfo;//

@end

NS_ASSUME_NONNULL_END
