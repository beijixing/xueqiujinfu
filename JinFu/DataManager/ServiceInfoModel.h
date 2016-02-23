//
//  UnauthorizedChargeInfo.h
//  JinFu
//
//  Created by ybon on 15/12/26.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  编辑服务信息时暂存的数据结构
 */
@interface ServiceInfoModel : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *identityCard;
@property(nonatomic, copy) NSString *phoneNumber;
@property(nonatomic, strong) NSMutableArray *cardNumberArr;
@property(nonatomic, strong) NSMutableArray *bankNameArr;
@property(nonatomic, copy) NSString *servicePeriod;
@property(nonatomic, strong) NSMutableArray *uploadImageIdsArr;
@property(nonatomic, strong) NSMutableArray *uploadedImagePathsArr;
@property(nonatomic, copy) NSString *totalCost;
@property(nonatomic, strong) NSMutableArray *billDateArr;
@property(nonatomic, copy) NSString *preRemindDays;
@property(nonatomic, copy) NSString *remindTime;
@property(nonatomic) BOOL agreeProtol;
@property(nonatomic, copy) NSString *posAddress;

//
@property(nonatomic, copy) NSString *productId;
@end
