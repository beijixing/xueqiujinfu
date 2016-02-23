//
//  ServiceDataModel.h
//  JinFu
//
//  Created by ybon on 15/12/30.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceInfoModel.h"
/**
 *  首页银行卡账单及服务信息描述
 */
@interface BankCardListDataModel : NSObject
@property (nonatomic, copy) NSString *dataType;//1.cardInfo 2.serviceInfo;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *cardLastNum;
@property (nonatomic, copy) NSString *debt;
@property (nonatomic, copy) NSString *minPay;
@property (nonatomic, copy) NSString *creditLine;
@property (nonatomic, copy) NSString *integral;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSString *deadLine;
@property (nonatomic, copy) NSString *cdTime;//为空
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, copy) NSString *partPayNum;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *billId;//不存库
@property (nonatomic, copy) NSString *billDate;//账单日

//服务
@property (nonatomic, copy) NSString *serviceCycle;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *serviceType;
@property (nonatomic, copy) NSString *serviceStatus;
@property (nonatomic, strong) NSMutableArray *serviceCardList;
@property (nonatomic, strong) ServiceInfoModel *serviceInfo;
@property (nonatomic, copy) NSString *serviceProcess;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *paidState;
@property (nonatomic, copy) NSString *address;
@end
