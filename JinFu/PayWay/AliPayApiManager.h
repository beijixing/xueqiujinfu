//
//  AliPayApiManager.h
//  JinFu
//
//  Created by ybon on 16/1/15.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AliPayApiManagerDelegate <NSObject>

- (void)payResult:(NSDictionary *)result;

@end

@interface AliPayApiManager : NSObject
+(instancetype)sharedManager;

@property (nonatomic, assign) id<AliPayApiManagerDelegate> delegate;

- (void)payOrderWithCost:(NSString*)cost subject:(NSString*)subject;
@end
