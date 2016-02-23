//
//  BankCardIcon.h
//  JinFu
//
//  Created by ybon on 16/1/4.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  银行卡名称对应的银行Icon
 */
@interface BankCardIconManager : NSObject

+(instancetype)sharedManager;
- (NSString *)getBankIconPathWithName:(NSString *)bankName;

@end
