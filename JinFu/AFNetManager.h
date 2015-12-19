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
@end
