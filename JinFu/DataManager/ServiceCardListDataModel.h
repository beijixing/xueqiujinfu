//
//  ServiceCardListDataModel.h
//  JinFu
//
//  Created by ybon on 16/1/4.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  增值服务对应的银行卡
 */
@interface ServiceCardListDataModel : NSObject
@property (nonatomic, copy) NSString *cardNumber;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *serviceId;
@end
