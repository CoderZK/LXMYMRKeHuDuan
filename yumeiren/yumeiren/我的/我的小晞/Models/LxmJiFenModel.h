//
//  LxmJiFenModel.h
//  yumeiren
//
//  Created by zk on 2020/7/8.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmJiFenModel : NSObject
@property (nonatomic , strong) NSString *score;// 小晞

@property (nonatomic , strong) NSString *status;//1：审核中，2：审核成功，3：审核失败

@property (nonatomic , strong) NSString *score_type;//1：直属小晞，2：团队返利小晞

@property (nonatomic , strong) NSString *second_type;//1：返利获得直属转入，2：直属转给上级，3：下级转入直属,4：提现转出直属，5：获得团队返利，6：下级转入返利，7：转给上级返利，8：提现转出返利
@property (nonatomic , strong) NSString *create_time;//创建时间
@property (nonatomic , strong) NSString *info_type;//提现类型：1-银行卡，2-支付宝
@property (nonatomic , strong) NSString *zhi_name;//提现：支付宝姓名
@property (nonatomic , strong) NSString *zhi_account;//提现：支付宝账户
@property (nonatomic , strong) NSString *by_name;//转入或者转出的代理姓名  或者  直属返利的代理姓名
@property (nonatomic , strong) NSString *sale_money;//销售业绩
@property (nonatomic , strong) NSString *sale_rate;//销售业绩公式 里面的：比例  或者 直属返单的比例
@property (nonatomic , strong) NSString *other_money;//销售业绩公式里面的：其他成员收益   或者是直属返利的订单金额
@property (nonatomic , strong) NSString *order_code;//直属返单类型的：订单流水号
@property(nonatomic,strong)NSString *bank_id;
@property(nonatomic,strong)NSString *userHead;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *bank_username;
@property(nonatomic,strong)NSString *bank_code;
@property(nonatomic,strong)NSString *order_id;

@property(nonatomic,assign)CGFloat inviteToBox;
@property(nonatomic,assign)CGFloat finishMoney;
@property(nonatomic,assign)CGFloat targetMoney;
@property(nonatomic,assign)CGFloat inviteUserNum;


@property(nonatomic,strong)NSString * other_info;
@property(nonatomic,strong)NSMutableArray<LxmJiFenModel *> *otherInfoList;


@property(nonatomic,strong)NSString *ID;

@end

NS_ASSUME_NONNULL_END



