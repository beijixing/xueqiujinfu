//
//  AppDelegate.m
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "AppDelegate.h"
#import "JFTabBarController.h"
#import "DBManager.h"
#import "UserInfoModel.h"
#import "LoginVC.h"
#import "AFNetManager.h"
#import "AFNetworkReachabilityManager.h"
#import "BPush.h"
#import "ImportBillVC.h"
#import "WXApiManager.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Bugly/CrashReporter.h>
#import <IQKeyboardManager.h>
#import "MBProgressHUD.h"

@interface AppDelegate ()
{
    BOOL _autoLoginSuccess;
    MBProgressHUD *_hud;
}
@end
@implementation AppDelegate
@synthesize window =_window;
@synthesize isLogin;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"mainscreenwidth = %f", MainScreenWidth);
    [DBManager createDataBase];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [IQKeyboardManager sharedManager].enable = true;
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"wxb4ba3c02aa476ea1" withDescription:@"demo 2.0"];
    [self registerBaiduPushNotification:application andlaunchOption:launchOptions];
    [self performSelector:@selector(initRootViewController) withObject:nil afterDelay:0.35f];
 
//    [self testVC];
    return YES;
}

- (void)testVC{
    ImportBillVC *billVc = [[ImportBillVC alloc] init];
    self.window.rootViewController = billVc;
}

- (void)initRootViewController {
    UserInfoModel *userInfo = [[DBManager sharedDBManager] queryUserInfo];
    if ([userInfo.savePassword isEqualToString:@"true"]) {
        //记住密码自动登录
        if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
            [self goHomePage];
        }else{
            [self autoLogin:@"0"];
        }
    }else {
        LoginVC *loginVc = [[LoginVC alloc] init];
        self.window.rootViewController=loginVc;
    }
    
    //bug收集
    [[CrashReporter sharedInstance] installWithAppId:@"900017545"];
}

- (void)loginNotification:(NSNotification*)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Login object:nil];
    DLog(@"resultDic = %@", resultDic);
    
    NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
    if ([[responseObject objectForKey:@"login"]isEqualToString:@"1"]) {
        _autoLoginSuccess = true;
        [_hud hide:YES];
        //保存登录状态
        [UserInfoModel sharedUserInfo].loginSuccess = @"true";
        if (![[UserInfoModel sharedUserInfo].chanelId isEqualToString:@""]) {
            [self sendPushChanelIdToServer];
        }
    }else {
        [_hud hide:YES];
        [UserInfoModel sharedUserInfo].loginSuccess = @"false";
        [ToolBox showAlertInfo:@"登陆失败"];
    }
    [self goHomePage];
}

- (void)autoLogin:(NSString *)refresh {
    UserInfoModel *userInfo = [[DBManager sharedDBManager] queryUserInfo];
    if ([refresh isEqualToString:@"0"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification:) name:Login object:nil];
            _hud = [[MBProgressHUD alloc] initWithView:self.window];
            _hud.removeFromSuperViewOnHide = YES;
            [self.window addSubview:_hud];
            [_hud show:YES];
    }
    _autoLoginSuccess = false;
    NSString *parameter = [NSString stringWithFormat:@"%@email=%@&password=%@&refresh=1",Login, userInfo.email, userInfo.passWord];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:parameter andNotificationName:Login];
}

- (void)goHomePage {
    JFTabBarController *tabBarVc = [[JFTabBarController alloc] init];
    self.window.rootViewController = tabBarVc;
}


- (void)registerBaiduPushNotification:(UIApplication *)application andlaunchOption:(NSDictionary *)launchOptions{
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    [BPush registerChannel:launchOptions apiKey:@"1huGkrt6ILlxjMAO87XArTAr" pushMode:BPushModeDevelopment withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:YES];
    
    [self getAppPushConfigInfo];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        DLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    /*
     // 测试本地通知
     [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
     */

}

- (void)getAppPushConfigInfo {
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
//        DLog(@"getAppPushConfigInfo result = %@", result);
        [UserInfoModel sharedUserInfo].chanelId = [result objectForKey:@"channel_id"];
        if ([[UserInfoModel sharedUserInfo].loginSuccess isEqualToString:@"true"]) {
            [self sendPushChanelIdToServer];
        }
    }];
}


- (void)sendPushChanelIdToServer {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChannelIdNotification:) name:UpdateChannelId object:nil];
    NSString *parameter = [NSString stringWithFormat:@"%@iosChannelId=%@", UpdateChannelId, [UserInfoModel sharedUserInfo].chanelId];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:parameter andNotificationName:UpdateChannelId];
}


- (void)updateChannelIdNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UpdateChannelId object:nil];
    DLog(@"resultDic  =%@", resultDic);
    
}

- (void)testLocalNotifi
{
    DLog(@"测试本地通知啦！！！");
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
    [BPush localNotification:fireDate alertBody:@"这是本地通知" badge:3 withFirstAction:@"打开" withSecondAction:@"关闭" userInfo:nil soundName:nil region:nil regionTriggersOnce:YES category:nil];
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    DLog(@"********** iOS7.0之后 background **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        DLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"雪球卡卡通知" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
//        SkipViewController *skipCtr = [[SkipViewController alloc]init];
        // 根视图是nav 用push 方式跳转
//        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
        /*
         // 根视图是普通的viewctr 用present跳转
         [_tabBarCtr.selectedViewController presentViewController:skipCtr animated:YES completion:nil]; */
    }
    
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        if (result) {
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    DLog(@"设置tag成功");
                }
            }];
        }
    }];
    
    // 打印到日志 textView 中
 
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    DLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        DLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        DLog(@"杀死状态下，直接跳转到跳转页面");
    }
    
    DLog(@"%@",userInfo);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"result = %@",resultDic);
        }];
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
     DLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
      DLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DLog(@"applicationWillEnterForeground");
    [self autoLogin:@"1"];//刷新登陆
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     DLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    DLog(@"applicationWillTerminate");
}

@end
