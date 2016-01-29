//
//  BillInfoDataModel.h
//  JinFu
//
//  Created by ybon on 16/1/11.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  描述一个账单周期的信息
 */
@interface BillInfoDataModel : NSObject
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *newlyGainedIntegral;
@property (nonatomic, copy) NSString *debt;
@property (nonatomic, copy) NSString *repayment;
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, strong) NSMutableArray *details;
@end
