//
//  AppDelegate.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/9.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "AppDelegate.h"
#import "LxmTabBarVC.h"
#import "LxmLoginVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

#import <UMPush/UMessage.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

#import "LxmQianBaoVC.h"
#import "LxmJieDanMyPublishDetailVC.h"
#import "LxmSeeOtherInfoVC.h"
#import "LxmTouSuDetailVC.h"
#import "LxmSuCaiTabBarVC.h"
#import "LxmHongBaoAlertView.h"
#import "LxmWebViewController.h"
#import "LxmQianBaoMessageVC.h"

#import "LxmJieDanMyAcceptDetailVC.h"

#import "LxmJieDanListViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "LxmOrderDetailVC.h"
#import "LxmBuHuoDetailVC.h"

#import "LxmMyBaoZhengJinVC.h"
#import "LxmMineJiFenXiaJiTVC.h"

//role_province和role_ceo  申请省代申请CEO,加个字段up_message，申请理由

 //虞美人苹果账号密码 joofzu@163.com Vv11223344
//百度云 13338797098 ymr666888
//com.biuwork.yumeiren
//友盟账号：煜美人；密码：YMR0627@
//腾讯开放平台 13338797098 YMR0627@
//biu 大手机 f64dcdc53cc282f6a25213f9d63b763fa4036aa9 小手机 d04026b7021cec2a07e7da6dba65647b78e4cc3 24d42a6923d63f1bebb5cddb20e03f5baae01394
//13372278494  13584589643
//高德地图；账号：13338797098；密码：YMR0627@
// User Interface Style : Light



#define WXAppID @"wx039d5ff19254f491"
#define WXAppSecret @"dd7b2c888d05818d52b20932d5aa9add"
#define UMKey @"5d5b49e1570df386a80007aa"
#define UMAppAecret @"arz1tz9irt79iuu1qsopqobafizt4xxb"
#define QQAppSecret @"I3XA6kvgze9wBAQE"
#define QQAppID @"1109487321"
#define AMapKey @"91c7d905a625e4ee5efc65dbf919d1b8"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启动图片延时: 2秒
    [NSUserDefaults.standardUserDefaults objectForKey:@"userModel"];
    [NSThread sleepForTimeInterval:2];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([LxmTool ShareTool].isLogin) {
        self.window.rootViewController = [[LxmTabBarVC alloc] init];
    } else {
        self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];
    }
    [self initPush];
    [self initUMeng:launchOptions];
    
    [[AMapServices sharedServices] setApiKey:AMapKey];
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initPush {
    //向微信注册,发起支付必须注册
//    [WXApi registerApp:WXAppID enableMTA:NO];
    [WXApi registerApp:WXAppID universalLink:@"https://hkymr/app/"];
    
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAppID appSecret:WXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID appSecret:QQAppSecret redirectURL:@"http://mobile.umeng.com/social"];
}

- (void)initUMeng:(NSDictionary *)launchOptions {
    [UMConfigure initWithAppkey:UMKey channel:nil];
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:nil completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
}


//在用户接受推送通知后系统会调用
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    NSString *token = [self getHexStringForData:deviceToken];
    //将deviceToken给后台
    NSLog(@"send_token:%@",token);
    [LxmTool ShareTool].deviceToken = token;
    if (ISLOGIN) {
        NSLog(@"%@",[LxmTool ShareTool].deviceToken);
        [[LxmTool ShareTool] uploadDeviceToken];
    }
}

- (NSString *)getHexStringForData:(NSData *)data {
//    NSUInteger len = [data length];
//    char *chars = (char *)[data bytes];
//    NSMutableString *hexString = [[NSMutableString alloc] init];
//    for (NSUInteger i = 0; i < len; i++) {
//        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
//    }
//    return hexString;
    
    NSString * token = @"";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        if (![data isKindOfClass:[NSData class]]) {
            //记录获取token失败的描述
            return token;
        }
        const unsigned *tokenBytes = (const unsigned *)[data bytes];
        token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                 ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                 ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                 ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        NSLog(@"deviceToken1:%@", token);
    } else {
        token = [NSString
                 stringWithFormat:@"%@",data];
        token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    return token;
    
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [UMessage setAutoAlert:NO];
            //应用处于前台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
        }else{
            //应用处于前台时的本地推送接受
            LxmPushModel *model = [LxmPushModel mj_objectWithKeyValues:userInfo];
            //1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息
            LxmTabBarVC * bar = (LxmTabBarVC *)self.window.rootViewController;
            bar.selectedIndex = 0;
            BaseNavigationController * nav  = (BaseNavigationController *)bar.selectedViewController;
            [self pageTo:model nav:nav];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
            LxmPushModel *model = [LxmPushModel mj_objectWithKeyValues:userInfo];
            if (![LxmTool ShareTool].isLogin) {
                [SVProgressHUD showErrorWithStatus:@"您目前处于离线状态"];
                return;
            }
            //1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息
            LxmTabBarVC * bar = (LxmTabBarVC *)self.window.rootViewController;
            bar.selectedIndex = 0;
            BaseNavigationController * nav  = (BaseNavigationController *)bar.selectedViewController;
            [self pageTo:model nav:nav];
        }else{
            //应用处于后台时的本地推送接受
            NSLog(@"11111");
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();
}

- (void)pageTo:(LxmPushModel *)model nav:(BaseNavigationController *)nav {
    if (model.secondType.integerValue == 41) {//41-进我发布的订单详情
        LxmJieDanListModel *m = [LxmJieDanListModel new];
        m.id = model.infoId;
        LxmJieDanMyPublishDetailVC *vc = [[LxmJieDanMyPublishDetailVC alloc] init];
        vc.model = m;
        [nav pushViewController:vc animated:YES];
    } else if (model.secondType.integerValue == 42) {//42-进我接的订单详情
        LxmJieDanListModel *m = [LxmJieDanListModel new];
        m.id = model.infoId;
        LxmJieDanMyAcceptDetailVC *vc = [[LxmJieDanMyAcceptDetailVC alloc] init];
        vc.model = m;
        [nav pushViewController:vc animated:YES];
    } else if (model.secondType.integerValue == 43) {//43-有可接订单，进接单大厅列表
        LxmJieDanListViewController *vc = [[LxmJieDanListViewController alloc] init];
        vc.navigationItem.title = @"接单平台";
        [nav pushViewController:vc animated:YES];
    } else if (model.secondType.integerValue == 51 || model.secondType.integerValue == 52) {//批量购进 批量销售
        LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
        vc.iscaiGouandXiaoshou = YES;
        vc.orderID = model.infoId;
        [nav pushViewController:vc animated:YES];
    } else if (model.secondType.integerValue == 53) {//补货单相关
        LxmBuHuoDetailVC *vc = [[LxmBuHuoDetailVC alloc] init];
        vc.orderID = model.infoId;
        [nav pushViewController:vc animated:YES];
    }
    
    switch (model.infoType.intValue) {
        case 1: {//系统消息
            if (model.infoUrl.isValid) {
                LxmWebViewController *vc = [[LxmWebViewController alloc] init];
                vc.navigationItem.title = @"系统消息";
                vc.loadUrl = [NSURL URLWithString:model.infoUrl];
                [nav pushViewController:vc animated:YES];
            }
        }
            break;
        case 2: {//2-代理变动
            LxmMyTeamListModel *m = [LxmMyTeamListModel new];
            m.id = model.infoId;
            LxmSeeOtherInfoVC *vc = [[LxmSeeOtherInfoVC alloc] init];
            vc.model = m;
            [nav pushViewController:vc animated:YES];
        }
            break;
        case 3: {//3-钱包消息
            if (model.secondType.intValue == 38) {//跳转补货订单详情
                LxmBuHuoDetailVC *vc = [[LxmBuHuoDetailVC alloc] init];
                vc.orderID = model.infoId;
                [nav pushViewController:vc animated:YES];
            } else if (model.secondType.intValue == 39) {//跳转购进订单详情
                LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
                vc.iscaiGouandXiaoshou = YES;
                vc.orderID = model.infoId;
                [nav pushViewController:vc animated:YES];
            }else if (model.secondType.intValue == 85 || model.secondType.intValue == 86) {//跳转购进订单详情
                LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
                vc.orderID = model.infoId;
                [nav pushViewController:vc animated:YES];
            }else if (model.secondType.intValue == 91 || model.secondType.intValue == 92) {
                LxmMineJiFenXiaJiTVC * vc =[[LxmMineJiFenXiaJiTVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:vc animated:YES];
                
            }else if (model.secondType.intValue == 40) {//保证金退回到余额
                LxmMyBaoZhengJinVC *vc = [[LxmMyBaoZhengJinVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                [nav pushViewController:vc animated:YES];
            } else {
                LxmQianBaoVC *vc = [[LxmQianBaoVC alloc] init];
                [nav pushViewController:vc animated:YES];
            }
        }
            break;
        case 6: {//6-投诉消息
            LxmTouSuDetailVC *vc = [[LxmTouSuDetailVC alloc] init];
            vc.ID = model.infoId;
            [nav pushViewController:vc animated:YES];
        }
            break;
        case 7: {//7-素材消息
            LxmQianBaoMessageVC *vc = [[LxmQianBaoMessageVC alloc] init];
            vc.infoType = @"7";
            [nav pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"com.biuwork.yumeiren.alipaysafety"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoPay" object:resultDic];
        }];
    } else if([url.scheme isEqualToString:@"wx039d5ff19254f491"]&&[url.resourceSpecifier containsString:@"//pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }  else if([url.scheme isEqualToString:@"wx039d5ff19254f491"]&&[url.resourceSpecifier containsString:@"//oauth"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    } else if ([url.scheme containsString:@"QQ"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    if ([url.scheme isEqualToString:@"com.biuwork.yumeiren.alipaysafety"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoPay" object:resultDic];
        }];
    } else if([url.scheme isEqualToString:@"wx039d5ff19254f491"]&&[url.resourceSpecifier containsString:@"//pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    } else if([url.scheme isEqualToString:@"wx039d5ff19254f491"]&&[url.resourceSpecifier containsString:@"//oauth"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    } else if ([url.scheme containsString:@"QQ"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.scheme isEqualToString:@"com.biuwork.yumeiren.alipaysafety"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuBaoPay" object:resultDic];
        }];
    } else if([url.scheme isEqualToString:@"wx039d5ff19254f491"]&&[url.resourceSpecifier containsString:@"//pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }  else if([url.scheme isEqualToString:@"wx039d5ff19254f491"]&&[url.resourceSpecifier containsString:@"//oauth"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url];
    } else if ([url.scheme containsString:@"QQ"]) {
         [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return YES;
}

-(void)onResp:(BaseResp*)resp{
    //发送一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPAY" object:resp];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
