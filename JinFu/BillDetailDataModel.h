//
//  BillDetailDataMOdel.h
//  JinFu
//
//  Created by 郑光龙 on 16/1/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  描述一个账单周期中 消费和还款的详细信息
 */
@interface BillDetailDataModel : NSObject
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *billDescription;
@property (nonatomic, copy) NSString *postedDate;//格式 1128 11月28日//消费日期
@property (nonatomic, copy) NSString *billId;
@end
