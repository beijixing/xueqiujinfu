//
//  AliPayApiManager.m
//  JinFu
//
//  Created by ybon on 16/1/15.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "AliPayApiManager.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AFNetManager.h"
#import "AFNetworking.h"

@implementation AliPayApiManager
+(instancetype)sharedManager{
    static AliPayApiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AliPayApiManager alloc] init];
    });
    return manager;
}

- (void)payOrderWithCost:(NSString*)cost subject:(NSString*)subject {
    return;
//    
//    [self sendAlipayRequstWithCost:cost subject:subject];
//    /*
//     *点击获取prodcut实例并初始化订单信息
//     */
////    Product *product = [self.productList objectAtIndex:indexPath.row];
//    
//    /*
//     *商户的唯一的parnter和seller。
//     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
//     */
//    
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *partner = @"";
//    NSString *seller = @"";
//    NSString *privateKey = @"";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        DLog(@"出错啦");
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = @"124"; //订单ID（由商家自行制定）
//    order.productName = @"增值服务"; //商品标题
//    order.productDescription = @"增值服务真好"; //商品描述
//    order.amount = @"100元每年"; //商品价格
//    order.notifyURL = @"http://www.xxx.com"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"alisdkdemo";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    DLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            DLog(@"reslut = %@",resultDic);
//            
//            if (self.delegate && [self.delegate respondsToSelector:@selector(payResult:)]) {
//                [self.delegate payResult:resultDic];
//            }
//        }];
//    }
    NSString *path=[NSString stringWithFormat:@"http://192.168.1.118:8123/service.php/Business/payVip"];
    NSDictionary *params=@{@"duration":@"1",@"vip_id":@"1",@"shop_id":@"1",@"which":@"2"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *obj= (NSDictionary *)responseObject ;
        if ([[obj objectForKey:@"code"]integerValue]==200) {
//            NSString *orderNum=[obj objectForKey:@"order_num"];
//            NSString *signedString=[obj objectForKey:@"sign"];
            NSString *orderString=[obj objectForKey:@"orderInfo"];
            NSLog(@"orderString:%@",orderString);
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"alipay" callback:^(NSDictionary *resultDic) {
                            DLog(@"reslut = %@",resultDic);
                
                            if (self.delegate && [self.delegate respondsToSelector:@selector(payResult:)]) {
                                [self.delegate payResult:resultDic];
                            }
                        }];

        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    
}

- (void)sendAlipayRequstWithCost:(NSString*)cost subject:(NSString*)subject {
    NSDictionary *parasDct = @{@"cost":cost,
                               @"subject":subject
                               };
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alipayNotification:) name:Alipayinfo object:nil];
    [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl, Alipayinfo] andParameters:parasDct andNotificationName:Alipayinfo];
}

- (void)alipayNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Alipayinfo object:nil];
    NSDictionary *resultDict = [userInfo objectForKey:@"responseObject"];
    DLog(@"%@", resultDict);
    if(resultDict != nil){
        NSMutableString *retcode = [resultDict objectForKey:@"return_code"];
        if ([retcode isEqualToString:@"SUCCESS"] == 0){
           
    
      
       
        }else{
            DLog("%@", [resultDict objectForKey:@"return_msg"]);
        }
    }else{
        DLog(@"服务器返回错误，未获取到json对象");
    }
}

@end
