//
//  ServiceTypeDataModel.h
//  JinFu
//
//  Created by 郑光龙 on 16/1/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  增值服务类型
 */
@interface ServiceTypeDataModel : NSObject
@property (nonatomic, copy) NSString *serviceCycle;
@property (nonatomic, copy) NSString *servicePrice;
@property (nonatomic, copy) NSString *serviceType;
@property (nonatomic, copy) NSString *serviceRemark;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *serviceId;
@end
