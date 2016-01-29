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
#define HostUrl @"http://192.168.1.39:8080/finaServ/"  // 测试库
//#define HostUrl @"http://hao-lib.gongyeyun.com/"// 正式库
//#define HostUrl @"http://192.168.1.81:8080/finaServ/"//吴文进

#define Login @"member/login.do?" // 登陆接口
#define Register @"member/register.do?" // 注册接口
#define ImportProgress @"analyze/progress.do" // 抓取进度接口
#define ImportBills @"analyze/load.do" //导入账单信息
#define FeedBack @"opinion/addOpinion.do"//意见反馈接口
#define HomePageData @"analyze/index.do"//首页信用卡及服务列表
#define BillDetail @"analyze/bill_list.do?"//获取信用卡账单详情
#define PopulerRegister @"affiliate/is_registered.do"//推广员是否注册
#define RegisterMan @"affiliate/register.do?"//推广员注册
#define Get_Unpaid_Amount @"commission/get_unpaid_amount.do"//业务推广 未结金额
#define Get_Min_Pay @"commission/get_min_pay.do"//业务推广 最低提现金额
#define Get_Affiliate @"affiliate/get_affiliate.do"//提交返现获得信息
#define withdrawal_request @"withdrawal/request.do?"//提交返现
#define GetBuyServiceList @"buyservice/getMemberBuyServiceById.do"//获取该用户购买的所有服务
#define uploadFile @"/upload/uploadFile.do" //上传文件
#define AddPayment @"payment/addPayment.do" //丢卡赔付编辑申请
#define Get_My_WithDrawal @"withdrawal/get_my_withdrawal.do"//业务推广提现明细
#define Get_My_Commission @"commission/get_my_commission.do"//业务推广收入明细
#define GetAddedServiceList @"addservice/getServiceList.do"//获取所有增值服务
#define UpLoadImage @"upload/uploadFile.do"//图片上传接口
#define AddSwingCardService @"buyservice/addSwingCardService.do"//盗刷保障
#define AddBuyLostService @"buyservice/addBuyLostService.do"//丢卡保障
#define AddPhoneService @"buyservice/addPhoneService.do"//电话服务
#define AddPOSService @"buyservice/addPOSService.do"//购买POS
#define ContBuyLostService @"buyservice/contBuyLostService.do"//丢卡保障续保
#define ContSwingCardService @"buyservice/contSwingCardService.do"//盗刷保障续保
#define ContPhoneService @"buyservice/contPhoneService.do"//电话服务续保
#define EditPOSService @"buyservice/editPOSService.do"//POS重新申请

#define EditBuyLostService @"buyservice/editBuyLostService.do"//丢卡保障重新编辑
#define CEditBuyLostService @"buyservice/cEditBuyLostService.do"//续保重新编辑

#define EditSwingCardService @"buyservice/editSwingCardService.do"//盗刷保障重新编辑
#define CEditSwingCardService @"buyservice/cEditSwingCardService.do"//盗刷续保重新编辑

#define EditPhoneService @"buyservice/editPhoneService.do" //电话保障重新编辑
#define CEditPhoneService @"buyservice/cEditPhoneService.do"//电话续保重新编辑
#define BillUpdate @"bill/update.do?"//更新还款状态
#define MemberExit @"member/exit.do"//用户推出登陆
#define GetADList @"ad/getADList.do"//获取广告列表
#define UpdateChannelId @"member/updateChannelId.do?"//百度推送的ChanelID；
#define PasswordCorrect @"member/is_password_correct.do"//检查邮箱密码是否正确


//#define SystemInfo @"SystemMessage.ashx" // 系统消息


// 友盟key
#define UmengAppkey @"55543fb2e0f55a4987000a83" // 友盟社会化组件key
// 微信分享相关的
#define WeiXinAppID @"wx06321aac97e9678f"
#define WeiXinAppSecret @"4968c9d6cad01f40bfe3e19709fa2ef3"

// 百度推送相关
#define BPushID @"7635182"
#define BPushAPIKey @"scEQKTVhI6Iuxspc0xj4A85V"
#define BPushSecretKey @"Xrmd49vy3Uh2IST2S1B18lnSeCig4qDT"


//应用中用到的中文
#define NAME_STRING @"姓名"
#define PHONE_NUMBER_STRING @"手机号"
#define BANK_CARD_NUMBER_STRING @"银行卡号"
#define BILL_DATE_STRING @"账单日"
#define REMIND_DATE_STRING @"提醒时间"
#define SERVIEC_PERIOD_STRING @"服务周期"
#define POST_ADDRESS_STRING @"寄送地址"
#define ID_CARD_NUMBER_STRING @"身份证号"
#define BNAK_NAME @"银行名称"
#endif 


/* CONST_h */
