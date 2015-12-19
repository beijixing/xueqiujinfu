//
//  AFNetManager.m
//  ChengXiangYiGou
//
//  Created by 郑光龙 on 15/11/30.
//  Copyright © 2015年 zgl. All rights reserved.
//

#import "AFNetManager.h"
#import "AFNetworking.h"

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
    
//    @"application/json",@"text/html",@"text/plain",@"application/octet-stream
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@", url, parameter] ;
    fullUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"fullUrl = %@", fullUrl);
    
    [manager GET:fullUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@ = ", responseObject);
        NSDictionary *responseObj = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:responseObj];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:nil];
    }];
    
}

-(void)postDataToServerWithHostUrl:(NSString *)url andParameters:(NSDictionary *)parameterDic andNotificationName:(NSString *)noticeName {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    
    
    [manager POST:url parameters:parameterDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseObj = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:responseObj];
        NSLog(@"responseObject = %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil userInfo:nil];
    }];
    
}

@end
