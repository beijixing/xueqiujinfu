//
//  AFNetManager.h
//  ChengXiangYiGou
//
//  Created by 郑光龙 on 15/11/30.
//  Copyright © 2015年 zgl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNetManager : NSObject
+ (instancetype)sharedManager;

- (void)getDataFromServerWithHostUrl:(NSString *)url andParameters:(NSString *)parameter andNotificationName:(NSString *)noticeName;

-(void)postDataToServerWithHostUrl:(NSString *)url andParameters:(NSDictionary *)parameterDic andNotificationName:(NSString *)noticeName;

- (void)uploadImageWithURLString:(NSString *)fullUrl andParameters:(NSDictionary *)parameterDic andImagePath:(NSString *)imagePath andNotificationName:(NSString *)noticeName;
- (BOOL)checkLoginState;
- (BOOL)checkNetStateWithTip:(NSString *)tips;
@end
