//
//  UserInfoModel.m
//  JinFu
//
//  Created by ybon on 15/12/21.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+(instancetype)sharedUserInfo {
    static UserInfoModel *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfoModel alloc] init];
    });
    return userInfo;
}
@end
