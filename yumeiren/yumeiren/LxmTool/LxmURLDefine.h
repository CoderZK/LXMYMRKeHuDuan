//
//  LxmURLDefine.h
//  shenbian
//
//  Created by 李晓满 on 2018/11/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISLOGIN [LxmTool ShareTool].isLogin
#define TOKEN [LxmTool ShareTool].session_token




//测试
//#define Base_URL @"http://appnew.hkymr.com:8989"

//正式
#define Base_URL @"https://appnew.hkymr.com"




#define Base_RESOURSE_URL @"https://vedio.hkymr.com"
/**
 单张图片上传 或视频上传
 */
#define  Base_upload_img_URL  Base_URL"/app/seven_app_file_up"
/**
 多张图片上传
 */
#define  Base_upload_multi_img_URL  Base_URL"/app/multi_seven_app_file_up"


@interface LxmURLDefine : NSObject
/**
 上传推送token
 */
#define  umeng_id_up  Base_URL"/app/user/umeng_id_up"
/**
 绑定微信
 */
#define  bind_chat  Base_URL"/app/user/bind_chat"

/**
 发送验证码
 */
#define  app_identify  Base_URL"/app/app_identify"

/**
 注册¸
 */
#define  user_submit  Base_URL"/app/user_submit"
/**
 微信绑定已有账户
 */
#define  first_submit  Base_URL"/app/first_submit"

/**
 登录
 */
#define  app_login  Base_URL"/app/login"
/**
 重置密码
 */
#define  back_pass  Base_URL"/app/back_pass"

/**
 退出登录
 */
#define  app_logout  Base_URL"/app/app_logout"
/**
 发起投诉、继续投诉
 */
#define  send_complain  Base_URL"/app/user/send_complain"
/**
 我的投诉
 */
#define  complain_list  Base_URL"/app/user/complain_list"
/**
 投诉详情
 */
#define  complain_detail  Base_URL"/app/user/complain_detail"
/**
 商品大类列表
 */
#define  good_first_type_list  Base_URL"/app/good_first_type_list"
/**
 素材大类列表
 */
#define  judge_type_list  Base_URL"/app/judge_type_list"
/**
 发布素材
 */
#define  up_share  Base_URL"/app/user/up_share"
/**
 我发布的素材列表
 */
#define  user_good_judge_list  Base_URL"/app/user/good_judge_list"

/**
 素材列表 recommend 1-推荐，2：全部
 */
#define  good_judge_list  Base_URL"/app/good_judge_list"
/**
 删除素材
 */
#define  del_judge  Base_URL"/app/user/del_judge"

/**
 结束投诉
 */
#define close_complain  Base_URL"/app/user/close_complain"

/**
 服务类型列表
 */
#define service_type_list  Base_URL"/app/service_type_list"
/**
 发布订单
 */
#define send_service_order  Base_URL"/app/user/send_service_order"
/**
 我的订单
 */
#define service_list  Base_URL"/app/user/service_list"
/**
 加价
 */
#define pay_more  Base_URL"/app/user/pay_more"
/**
 接单大厅-订单列表
 */
#define wait_get_service_list  Base_URL"/app/user/wait_get_service_list"
/**
 申请退单
 */
#define back_service_order  Base_URL"/app/user/back_service_order"
/**
 撤单
 */
#define cancel_service_order  Base_URL"/app/user/cancel_service_order"
/**
 接单
 */
#define get_service_order  Base_URL"/app/user/get_service_order"
/**
 上传评价单
 */
#define judge_service_order  Base_URL"/app/user/judge_service_order"
/**
 评价打分
 */
#define score_service_order  Base_URL"/app/user/score_service_order"
/**
 审核退单
 */
#define verify_service_order  Base_URL"/app/user/verify_service_order"
/**
 订单详情
 */
#define order_detail  Base_URL"/app/user/order_detail"
/**
  个人中心信心
 */
#define my_info  Base_URL"/app/user/my_info"
/**
 修改个人信息
 */
#define up_base_info  Base_URL"/app/user/up_base_info"
/**
 首页数据
 */
#define get_index  Base_URL"/app/user/get_index"
/**
 商品列表
 */
#define group_good_list  Base_URL"/app/user/group_good_list"
/**
 商品详情
 */
#define good_detail  Base_URL"/app/user/good_detail"
/**
 修改头像
 */
#define up_user_head  Base_URL"/app/user/up_user_head"
/**
 添加修改收货地址
 */
#define add_up_address  Base_URL"/app/user/add_up_address"
/**
 收货地址列表
 */
#define address_list  Base_URL"/app/user/address_list"
/**
 删除收货地址
 */
#define del_address  Base_URL"/app/user/del_address"
/**
 热搜关键词
 */
#define hot_words  Base_URL"/app/user/hot_words"
/**
 银行列表
 */
#define dic_bank_list  Base_URL"/app/user/dic_bank_list"
/**
 添加银行卡
 */
#define add_bank  Base_URL"/app/user/add_bank"
/**
 银行卡列表
 */
#define bank_list  Base_URL"/app/user/bank_list"
/**
 删除银行卡
 */
#define del_bank  Base_URL"/app/user/del_bank"
/**
 提交提现申请
 */
#define up_cash_out  Base_URL"/app/user/up_cash_out"
/**
 提交充值申请
 */
#define up_recharge  Base_URL"/app/user/up_recharge"
/**
 余额转账
 */
#define give_money  Base_URL"/app/user/give_money"
/**
 查看升级状态和升级条件信息
 */
#define get_role_info  Base_URL"/app/user/get_role_info"
/**
 升级代理交保证金
 */
#define role_deposit_pay  Base_URL"/app/user/role_deposit_pay"
/**
 申请成为省服务商
 */
#define role_province  Base_URL"/app/user/role_province"
/**
 完善升级的地址信息
 */
#define role_address  Base_URL"/app/user/role_address"
/**
 红包余额变动记录
 */
#define red_balance_list  Base_URL"/app/user/red_balance_list"
/**
 红包余额转普通余额
 */
#define change_red  Base_URL"/app/user/change_red"
/**
 意见反馈
 */
#define feed_back  Base_URL"/app/user/feed_back"
/**
 实名认证
 */
#define do_real_info  Base_URL"/app/user/do_real_info"
/**
 加入购物车
 */
#define add_cart  Base_URL"/app/user/add_cart"
/**
 删除购物车
 */
#define del_cart  Base_URL"/app/user/del_cart"
/**
 购物车列表
 */
#define cart_list  Base_URL"/app/user/cart_list"
/**
 修改购物车
 */
#define up_cart  Base_URL"/app/user/up_cart"
/**
 购物车购进下单
 */
#define settle_cart_order  Base_URL"/app/user/settle_cart_order"
/**
 购进订单支付
 */
#define pay_order  Base_URL"/app/user/pay_order"
/**
 我的仓库
 */
#define stock_list  Base_URL"/app/user/stock_list"
/**
 仓库变动记录
 */
#define stock_change_list  Base_URL"/app/user/stock_change_list"
/**
 订单列表
 */
#define order_list  Base_URL"/app/user/order_list"
/**
 发货下单
 */
#define send_good_order  Base_URL"/app/user/send_good_order"
/**
 商铺个人中心信息
 */
#define shop_center  Base_URL"/app/user/shop_center"
/**
 订单详情
 */
#define good_order_detail  Base_URL"/app/user/good_order_detail"
/**
 确认收货
 */
#define confirm_send_order  Base_URL"/app/user/confirm_send_order"

/**
 我的业绩-汇总
 */
#define sale_count_total  Base_URL"/app/user/sale_count_total"

/**
 我的业绩
 */
#define sale_count_list  Base_URL"/app/user/sale_count_list"

/**
 我的团队-汇总
 */
#define group_count_total  Base_URL"/app/user/group_count_total"
/**
 我的团队
 */
#define group_count_list  Base_URL"/app/user/group_count_list"
/**
 查看他人信息
 */
#define other_infoTTT  Base_URL"/app/user/other_info"
/**
 我的仓库-汇总
 */
#define stock_count  Base_URL"/app/user/stock_count"
/**
 交易记录
 */
#define trial_list  Base_URL"/app/user/trial_list"
/**
 物流详情
 */
#define  way_detail  Base_URL"/app/user/way_detail"
/**
 消息首页
 */
#define  shop_notice_index  Base_URL"/app/user/shop_notice_index"
/**
 消息列表
 */
#define  shop_notice_list  Base_URL"/app/user/shop_notice_list"
/**
 查看消息-标记消息已读
 */
#define  look_notice  Base_URL"/app/user/look_notice"
/**
 补货订单列表
 */
#define  back_order_list  Base_URL"/app/user/back_order_list"
/**
 一键补货
 */
#define  do_back_order  Base_URL"/app/user/do_back_order"
/**
一键补货 新
*/
#define  good_stock_list  Base_URL"/app/user/good_stock_list"


/**
 支付补货订单
 */
#define  do_pay_back_order  Base_URL"/app/user/do_pay_back_order"
/**
 获取全部待补货订单列表
 */
#define  get_all_wait_back  Base_URL"/app/user/get_all_wait_back"
/**
 补货订单详情
 */
#define  good_order_detail  Base_URL"/app/user/good_order_detail"
/**
 申请退单
 */
#define  return_send_order  Base_URL"/app/user/return_send_order"
/**
 申请退货
 */
#define  return_buy_order  Base_URL"/app/user/return_buy_order"
/**
 补货单申请退单
 */
#define  return_bu_order  Base_URL"/app/user/return_bu_order"
/**
 删除已过期订单
 */
#define  log_del_order  Base_URL"/app/user/log_del_order"
/**
 补交保证金
 */
#define  more_deposit  Base_URL"/app/user/more_deposit"
/**
 发单平台 我发布的支付
 */
#define  pay_service_order  Base_URL"/app/user/pay_service_order"
/**
 保证金变动记录
 */
#define  deposit_change_list  Base_URL"/app/user/deposit_change_list"
/**
 统计下载图片视频文字的次数
 */
#define  count_down_num  Base_URL"/app/count_down_num"
/**
 获取钱包信息
 */
#define  balance_info  Base_URL"/app/user/balance_info"
/**
 获取服务列表
 */
#define  service_city_list  Base_URL"/app/user/service_city_list"
/**
 获取省列表
 */
#define  get_province  Base_URL"/app/user/get_province"
/**
 获取市列表
 */
#define  get_city  Base_URL"/app/user/get_city"

/**
 获取县列表
 */
#define  get_district  Base_URL"/app/user/get_district"
/**
 解绑微信
 */
#define  lose_bind_chat  Base_URL"/app/user/lose_bind_chat"
/**
 取消申请代理
 */
#define  cancel_role_up  Base_URL"/app/user/cancel_role_up"
/**
 取消申请
 */
#define  cancel_finish_message  Base_URL"/app/user/cancel_finish_message"
/**
 查询附近店铺
 */
#define  select_store  Base_URL"/app/user/select_store"
/**
 确认浏览过协议
 */
#define  up_agree  Base_URL"/app/user/up_agree"
/**
 提现详情
 */
#define  money_out_detail  Base_URL"/app/user/money_out_detail"
/**
 充值详情
 */
#define  money_in_detail  Base_URL"/app/user/money_in_detail"
/**
 转账详情
 */
#define  give_money_detail  Base_URL"/app/user/give_money_detail"
/**
 升级购物下单
 */
#define  up_buy_good  Base_URL"/app/user/up_buy_good"
/**
 升级ceo
 */
#define  role_ceo  Base_URL"/app/user/role_ceo"

/**
 附近1.5公里有店铺 申请开店 取消申请
 */
#define  cancel_up_shop  Base_URL"/app/user/cancel_up_shop"
/**
 获取最新的赠送活动
 */
#define  get_send_ac  Base_URL"/app/user/get_send_ac"
/**
 升级判断是否要填写新的推荐码
 */
#define  top_info  Base_URL"/app/user/top_info"
/**
 修改发货订单的收货地址
 */
#define up_send_order_address  Base_URL"/app/user/up_send_order_address"

/**
 推荐码是否合法
 */
#define code_role_type  Base_URL"/app/user/code_role_type"
/**
 音视频列表
 */
#define course_list  Base_URL"/app/user/course_list"
/**
 课程详情
 */
#define course_detail  Base_URL"/app/user/course_detail"
/**
 我的年度考核
 */
#define year_my  Base_URL"/app/user/year_my"

/**
 我的年度考核团队
 */
#define year_group_list  Base_URL"/app/user/year_group_list"

/**
 我的积分明细
 */
#define send_score_record_list  Base_URL"/app/user/send_score_record_list"



#pragma mark ----- 小溪部分 ------

/**
  业绩考核
 */
#define check_detail  Base_URL"/app/user/check_detail"
/**
   我的小煜
 */
#define my_inner_score  Base_URL"/app/user/my_inner_score"

/**
 新增接口 按月-查看直属小煜 提现和收入汇总
 */
#define month_total_direct_score Base_URL"/app/user/month_total_direct_score"
/**
 小煜明细
 */
#define score_record_detail  Base_URL"/app/user/score_record_detail"

/**
  小煜提现
 */
#define apply_cash_out  Base_URL"/app/user/apply_cash_out"

/**
团队成员列表
 */
#define score_record_list  Base_URL"/app/user/score_record_list"

/**
 确认收到小煜接口
 */
#define confirm_score  Base_URL"/app/user/confirm_score"

/**
团队成员列表
 */
#define score_user_list  Base_URL"/app/user/score_user_list"

/**
  小煜转出
 */
#define give_score  Base_URL"/app/user/give_score"

/**
 新增接口 获取历史团队小煜
 */
#define month_total_group_score Base_URL"/app/user/month_total_group_score"

/**
 确认收到小煜接口
 */
#define my_group_total_sale  Base_URL"/app/user/my_group_total_sale"




/**
 获取图片地址
 */
+(NSString *)getPicImgWthPicStr:(NSString *)pic;

@end

