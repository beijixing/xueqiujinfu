//
//  DBManager.h
//  JinFu
//
//  Created by ybon on 15/12/21.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "BankCardListDataModel.h"
#import "BillInfoDataModel.h"

@interface DBManager : NSObject
+ (instancetype)sharedDBManager;
+ (void)createDataBase;
- (UserInfoModel *)queryUserInfo;
- (BOOL)saveUserInfo:(UserInfoModel *)userInfo;
- (void)deleteUserInfo;

- (void)saveBankCardListData:(NSArray *)bankArr;
- (NSMutableArray *)queryBankCardListData;
- (void)updateBankCardListData:(BankCardListDataModel*)bankCardListData;

- (void)saveBillInfoData:(NSArray *)billArr withCardId:(NSString *)cardId;
- (NSMutableArray *)queryBillInfoDataWithCardId:(NSString *)cardId;

- (void)saveServiceTypeData:(NSArray *)serviceTypeData;
- (NSMutableArray *)queryServiceTypeData;

- (void)saveAdData:(NSArray *)adDataArr;
- (NSMutableArray *)queryAdData;

- (void)saveAllPaidService:(NSArray *)allService;
- (NSMutableArray *)queryAllPaidService;


- (void)saveIncomeDetail:(NSArray *)incomeData;
- (NSMutableArray *)queryIncomeDetail;

- (void)saveWithdrawDetail:(NSArray *)withDrawData;
- (NSMutableArray *)queryWithdrawDetail;
@end
