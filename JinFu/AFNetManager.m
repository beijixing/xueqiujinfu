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
    if ([self checkNetState] == 0)//
    {
        return;
    }
    
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
    if ([self checkNetState] == 0)//
    {
        return;
    }
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
    if ([self checkNetState] == 0)//
    {
        return;
    }
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

- (BOOL)checkNetState{
    AFNetworkReachabilityManager *reacherManager = [AFNetworkReachabilityManager sharedManager];
    
    if (reacherManager.isReachable == 0) {
        UIViewController *rootVC = [ShareApp.window rootViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootVC.view animated:NO];
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationFade;
        [hud hide:YES afterDelay:1.0];
        hud.labelText = @"无法连接服务器";
    }
    return reacherManager.isReachable;
}

@end
