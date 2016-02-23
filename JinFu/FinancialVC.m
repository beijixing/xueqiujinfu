//
//  FinancialVC.m
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "FinancialVC.h"
#import "UnauthoProtectionVC.h"
#import "AFNetManager.h"
#import "POSVC.h"
#import "LostCardVC.h"
#import "PhoneServiceVC.h"
#import "ServiceTypeDataModel.h"
#import "DBManager.h"
#import "AFNetworkReachabilityManager.h"

@interface FinancialVC ()
{
    NSMutableArray *_addedServiceArr;
}
@end

@implementation FinancialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"金服";
 
    
//    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {//没有网络
        _addedServiceArr = [[DBManager sharedDBManager] queryServiceTypeData];
//    }else{
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddedServiceNotification:) name:GetAddedServiceList object:nil];
//        NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@", HostUrl, GetAddedServiceList];
//        [[AFNetManager sharedManager] postDataToServerWithHostUrl:fullUrlStr andParameters:nil andNotificationName:GetAddedServiceList];
//    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

-(void)getAddedServiceNotification:(NSNotification*)notification{
    
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetAddedServiceList object:nil];
    DLog(@"resultDic = %@", resultDic);
    
    _addedServiceArr = [[NSMutableArray alloc] init];
    NSArray *serviceDataArr = [resultDic objectForKey:@"responseObject"];
    for (NSDictionary *dataDict in serviceDataArr) {
        ServiceTypeDataModel *dataModel = [[ServiceTypeDataModel alloc] init];
        dataModel.serviceCycle = [dataDict objectForKey:@"serviceTime1"];
        dataModel.serviceId = [dataDict objectForKey:@"id"];
        dataModel.servicePrice = [dataDict objectForKey:@"serviceTime1Money"];
        dataModel.serviceRemark = [dataDict objectForKey:@"remark"];
        dataModel.serviceType = [dataDict objectForKey:@"type"];
        dataModel.serviceName = [dataDict objectForKey:@"name"];
        [_addedServiceArr addObject:dataModel];
    }
    [[DBManager sharedDBManager] saveServiceTypeData:_addedServiceArr];
}

- (IBAction)phoneRemindBtnClick:(UIButton *)sender {
    
    DLog(@"电话提醒 3");
    PhoneServiceVC *phoneServiceVc = [[PhoneServiceVC alloc] init];
    for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
        if ([serviceModel.serviceType isEqualToString:@"3"]) {
            phoneServiceVc.serviceInfo = serviceModel;
            break;
        }
    }
    
    [self.navigationController pushViewController:phoneServiceVc animated:YES];
}

- (IBAction)lostProtectionBtnClick:(UIButton *)sender {
    DLog(@"失卡保障1");
    LostCardVC *lostCardVc = [[LostCardVC alloc] init];
    
    for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
        if ([serviceModel.serviceType isEqualToString:@"1"]) {
            lostCardVc.serviceInfo = serviceModel;
            break;
        }
    }
    
    [self.navigationController pushViewController:lostCardVc animated:YES];
}
- (IBAction)unauthorizedChargeBtnClick:(UIButton *)sender {
    DLog(@"盗刷保障2 ");
    UnauthoProtectionVC *unAuthoVc = [[UnauthoProtectionVC alloc] init];
    for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
        if ([serviceModel.serviceType isEqualToString:@"2"]) {
            unAuthoVc.serviceInfo = serviceModel;
            break;
        }
    }
    [self.navigationController pushViewController:unAuthoVc animated:YES];
}

- (IBAction)posMachineBtnClick:(UIButton *)sender {
    DLog(@"POS机4");
    POSVC *posVc = [[POSVC alloc] init];
    for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
        if ([serviceModel.serviceType isEqualToString:@"4"]) {
            posVc.posInfo = serviceModel;
            break;
        }
    }
    [self.navigationController pushViewController:posVc animated:YES];
}
@end
