//
//  CONST.h
//  zglTest
//
//  Created by 郑光龙 on 15/10/27.
//  Copyright © 2015年 郑光龙. All rights reserved.
//

#ifndef CONST_h
#define CONST_h

// iPad
#define IsPad [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
#define IsPhone [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]



#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define ColorWithRGB(R,G,B) [UIColor colorWithRed:(R/255.0f) green:(G/255.0f) blue:(B/255.0f) alpha:1.0f]
#define ColorWithRGBA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#define ImageName(a) [UIImage imageNamed:a]

#define iOS_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]
#define MAIN_COLOR  ColorWithRGB(140,181,48)
#define ViewMainColor ColorWithRGB(243, 244, 245)

// 取得AppDelegate单利
#define ShareApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// 接口
#define HostUrl @"http://192.168.1.83:8080/"  // 测试库
//#define HostUrl @"http://hao-lib.gongyeyun.com/"// 正式库

#define Login @"finaServ/member/login.do?" // 登陆接口
#define Register @"finaServ/member/register.do?" // 注册接口
#define ImportProgress @"finaServ/analyze/progress.do" // 抓取进度接口
#define ImportBills @"finaServ/analyze/load.do" //导入账单信息
//#define FeedBack @"/opinion/addOpinion.do?"//意见反馈接口
#define SystemInfo @"SystemMessage.ashx" // 系统消息



// 友盟key
#define UmengAppkey @"55543fb2e0f55a4987000a83" // 友盟社会化组件key
// 微信分享相关的
#define WeiXinAppID @"wx06321aac97e9678f"
#define WeiXinAppSecret @"4968c9d6cad01f40bfe3e19709fa2ef3"

// 百度推送相关
#define BPushID @"6666791"
#define BPushAPIKey @"ZqRKz4d8I3SL2HpE5bqKFBry"
#define BPushSecretKey @"GFSIdnUmKG9uvPGVfi3KGDkmmokXvhWg"


#endif /* CONST_h */
