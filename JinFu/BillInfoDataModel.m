//
//  BillInfoDataModel.m
//  JinFu
//
//  Created by ybon on 16/1/11.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "BillInfoDataModel.h"

@implementation BillInfoDataModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.details = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
