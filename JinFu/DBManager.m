//
//  DBManager.m
//  JinFu
//
//  Created by ybon on 15/12/21.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "DBManager.h"
#import "UserInfoModel.h"
#import "FMDatabase.h"
#import "ServiceCardListDataModel.h"
#import "BillInfoDataModel.h"
#import "BillDetailDataModel.h"
#import "ServiceTypeDataModel.h"
#import "AdDataModel.h"
#import "IncomeDetail.h"
#import "WithdrawDetail.h"

NSString *_dbPath = @"/data.sqlite";

//phoneNumber;
//passWord;
//email;
//savePassword;
//loginSuccess;

NSString *userInfoTable = @"create table IF NOT EXISTS 'UserInfo' (phoneNumber text, passWord text, email text, savePassword text, loginSuccess text, promoter text, unpaidCount text, realName text, id integer primary key autoincrement)";

/*
 dataType
 bankName;
 cardLastNum;
 debt;
 minPay;
 creditLine;
 integral;
 period;
 deadLine;
 cdTime;
 payStatus
 partPayNum
 
 //服务
 serviceCycle;
 endTime;
 serviceId
 serviceType
 serviceStatus
 
 */
NSString *bankCardListTable = @"create table IF NOT EXISTS 'BankCardListTable' (dataType text, bankName text, cardLastNum text, debt text, minPay text, creditLine text,integral text, period text, deadLine text, cdTime text, payStatus text, partPayNum text, cardId text, billDate text, serviceCycle text, endTime text,serviceId text, serviceType text, serviceStatus text, id integer primary key autoincrement)";

/*
cardNumber;
bankName;
serviceId;
 */

NSString *serviceCardListTable =  @"create table IF NOT EXISTS 'ServiceCardListTable' (cardNumber text, bankName text, serviceId text, id integer primary key autoincrement)";


/*
 @property (nonatomic, strong) NSString *period;
 @property (nonatomic, strong) NSString *integral;
 @property (nonatomic, strong) NSString *newlyGainedIntegral;
 @property (nonatomic, strong) NSString *debt;
 @property (nonatomic, strong) NSString *repayment;
 @property (nonatomic, strong) NSString *billId;
 @property (nonatomic, strong) NSString *cardId;
 @property (nonatomic, strong) NSMutableArray *details;
 */
NSString *billInfoDataTable = @"create table IF NOT EXISTS 'BillInfoDataTable' (period text, integral text, newlyGainedIntegral text, debt text, repayment text, billId text, cardId text, id integer primary key autoincrement)";
/*
 @property (nonatomic, strong) NSString *amount;
 @property (nonatomic, strong) NSString *currency;
 @property (nonatomic, strong) NSString *billDescription;
 @property (nonatomic, strong) NSString *postedDate;//格式 1128 11月28日//消费日期
 @property (nonatomic, strong) NSString *billId;
 */

NSString *billDetailDataTable = @"create table IF NOT EXISTS 'BillDetailDataTable' (amount text, currency text, billDescription text, postedDate text, billId text, id integer primary key autoincrement)";

/*
 @property (nonatomic, strong) NSString *serviceCycle;
 @property (nonatomic, strong) NSString *servicePrice;
 @property (nonatomic, strong) NSString *serviceType;
 @property (nonatomic, strong) NSString *serviceRemark;
 @property (nonatomic, strong) NSString *serviceName;
 @property (nonatomic, strong) NSString *serviceId;
 */
NSString *serviceTypeDataTable = @"create table IF NOT EXISTS 'ServiceTypeDataTable' (serviceCycle text, servicePrice text, serviceType text, serviceRemark text, serviceName text, serviceId text, id integer primary key autoincrement)";

/*
 @property (nonatomic, strong) NSString *imageUrlStr;
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, strong) NSString *content;
 @property (nonatomic, strong) NSString *url;
 */

NSString *adDataTable = @"create table IF NOT EXISTS 'AdDataTable' (imageUrlStr text, name text, content text, url text, id integer primary key autoincrement)";


/*
    所有增值服务
 */

NSString *allServiceTable = @"create table IF NOT EXISTS 'AllServiceTable' (bankName text, period text, deadLine text, serviceCycle text, endTime text, serviceId text, serviceType text, serviceStatus text, id integer primary key autoincrement)";

/*
customerName;
date;
count;
*/
NSString *incomeDetailTable = @"create table IF NOT EXISTS 'IncomeDetailTable' (customerName text, date text, count text, id integer primary key autoincrement)";

/*
 @property (nonatomic, copy) NSString *date;
 @property (nonatomic, copy) NSString *count;
*/
NSString *withdrawDetailTable = @"create table IF NOT EXISTS 'WithdrawDetailTable' (date text, count text, id integer primary key autoincrement)";

@implementation DBManager
+ (instancetype)sharedDBManager {
    static DBManager *dbManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[DBManager alloc] init];
    });
    return dbManager;
}

+ (void)createDataBase {
    FMDatabase* _dataBase = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    DLog(@"dbPath = %@", [NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]);
    
    if (![_dataBase open]) {
        DLog(@"数据库打开失败");
        return;
    }
    BOOL bRet = [_dataBase executeUpdate:userInfoTable];
    if (!bRet) {
        DLog(@"创建 userInfoTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:bankCardListTable];
    if (!bRet) {
        DLog(@"创建 bankCardListTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:serviceCardListTable];
    if (!bRet) {
        DLog(@"创建 serviceCardListTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:billInfoDataTable];
    if (!bRet) {
        DLog(@"创建 billInfoDataTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:billDetailDataTable];
    if (!bRet) {
        DLog(@"创建 billDetailDataTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:serviceTypeDataTable];
    if (!bRet) {
        DLog(@"创建 billDetailDataTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:adDataTable];
    if (!bRet) {
        DLog(@"创建 adDataTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:allServiceTable];
    if (!bRet) {
        DLog(@"创建 allServiceTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:incomeDetailTable];
    if (!bRet) {
        DLog(@"创建 incomeDetailTable 失败");
    }
    
    bRet = [_dataBase executeUpdate:withdrawDetailTable];
    if (!bRet) {
        DLog(@"创建 withdrawDetailTable 失败");
    }
    [_dataBase close];
}


- (UserInfoModel *)queryUserInfo {
    UserInfoModel *userInfo = [UserInfoModel sharedUserInfo];
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }

    FMResultSet* result = [db executeQuery:@"Select * from 'UserInfo' "];
    while ([result next]) {
        userInfo.phoneNumber = [result stringForColumn:@"phoneNumber"];
        userInfo.passWord = [result stringForColumn:@"passWord"];
        userInfo.email = [result stringForColumn:@"email"];
        userInfo.savePassword = [result stringForColumn:@"savePassword"];
        userInfo.loginSuccess = [result stringForColumn:@"loginSuccess"];
        userInfo.promoter = [result stringForColumn:@"promoter"];
        userInfo.unpaidCount = [result stringForColumn:@"unpaidCount"];
        userInfo.realName = [result stringForColumn:@"realName"];
    }
    [db close];
    return userInfo;
}

- (BOOL)saveUserInfo:(UserInfoModel *)userInfo {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return false;
    }
    
    db.shouldCacheStatements = YES;
    NSString* querySql = [NSString stringWithFormat:@"SELECT * FROM 'UserInfo' WHERE email = '%@'", userInfo.email];
    DLog(@"querySql = %@", querySql);
    FMResultSet *result = [db executeQuery: querySql];
    if ([result next]) {
        NSString *sqlstr = [NSString stringWithFormat:@"UPDATE 'UserInfo' SET phoneNumber = '%@', passWord = '%@', email = '%@', savePassword = '%@', loginSuccess = '%@', promoter = '%@', unpaidCount = '%@', realName = '%@' WHERE email = '%@' ", userInfo.phoneNumber,  userInfo.passWord, userInfo.email, userInfo.savePassword, userInfo.loginSuccess, userInfo.promoter, userInfo.unpaidCount, userInfo.realName, userInfo.email];
        [db executeUpdate: sqlstr];
    }else{
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'UserInfo' (phoneNumber, passWord, email, savePassword, loginSuccess, promoter, unpaidCount, realName) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') ", userInfo.phoneNumber, userInfo.passWord, userInfo.email, userInfo.savePassword, userInfo.loginSuccess, userInfo.promoter, userInfo.unpaidCount, userInfo.realName];
        [db executeUpdate:sqlstr];
    }
    [db close];
    return true;
}

- (void)deleteUserInfo {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'UserInfo' "];
    DLog(@"querySql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];
    if (bRet) {
        DLog(@"删除UserInfo");
    }

}

- (void)saveBankCardListData:(NSArray *)bankArr {
    if (!bankArr) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'BankCardListTable' "];
    NSString *deleteServiceCardList = [NSString stringWithFormat:@"Delete FROM 'ServiceCardListTable' "];
    [db executeUpdate: deleteServiceCardList];
    DLog(@"querySql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (bRet) {
        for (BankCardListDataModel *cardModel in bankArr) {
            NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'BankCardListTable' (dataType, bankName, cardLastNum, debt, minPay, creditLine,integral, period, deadLine, cdTime, payStatus, partPayNum, cardId, billDate, serviceCycle, endTime, serviceId, serviceType, serviceStatus) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') ", cardModel.dataType, cardModel.bankName, cardModel.cardLastNum, cardModel.debt, cardModel.minPay, cardModel.creditLine, cardModel.integral, cardModel.period, cardModel.deadLine, cardModel.cdTime, cardModel.payStatus, cardModel.partPayNum, cardModel.cardId, cardModel.billDate, cardModel.serviceCycle, cardModel.endTime, cardModel.serviceId, cardModel.serviceType, cardModel.serviceStatus];
            [db executeUpdate:sqlstr];
            if ([cardModel.dataType isEqualToString:@"2"]) {//增值服务
                [self saveServiceCardListWithDBHandler:db andCardList:cardModel.serviceCardList];
            }
        }
    }else
    {
        DLog(@"数据删除失败");
    }
    
    [db close];
}

- (NSMutableArray *)queryBankCardListData{
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *cardListData = [[NSMutableArray alloc] init];
    
    FMResultSet* result = [db executeQuery:@"Select * from 'BankCardListTable' "];
    while ([result next]) {
        BankCardListDataModel *cardData = [[BankCardListDataModel alloc] init];
        cardData.dataType = [result stringForColumn:@"dataType"];
        cardData.bankName = [result stringForColumn:@"bankName"];
        cardData.cardLastNum = [result stringForColumn:@"cardLastNum"];
        cardData.debt = [result stringForColumn:@"debt"];
        cardData.minPay = [result stringForColumn:@"minPay"];
        cardData.creditLine = [result stringForColumn:@"creditLine"];
        cardData.integral = [result stringForColumn:@"integral"];
        cardData.period = [result stringForColumn:@"period"];
        cardData.deadLine = [result stringForColumn:@"deadLine"];
        cardData.cdTime = [result stringForColumn:@"cdTime"];
        cardData.payStatus = [result stringForColumn:@"payStatus"];
        cardData.partPayNum = [result stringForColumn:@"partPayNum"];
        cardData.cardId = [result stringForColumn:@"cardId"];
        cardData.billDate = [result stringForColumn:@"billDate"];
        cardData.serviceCycle = [result stringForColumn:@"serviceCycle"];
        cardData.endTime = [result stringForColumn:@"endTime"];
        cardData.serviceId = [result stringForColumn:@"serviceId"];
        cardData.serviceType = [result stringForColumn:@"serviceType"];
        cardData.serviceStatus = [result stringForColumn:@"serviceStatus"];
        [cardListData addObject:cardData];
    }
    
    for (BankCardListDataModel *cardData in cardListData) {
        cardData.serviceCardList = [self queryServiceCardListDataWithDBHandler:db andServiceId:cardData.serviceId];
    }
    
    [db close];
    return cardListData;
}


- (void)updateBankCardListData:(BankCardListDataModel*)bankCardListData {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString *sqlstr = [NSString stringWithFormat:@"UPDATE 'BankCardListTable' SET dataType = '%@', debt = '%@', minPay = '%@', creditLine = '%@', integral = '%@', period = '%@', deadLine = '%@', cdTime = '%@', payStatus = '%@', partPayNum = '%@', cardId = '%@', billDate = '%@', serviceCycle = '%@', endTime = '%@', serviceId = '%@', serviceType = '%@', serviceStatus = '%@'  WHERE bankName = '%@' AND cardLastNum = '%@' ", bankCardListData.dataType, bankCardListData.debt, bankCardListData.minPay, bankCardListData.creditLine, bankCardListData.integral, bankCardListData.period, bankCardListData.deadLine, bankCardListData.cdTime, bankCardListData.payStatus, bankCardListData.partPayNum, bankCardListData.cardId, bankCardListData.billDate, bankCardListData.serviceCycle, bankCardListData.endTime, bankCardListData.serviceId, bankCardListData.serviceType, bankCardListData.serviceStatus, bankCardListData.bankName, bankCardListData.cardLastNum];
    BOOL bret = [db executeUpdate: sqlstr];
    if (bret) {
        DLog(@"数据更新成功");
    }else {
        DLog(@"数据更新失败");
    }
    [db close];
}

- (void)saveServiceCardList:(NSArray *)cardList {
    if (!cardList) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    [self saveServiceCardListWithDBHandler:db andCardList:cardList];
    [db close];
}

- (void)saveServiceCardListWithDBHandler:(FMDatabase *)db andCardList:(NSArray *)cardList {
    for (ServiceCardListDataModel *cardData in cardList) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'ServiceCardListTable' (cardNumber, bankName, serviceId) VALUES ('%@', '%@', '%@') ", cardData.cardNumber, cardData.bankName, cardData.serviceId];
        [db executeUpdate:sqlstr];
    }
}

- (NSMutableArray *)queryServiceCardListDataWithServiceId:(NSString *)serviceId{
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *serviceCardListData = [self queryServiceCardListDataWithDBHandler:db andServiceId:serviceId];
       [db close];
    return serviceCardListData;
}

- (NSMutableArray *)queryServiceCardListDataWithDBHandler:(FMDatabase *)db andServiceId:(NSString *)serviceId {
    NSMutableArray *serviceCardListData = [[NSMutableArray alloc] init];
    NSString *sqlstr = [NSString stringWithFormat:@"Select * from 'ServiceCardListTable' WHERE serviceId = '%@' ", serviceId];
    FMResultSet* result = [db executeQuery:sqlstr];
    while ([result next]) {
        ServiceCardListDataModel *serviceCardData = [[ServiceCardListDataModel alloc] init];
        serviceCardData.cardNumber = [result stringForColumn:@"cardNumber"];
        serviceCardData.bankName = [result stringForColumn:@"bankName"];
        serviceCardData.serviceId = [result stringForColumn:@"serviceId"];
        [serviceCardListData addObject:serviceCardData];
    }
    return serviceCardListData;
}


- (void)saveBillInfoData:(NSArray *)billArr withCardId:(NSString *)cardId {
    if (!billArr) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    
    db.shouldCacheStatements = YES;
    //保存新数据前删除旧数据
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'BillInfoDataTable' WHERE cardId = '%@' ", cardId];
    DLog(@"querySql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (!bRet)
    {
        DLog(@"BillInfoDataTable 数据删除失败");
    }
//
    for (BillInfoDataModel *billData in billArr) {
            NSString *deleteServiceCardList = [NSString stringWithFormat:@"Delete FROM 'BillDetailDataTable' WHERE billId = '%@' ",billData.billId];
        [db executeUpdate: deleteServiceCardList];
    }
    
    for (BillInfoDataModel *billModel in billArr) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'BillInfoDataTable' (period, integral, newlyGainedIntegral, debt, repayment, billId, cardId ) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@') ", billModel.period, billModel.integral, billModel.newlyGainedIntegral, billModel.debt, billModel.repayment , billModel.billId, billModel.cardId];
        
        BOOL bRet = [db executeUpdate:sqlstr];
        if (bRet) {
            DLog(@"BillInfoDataModel 插入数据成功");
        }else{
            DLog(@"BillInfoDataModel 插入数据失败");
        }
        //账单详情
        [self saveBillDetailsListWithDBHandler:db andBillDetails:billModel.details andBillId:billModel.billId];
    }
    [db close];
}
- (NSMutableArray *)queryBillInfoDataWithCardId:(NSString *)cardId {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *billInfoListData = [[NSMutableArray alloc] init];
    NSString *querySql = [NSString stringWithFormat:@"Select * from 'BillInfoDataTable' WHERE cardId = '%@'", cardId];
    FMResultSet* result = [db executeQuery:querySql];
    /*
     @property (nonatomic, strong) NSString *period;
     @property (nonatomic, strong) NSString *integral;
     @property (nonatomic, strong) NSString *newlyGainedIntegral;
     @property (nonatomic, strong) NSString *debt;
     @property (nonatomic, strong) NSString *repayment;
     @property (nonatomic, strong) NSString *billId;
     @property (nonatomic, strong) NSString *cardId;
     @property (nonatomic, strong) NSMutableArray *details;
     */
    while ([result next]) {
        BillInfoDataModel *billdData = [[BillInfoDataModel alloc] init];
        billdData.period = [result stringForColumn:@"period"];
        billdData.integral = [result stringForColumn:@"integral"];
        billdData.newlyGainedIntegral = [result stringForColumn:@"newlyGainedIntegral"];
        billdData.debt = [result stringForColumn:@"debt"];
        billdData.billId = [result stringForColumn:@"billId"];
        billdData.cardId = [result stringForColumn:@"cardId"];
        billdData.repayment = [result stringForColumn:@"repayment"];
        [billInfoListData addObject:billdData];
    }
    
    for (BillInfoDataModel *billData in billInfoListData    ) {
        billData.details = [self queryBillDetailsListDataWithDBHandler:db andBillId:billData.billId];
    }
    
    [db close];
    return billInfoListData;
}


- (void)saveBillDetailsData:(NSArray *)billDetails withBillId:(NSString *)billId{
    if (!billDetails) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    [self saveBillDetailsListWithDBHandler:db andBillDetails:billDetails andBillId:billId];
    [db close];
}

- (void)saveBillDetailsListWithDBHandler:(FMDatabase *)db andBillDetails:(NSArray *)billDetails andBillId:(NSString *)billId {
    for ( BillDetailDataModel *billData in billDetails) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'BillDetailDataTable' (amount, currency, billDescription, postedDate, billId) VALUES ('%@', '%@', '%@', '%@', '%@') ", billData.amount, billData.currency, billData.billDescription, billData.postedDate, billData.billId];
        [db executeUpdate:sqlstr];
    }
}

- (NSMutableArray *)queryBillDetailsListDataWithBillId:(NSString *)billId{
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *billDetailListData = [self queryBillDetailsListDataWithDBHandler:db andBillId:billId];
    [db close];
    return billDetailListData;
}


/*
 @property (nonatomic, strong) NSString *amount;
 @property (nonatomic, strong) NSString *currency;
 @property (nonatomic, strong) NSString *billDescription;
 @property (nonatomic, strong) NSString *postedDate;//格式 1128 11月28日//消费日期
 @property (nonatomic, strong) NSString *billId;
 */
- (NSMutableArray *)queryBillDetailsListDataWithDBHandler:(FMDatabase *)db andBillId:(NSString *)billId {
    NSMutableArray *billDetailListData = [[NSMutableArray alloc] init];
    NSString *sqlstr = [NSString stringWithFormat:@"Select * from 'BillDetailDataTable' WHERE billId = '%@' ", billId];
    FMResultSet* result = [db executeQuery:sqlstr];
    while ([result next]) {
        BillDetailDataModel *billDetailData = [[BillDetailDataModel alloc] init];
        billDetailData.amount = [result stringForColumn:@"amount"];
        billDetailData.currency = [result stringForColumn:@"currency"];
        billDetailData.billDescription = [result stringForColumn:@"billDescription"];
        billDetailData.postedDate = [result stringForColumn:@"postedDate"];
        billDetailData.billId = [result stringForColumn:@"billId"];
        [billDetailListData addObject:billDetailData];
    }
    return billDetailListData;
}

/**
 *  保存增值服务类型信息
 *
 *  @param serviceTypeData 增值服务数组
 */
- (void)saveServiceTypeData:(NSArray *)serviceTypeData {
    if (!serviceTypeData) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'ServiceTypeDataTable' "];
//    DLog(@"deleteSql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (!bRet)
    {
        DLog(@"数据删除失败");
    }
    for (ServiceTypeDataModel *serviceModel in serviceTypeData) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'ServiceTypeDataTable' (serviceCycle, servicePrice, serviceType, serviceRemark, serviceName, serviceId ) VALUES ('%@', '%@', '%@', '%@', '%@', '%@') ", serviceModel.serviceCycle, serviceModel.servicePrice, serviceModel.serviceType, serviceModel.serviceRemark, serviceModel.serviceName, serviceModel.serviceId];
//        DLog(@"sqlstr = %@", sqlstr);
        [db executeUpdate:sqlstr];
    }
    [db close];
}

/*
 @property (nonatomic, strong) NSString *serviceCycle;
 @property (nonatomic, strong) NSString *servicePrice;
 @property (nonatomic, strong) NSString *serviceType;
 @property (nonatomic, strong) NSString *serviceRemark;
 @property (nonatomic, strong) NSString *serviceName;
 @property (nonatomic, strong) NSString *serviceId;
 */
- (NSMutableArray *)queryServiceTypeData {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *serviceTypeDataList = [[NSMutableArray alloc] init];
    NSString *sqlstr = [NSString stringWithFormat:@"Select * from 'ServiceTypeDataTable' "];
    FMResultSet* result = [db executeQuery:sqlstr];
    while ([result next]) {
        ServiceTypeDataModel *serviceData = [[ServiceTypeDataModel alloc] init];
        serviceData.serviceCycle = [result stringForColumn:@"serviceCycle"];
        serviceData.servicePrice = [result stringForColumn:@"servicePrice"];
        serviceData.serviceType = [result stringForColumn:@"serviceType"];
        serviceData.serviceRemark = [result stringForColumn:@"serviceRemark"];
        serviceData.serviceName = [result stringForColumn:@"serviceName"];
        serviceData.serviceId = [result stringForColumn:@"serviceId"];
        [serviceTypeDataList addObject:serviceData];
    }
    [db close];
    return serviceTypeDataList;
}

/**
 *  保存广告数据
 *
 *  @param adDataArr 广告数据数组
 */

- (void)saveAdData:(NSArray *)adDataArr {
    if (!adDataArr) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'AdDataTable' "];
    DLog(@"deleteSql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (!bRet)
    {
        DLog(@"AdDataTable 数据删除失败");
    }
    for (AdDataModel *adModel in adDataArr) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'AdDataTable' (imageUrlStr, name, content, url) VALUES ('%@', '%@', '%@', '%@') ", adModel.imageUrlStr, adModel.name, adModel.content, adModel.url];
        DLog(@"sqlstr = %@", sqlstr);
        [db executeUpdate:sqlstr];
    }
    [db close];
}

/**
 *  查询广告数据
 *
 *  @return 返回广告数据数组
 */
- (NSMutableArray *)queryAdData {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *adDataList = [[NSMutableArray alloc] init];
    NSString *sqlstr = [NSString stringWithFormat:@"Select * from 'AdDataTable' "];
    FMResultSet* result = [db executeQuery:sqlstr];
    while ([result next]) {
        AdDataModel *adModel = [[AdDataModel alloc] init];
        adModel.imageUrlStr = [result stringForColumn:@"imageUrlStr"];
        adModel.url = [result stringForColumn:@"url"];
        adModel.content = [result stringForColumn:@"content"];
        adModel.name = [result stringForColumn:@"name"];
        [adDataList addObject:adModel];
    }
    [db close];
    return adDataList;
}


- (void)saveAllPaidService:(NSArray *)allService {
    if (!allService) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'AllServiceTable' "];
    DLog(@"deleteSql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (!bRet)
    {
        DLog(@"AllServiceTable 数据删除失败");
    }
    for (BankCardListDataModel *serviceModel in allService) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'AllServiceTable' (bankName, period, deadLine, serviceCycle, endTime, serviceId, serviceType, serviceStatus) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@') ", serviceModel.bankName, serviceModel.period, serviceModel.deadLine, serviceModel.serviceCycle, serviceModel.endTime, serviceModel.serviceId, serviceModel.serviceType, serviceModel.serviceStatus];
        DLog(@"sqlstr = %@", sqlstr);
        [db executeUpdate:sqlstr];
        [self saveServiceCardListWithDBHandler:db andCardList:serviceModel.serviceCardList];
    }
    
    
    [db close];
}

- (NSMutableArray *)queryAllPaidService {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *allPaidServiceList = [[NSMutableArray alloc] init];
    NSString *sqlstr = [NSString stringWithFormat:@"Select * from 'AllServiceTable' "];
    FMResultSet* result = [db executeQuery:sqlstr];
    while ([result next]) {
        BankCardListDataModel *serviceModel = [[BankCardListDataModel alloc] init];
        serviceModel.bankName = [result stringForColumn:@"bankName"];
        serviceModel.period = [result stringForColumn:@"period"];
        serviceModel.deadLine = [result stringForColumn:@"deadLine"];
        serviceModel.serviceCycle = [result stringForColumn:@"serviceCycle"];
        serviceModel.endTime = [result stringForColumn:@"endTime"];
        serviceModel.serviceId = [result stringForColumn:@"serviceId"];
        serviceModel.serviceType = [result stringForColumn:@"serviceType"];
        serviceModel.serviceStatus = [result stringForColumn:@"serviceStatus"];
        [allPaidServiceList addObject:serviceModel];
    }
    
    for (BankCardListDataModel *serviceModel in allPaidServiceList) {
        serviceModel.serviceCardList = [self queryServiceCardListDataWithDBHandler:db andServiceId:serviceModel.serviceId];
    }
    [db close];
    return allPaidServiceList;
}


- (void)saveIncomeDetail:(NSArray *)incomeData {
    if (!incomeData) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'IncomeDetailTable' "];
    DLog(@"deleteSql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (!bRet)
    {
        DLog(@"IncomeDetailTable 数据删除失败");
    }
    for (IncomeDetail *incomeModel in incomeData) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'IncomeDetailTable' (customerName, date, count) VALUES ('%@', '%@', '%@') ", incomeModel.customerName, incomeModel.date, incomeModel.count];
        DLog(@"sqlstr = %@", sqlstr);
        [db executeUpdate:sqlstr];
    }
    
    [db close];
}
- (NSMutableArray *)queryIncomeDetail {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *incomeDetailList = [[NSMutableArray alloc] init];
    NSString *sqlstr = [NSString stringWithFormat:@"Select * from 'IncomeDetailTable' "];
    FMResultSet* result = [db executeQuery:sqlstr];
    while ([result next]) {
        IncomeDetail *incomeModel = [[IncomeDetail alloc] init];
        incomeModel.customerName = [result stringForColumn:@"customerName"];
        incomeModel.date = [result stringForColumn:@"date"];
        incomeModel.count = [result stringForColumn:@"count"];
        [incomeDetailList addObject:incomeModel];
    }
    [db close];
    return incomeDetailList;
}

- (void)saveWithdrawDetail:(NSArray *)withDrawData {
    if (!withDrawData) {
        return;
    }
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return;
    }
    db.shouldCacheStatements = YES;
    NSString* deleteSql = [NSString stringWithFormat:@"Delete FROM 'WithdrawDetailTable' "];
    DLog(@"deleteSql = %@", deleteSql);
    BOOL bRet = [db executeUpdate: deleteSql];//?如果表是空的
    if (!bRet)
    {
        DLog(@"WithdrawDetailTable 数据删除失败");
    }
    for (WithdrawDetail *withDrawModel in withDrawData) {
        NSString *sqlstr = [NSString stringWithFormat:@"INSERT INTO 'WithdrawDetailTable' (date, count) VALUES ('%@', '%@') ", withDrawModel.date, withDrawModel.count];
        DLog(@"sqlstr = %@", sqlstr);
        [db executeUpdate:sqlstr];
    }
    [db close];
}

- (NSMutableArray *)queryWithdrawDetail {
    FMDatabase* db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@%@",PATH_OF_DOCUMENT, _dbPath]];
    if (![db open]) {
        DLog(@"打开数据库失败");
        return NULL;
    }
    NSMutableArray *withdrawModelList = [[NSMutableArray alloc] init];
    NSString *sqlstr = [NSString stringWithFormat:@"Select * from 'WithdrawDetailTable' "];
    FMResultSet* result = [db executeQuery:sqlstr];
    while ([result next]) {
        WithdrawDetail *withdrawModel = [[WithdrawDetail alloc] init];
        withdrawModel.date = [result stringForColumn:@"date"];
        withdrawModel.count = [result stringForColumn:@"count"];
        [withdrawModelList addObject:withdrawModel];
    }
    [db close];
    return withdrawModelList;
}

@end
