//
//  UserInfoModel.h
//  JinFu
//
//  Created by ybon on 15/12/21.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic, copy)NSString *phoneNumber;
@property (nonatomic, copy)NSString *passWord;
@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *savePassword;
@property (nonatomic, copy)NSString *loginSuccess;
@property (nonatomic, copy)NSString *chanelId;
@property (nonatomic, copy)NSString *promoter;
@property (nonatomic, copy)NSString *unpaidCount;
@property (nonatomic, copy)NSString *realName;
+(instancetype)sharedUserInfo;
@end
