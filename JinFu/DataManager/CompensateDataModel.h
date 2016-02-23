//
//  CompensateDataModel.h
//  JinFu
//
//  Created by ybon on 16/2/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompensateDataModel : NSObject

@property(nonatomic, copy)NSString* compensateTitle;
@property(nonatomic, copy)NSString* appyTime;
@property(nonatomic, copy)NSString* stateStr;
@property(nonatomic) NSInteger state;
@property(nonatomic) NSInteger compensateType;
@property(nonatomic, strong)NSMutableArray *imageArr;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, copy)NSString *IDNum;
@property(nonatomic, copy)NSString *TelNum;
@property(nonatomic, copy)NSString *creditCard;
@property(nonatomic, copy)NSString *amount;
@property(nonatomic, copy)NSString *remark;

+(instancetype)getInstanceWithDataDict:(NSDictionary*)dataDict;

@end
