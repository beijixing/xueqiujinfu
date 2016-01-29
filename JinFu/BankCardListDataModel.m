//
//  ServiceDataModel.m
//  JinFu
//
//  Created by ybon on 15/12/30.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "BankCardListDataModel.h"

@implementation BankCardListDataModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.serviceCardList = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
