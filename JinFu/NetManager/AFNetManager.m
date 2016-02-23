//
//  AFNetManager.m
//  ChengXiangYiGou
//
//  Created by 郑光龙 on 15/11/30.
//  Copyright © 2015年 zgl. All rights reserved.
//

#import "AFNetManager.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "AFNetworkReachabilityManager.h"
#import "AppDelegate.h"
#import "UserInfoModel.h"
#import "LoginVC.h"

@implementation AFNetManager
+ (instancetype)sharedManager {
    static AFNetManager *netManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [[AFNetManager alloc] init];
    });
    return netManager;
}

- (void)getDataFromServerWithHostUrl:(NSString *)url andParameters:(NSString *)parameter andNotificationName:(NSString *)noticeName {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",@"application/octet-stream", nil];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@", url, parameter] ;
    fullUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"fullUrl = %@", fullUrl);
    
    [manager GET:fullUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        DLog(@"responseObject = %@", responseObject);
        NSDictionary *responseObj = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:responseObj];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DLog(@"error = %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:nil];
    }];
    
}

-(void)postDataToServerWithHostUrl:(NSString *)url andParameters:(NSDictionary *)parameterDic andNotificationName:(NSString *)noticeName {
    DLog(@"fullUrl = %@", url);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    [manager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseObj = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:responseObj];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DLog(@"error = %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:nil];
    }];
}

- (void)uploadImageWithURLString:(NSString *)fullUrl andParameters:(NSDictionary *)parameterDic andImagePath:(NSString *)imagePath andNotificationName:(NSString *)noticeName {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"image/jpeg", @"image/png",nil];
    
    DLog(@"fullUrl = %@", fullUrl);
    [manager POST:fullUrl parameters:parameterDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData: UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:imagePath], 1.0) name:@"FileData" fileName:imagePath mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        DLog(@"%@", responseObject);
        NSDictionary *responseObj = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:responseObj];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DLog(@"error = %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:nil];
    }];
}

- (BOOL)checkNetStateWithTip:(NSString *)tips{
    AFNetworkReachabilityManager *reacherManager = [AFNetworkReachabilityManager sharedManager];
    if (reacherManager.isReachable == 0) {
        UIViewController *rootVC = [ShareApp.window rootViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootVC.view animated:NO];
        hud.mode = MBProgressHUDModeText;
        hud.color = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
        hud.animationType = MBProgressHUDAnimationFade;
        [hud hide:YES afterDelay:1.0];
        hud.labelText = (tips && ![tips isEqualToString:@""])? tips : @"无法连接服务器";
    }
    
    
    return reacherManager.isReachable > 0;
}

- (BOOL)checkLoginState {
    BOOL bRet = false;
    if ([[UserInfoModel sharedUserInfo].loginSuccess isEqualToString:@"true"]) {
        bRet = true;
    }else {
        UIViewController *rootVC = [ShareApp.window rootViewController];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginVC *loginVc = [[LoginVC alloc] init];
            [rootVC presentViewController:loginVc animated:YES completion:nil];
        }];
        [alertController addAction:alertActionCancel];
        
        UIAlertAction *alertActionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:alertActionConfirm];
        [rootVC presentViewController:alertController animated:YES completion:nil];
    }
    return bRet;
}
@end
