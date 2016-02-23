//
//  UnauthorizedChargeInfo.m
//  JinFu
//
//  Created by ybon on 15/12/26.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "ServiceInfoModel.h"

@implementation ServiceInfoModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardNumberArr = [[NSMutableArray alloc] init];
        self.uploadedImagePathsArr = [[NSMutableArray alloc] init];
        self.uploadImageIdsArr = [[NSMutableArray alloc] init];
        self.billDateArr = [[NSMutableArray alloc] init];
        self.bankNameArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 50; i++) {
            [self.cardNumberArr addObject:@""];
            [self.uploadImageIdsArr addObject:@""];
            [self.billDateArr addObject:@""];
            [self.uploadedImagePathsArr addObject:@""];
            [self.bankNameArr addObject:@""];
        }
        self.agreeProtol = false;
        
    }
    return self;
}
@end
