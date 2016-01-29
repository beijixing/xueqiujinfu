//
//  ValueAddedVC.m
//  JinFu
//
//  Created by 郑光龙 on 15/12/20.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "ValueAddedVC.h"
#import "ProtectionCardCell.h"
#import "ProtectionCardCell4Phone6.h"
#import "AFNetworking.h"
#import "AddLostCardProtectionInfoVC.h"
#import "AddPhoneServiceInfoVC.h"
#import "AddPosInfoVC.h"
#import "AddProtectionInfoVC.h"
#import "LostCompensateViewController.h"
#import "ServiceNotPassInfoVC.h"
#import "StolenPayViewController.h"
#import "MBProgressHUD.h"
#import "ServiceCardListDataModel.h"
#import "ServiceTypeDataModel.h"
#import "BankCardListDataModel.h"
#import "DBManager.h"
#import "AFNetworkReachabilityManager.h"
@interface ValueAddedVC ()
@end

@implementation ValueAddedVC
{

    NSMutableArray *_serviceList;
    NSMutableArray *_addedServiceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _addedServiceArr = [[DBManager sharedDBManager] queryServiceTypeData];
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        _serviceList = [[DBManager sharedDBManager] queryAllPaidService];
    }else {
        [self requestData];
    }
    self.valueAddedServiceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //定制返回按钮
    UIBarButtonItem *blackItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = blackItem;
    //返回按钮白色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];//用于返回按钮
    self.navigationItem.title = @"增值服务";
}

//时间处理
-(NSString *)timeToStr:(NSString *)timestep{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:[timestep intValue]];
    NSString *day = [dateFormatter stringFromDate:theday];
    return day;
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.valueAddedServiceTable animated:YES];
    NSString * URL = [HostUrl stringByAppendingString:GetBuyServiceList];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self finishedDownloadData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
    }];
}
- (void)finishedDownloadData:(NSData *)data
{
    _serviceList = [[NSMutableArray alloc] init];
    NSArray *tempDataAtrr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dataDict in tempDataAtrr) {
        DLog(@"dataDict = %@", dataDict);
        BankCardListDataModel *serviceModel = [[BankCardListDataModel alloc] init];
        NSDictionary *buyService = [dataDict objectForKey:@"buyService"];
        serviceModel.paidState = [dataDict objectForKey:@"paid"];
        serviceModel.bankName = [NSString stringWithFormat:@"%@", [buyService objectForKey:@"name"]];
        serviceModel.deadLine = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"deadLine"]];
        serviceModel.serviceCycle = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"serviceCycle"]];
        serviceModel.serviceId = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"id"]];
        //endtime
        NSTimeInterval timeInterval = [[dataDict objectForKey:@"endTime"][@"time"] integerValue]/1000;
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
        NSString *tmpEndTime = [NSString stringWithFormat:@"%@", [date description]];
        NSMutableString *endTime = [NSMutableString stringWithString:tmpEndTime];
        [endTime replaceOccurrencesOfString:@"-" withString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(0, endTime.length)];
        serviceModel.endTime = [endTime substringWithRange:NSMakeRange(0, 10)];
        
        //start time
        NSTimeInterval stTimeInterval = [[dataDict objectForKey:@"startTime"][@"time"] integerValue]/1000;
        NSDate *stDate = [[NSDate alloc] initWithTimeIntervalSince1970:stTimeInterval];
        NSString *tmpStTime = [NSString stringWithFormat:@"%@", [stDate description]];
        NSMutableString *stTime = [NSMutableString stringWithString:tmpStTime];
        [stTime replaceOccurrencesOfString:@"-" withString:@"." options:NSCaseInsensitiveSearch range:NSMakeRange(0, stTime.length)];
        
       serviceModel.period = [NSString stringWithFormat:@"%@-%@", [stTime substringWithRange:NSMakeRange(0, 10)], [endTime substringWithRange:NSMakeRange(0, 10)]];
        
        serviceModel.serviceType = [NSString stringWithFormat:@"%@", [buyService objectForKey:@"type"]];
        serviceModel.serviceStatus = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"status"]];
        serviceModel.serviceProcess = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"conue"]];
        serviceModel.remark = [NSString stringWithFormat:@"%@", [buyService objectForKey:@"remark"]];
        
        //    NSDictionary *addService = [buyService objectForKey:@"addService"];
        DLog(@"dataDict= %@", dataDict);
        NSArray *cards = [dataDict objectForKey:@"cardList"];
        if (![cards isKindOfClass:[NSNull class]]) {
            NSMutableArray *serviceCardList = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in cards) {
                ServiceCardListDataModel *serviceCardModel = [[ServiceCardListDataModel alloc] init];
                serviceCardModel.bankName = [dict objectForKey:@"bankName"];
                serviceCardModel.cardNumber = [dict objectForKey:@"cardId"];
                serviceCardModel.serviceId = [dataDict objectForKey:@"id"];
                [serviceCardList addObject:serviceCardModel];
            }
            serviceModel.serviceCardList = serviceCardList;
        }
        serviceModel.serviceInfo = [self getServiceInfoModel:dataDict];
        [_serviceList addObject:serviceModel];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DBManager sharedDBManager] saveAllPaidService:_serviceList];
    });
    [MBProgressHUD hideAllHUDsForView:self.valueAddedServiceTable animated:YES];
    [self.valueAddedServiceTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _serviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (MainScreenWidth > 320) {
        static NSString *cellName = @"ProtectionCardCell4Phone6";
        ProtectionCardCell4Phone6 *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionCardCell4Phone6" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        static NSString *cellName = @"ProtectionCardCell";
        ProtectionCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionCardCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardListDataModel *serviceModel = _serviceList[indexPath.row];
    if (MainScreenWidth > 320) {
        ProtectionCardCell4Phone6 *showCell = (ProtectionCardCell4Phone6*)cell;
        [self setProtectionCardCellInfo4Phone6:showCell data:serviceModel];
        [self setServiceIcon4Phone6:showCell serviceModel:serviceModel];
        [self setOperationButtonState4Phone6:showCell serviceModel:serviceModel];
    }else {
        ProtectionCardCell *showCell = (ProtectionCardCell *)cell;
        [self setProtectionCardCellInfo:showCell data:serviceModel];
        [self setServiceIcon:showCell serviceModel:serviceModel];
        [self setOperationButtonState:showCell serviceModel:serviceModel];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MainScreenWidth > 320) {
        return 214;
    }else{
        return 183;
    }
}

- (void)setProtectionCardCellInfo:(ProtectionCardCell*)showCell data:(BankCardListDataModel *)serviceModel {
    [showCell setCardsInfo:serviceModel.serviceCardList];
    showCell.servicePeriod.text = [NSString stringWithFormat:@"%@",serviceModel.period];
    showCell.title.text = [NSString stringWithFormat:@"%@",serviceModel.bankName];
    showCell.servicePeriod.text =  [NSString stringWithFormat:@"%@", serviceModel.serviceCycle];
    NSMutableString *deadLine = [NSMutableString stringWithString:serviceModel.endTime];
    [deadLine replaceOccurrencesOfString:@"-" withString:@"." options:NSWidthInsensitiveSearch range:NSMakeRange(0,10)];
    showCell.endTime.text = [NSString stringWithFormat:@"服务截止日期%@", [deadLine substringWithRange:NSMakeRange(5, 5)]];
     showCell.serviceStartAndEndTime.text = [NSString stringWithFormat:@"%@", serviceModel.period];
    
    
    NSString *dateNowStr = [ToolBox getDateStringWithDate:[[NSDate date] description] dateFormat:@"yyyy-MM-dd HH:mm:ss z" destFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *dateTimeEndStr = [ToolBox getDateStringWithDate:serviceModel.endTime dateFormat:@"yyyy.MM.dd" destFormat:@"yyyy.MM.dd HH:mm:ss"];;
    NSString *cdTimeStr = [ToolBox getDaysBetweenEndDate:[NSMutableString stringWithString:dateTimeEndStr] andStartDate:dateNowStr withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
   
    showCell.CDTime.text = [NSString stringWithFormat:@"%@", cdTimeStr];
    
    
    showCell.buyService = ^(){
        DLog(@"buyService ");
        if (![self checkNetState]) {
            return ;
        }
        [self buyService:serviceModel];
        
    };
    showCell.operationEvevnt = ^(){
        DLog(@"operation");
        //未通过审核要重新编辑提交的信息
        if ([serviceModel.serviceStatus integerValue] == 2) {
            [self reeditCommitInfomation:serviceModel];
        }
    };

}

- (void)setOperationButtonState:(ProtectionCardCell *)showCell serviceModel:(BankCardListDataModel *)serviceModel  {
    if ([serviceModel.serviceStatus intValue] == 0) {
        [showCell.operationButton setTitle:@"待审核" forState:UIControlStateNormal];
        [showCell.operationButton setBackgroundImage:[UIImage imageNamed:@"payStateBg2@2x.png"] forState:UIControlStateNormal];
        [showCell.operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [showCell.buyServiceButton setBackgroundColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
        showCell.buyServiceButton.enabled = NO;
    }else if ([serviceModel.serviceStatus integerValue] ==1) {
        [showCell.operationButton setTitle:@"申请赔付" forState:UIControlStateNormal];
        [showCell.operationButton setBackgroundImage:[UIImage imageNamed:@"payStateBg1@2x.png"] forState:UIControlStateNormal];
        showCell.askPay = ^(){
            if ([serviceModel.serviceType intValue] == 1) {
                LostCompensateViewController * lostVC = [[LostCompensateViewController alloc]init];
                [self.navigationController pushViewController:lostVC animated:YES];
            }else if ([serviceModel.serviceType intValue] == 2) {
                StolenPayViewController * slVC = [[StolenPayViewController alloc]init];
                [self.navigationController pushViewController:slVC animated:YES];
            }
        };
        //电话服务
        if ([serviceModel.serviceType intValue] == 3 || [serviceModel.serviceType intValue] == 4) {
            showCell.operationButton.hidden = YES;
            showCell.imageViewLine.hidden = YES;
            
            //pos服务不能续买
            if ([serviceModel.serviceType intValue] == 4) {
                [showCell.buyServiceButton setBackgroundColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
                showCell.buyServiceButton.enabled = NO;
            }
        }
    }else if ([serviceModel.serviceStatus integerValue] == 2) {
        [showCell.operationButton setTitle:@"未通过" forState:UIControlStateNormal];
        [showCell.operationButton setBackgroundImage:[UIImage imageNamed:@"payStateBg0@2x.png"] forState:UIControlStateNormal];
        [showCell.buyServiceButton setBackgroundColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
        showCell.buyServiceButton.enabled = NO;
    }
    
}


- (void)setServiceIcon:(ProtectionCardCell *)showCell serviceModel:(BankCardListDataModel *)serviceModel {
    if ([serviceModel.serviceType integerValue]== 1) {
        [showCell.icon setImage:ImageName(@"diu-ka-bao-zhang@2x.png")];
        
    }else if([serviceModel.serviceType integerValue]== 2) {
        [showCell.icon setImage:ImageName(@"dao-shua-bao-zhang-")];
    }
    else if([serviceModel.serviceType integerValue]== 3) {
        [showCell.icon setImage:ImageName(@"iconfont-phoneService")];
    }
    else if([serviceModel.serviceType integerValue]== 4) {
        [showCell.icon setImage:ImageName(@"pos-anniu")];
    }
}


- (void)setProtectionCardCellInfo4Phone6:(ProtectionCardCell4Phone6*)showCell data:(BankCardListDataModel *)serviceModel {
    [showCell setCardsInfo:serviceModel.serviceCardList];
    showCell.servicePeriod.text = [NSString stringWithFormat:@"%@",serviceModel.period];
    showCell.title.text = [NSString stringWithFormat:@"%@",serviceModel.bankName];
    showCell.servicePeriod.text =  [NSString stringWithFormat:@"%@", serviceModel.serviceCycle];
    NSMutableString *deadLine = [NSMutableString stringWithString:serviceModel.endTime];
    [deadLine replaceOccurrencesOfString:@"-" withString:@"." options:NSWidthInsensitiveSearch range:NSMakeRange(0,10)];
    showCell.endTime.text = [NSString stringWithFormat:@"服务截止日期%@", [deadLine substringWithRange:NSMakeRange(5, 5)]];
    showCell.serviceStartAndEndTime.text = [NSString stringWithFormat:@"%@", serviceModel.period];

    
    NSString *dateNowStr = [ToolBox getDateStringWithDate:[[NSDate date] description] dateFormat:@"yyyy-MM-dd HH:mm:ss z" destFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *dateTimeEndStr = [ToolBox getDateStringWithDate:serviceModel.endTime dateFormat:@"yyyy.MM.dd" destFormat:@"yyyy.MM.dd HH:mm:ss"];;
    NSString *cdTimeStr = [ToolBox getDaysBetweenEndDate:[NSMutableString stringWithString:dateTimeEndStr] andStartDate:dateNowStr withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    showCell.CDTime.text = [NSString stringWithFormat:@"%@", cdTimeStr];
    
    showCell.buyService = ^(){
        DLog(@"buyService ");
        if (![self checkNetState]) {
            return ;
        }
        [self buyService:serviceModel];
        
    };
    showCell.operationEvevnt = ^(){
        DLog(@"operation");
        //未通过审核要重新编辑提交的信息
        if ([serviceModel.serviceStatus integerValue] == 2) {
            [self reeditCommitInfomation:serviceModel];
        }
    };
    
}

- (void)setOperationButtonState4Phone6:(ProtectionCardCell4Phone6 *)showCell serviceModel:(BankCardListDataModel *)serviceModel  {
    if ([serviceModel.serviceStatus intValue] == 0) {
        [showCell.operationButton setTitle:@"待审核" forState:UIControlStateNormal];
        [showCell.operationButton setBackgroundImage:[UIImage imageNamed:@"payStateBg2@2x.png"] forState:UIControlStateNormal];
        [showCell.operationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [showCell.buyServiceButton setBackgroundColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
        showCell.buyServiceButton.enabled = NO;
    }else if ([serviceModel.serviceStatus integerValue] ==1) {
        [showCell.operationButton setTitle:@"申请赔付" forState:UIControlStateNormal];
        [showCell.operationButton setBackgroundImage:[UIImage imageNamed:@"payStateBg1@2x.png"] forState:UIControlStateNormal];
        showCell.askPay = ^(){
            if ([serviceModel.serviceType intValue] == 1) {
                LostCompensateViewController * lostVC = [[LostCompensateViewController alloc]init];
                [self.navigationController pushViewController:lostVC animated:YES];
            }else if ([serviceModel.serviceType intValue] == 2) {
                StolenPayViewController * slVC = [[StolenPayViewController alloc]init];
                [self.navigationController pushViewController:slVC animated:YES];
            }
        };
        //电话服务
        if ([serviceModel.serviceType intValue] == 3 || [serviceModel.serviceType intValue] == 4) {
            showCell.operationButton.hidden = YES;
            showCell.imageViewLine.hidden = YES;
            
            //pos服务不能续买
            if ([serviceModel.serviceType intValue] == 4) {
                [showCell.buyServiceButton setBackgroundColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
                showCell.buyServiceButton.enabled = NO;
            }
        }
    }else if ([serviceModel.serviceStatus integerValue] == 2) {
        [showCell.operationButton setTitle:@"未通过" forState:UIControlStateNormal];
        [showCell.operationButton setBackgroundImage:[UIImage imageNamed:@"payStateBg0@2x.png"] forState:UIControlStateNormal];
        [showCell.buyServiceButton setBackgroundColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
        showCell.buyServiceButton.enabled = NO;
    }
    
}

- (void)setServiceIcon4Phone6:(ProtectionCardCell4Phone6 *)showCell serviceModel:(BankCardListDataModel *)serviceModel {
    if ([serviceModel.serviceType integerValue]== 1) {
        [showCell.icon setImage:ImageName(@"diu-ka-bao-zhang@2x.png")];
        
    }else if([serviceModel.serviceType integerValue]== 2) {
        [showCell.icon setImage:ImageName(@"dao-shua-bao-zhang-")];
    }
    else if([serviceModel.serviceType integerValue]== 3) {
        [showCell.icon setImage:ImageName(@"iconfont-phoneService")];
    }
    else if([serviceModel.serviceType integerValue]== 4) {
        [showCell.icon setImage:ImageName(@"pos-anniu")];
    }
}



- (void)buyService:(BankCardListDataModel *)serviceModel {
    if ([serviceModel.serviceType intValue] == 1) {
        AddLostCardProtectionInfoVC *lostCardVc = [[AddLostCardProtectionInfoVC alloc] init];
        lostCardVc.serviceInfo = [self getServiceTypeModelByType:serviceModel.serviceType];
        lostCardVc.unauthorizedInfo = serviceModel.serviceInfo;
        lostCardVc.addedCardNumberCnt = [serviceModel.serviceCardList count]-1;
        lostCardVc.operationType = 1;
        [self.navigationController pushViewController:lostCardVc animated:YES];
    }else if ([serviceModel.serviceType intValue] == 2) {
        //盗刷保障
        AddProtectionInfoVC *protectionServiceVc = [[AddProtectionInfoVC alloc] init];
        protectionServiceVc.serviceInfo = [self getServiceTypeModelByType:serviceModel.serviceType];
        protectionServiceVc.unauthorizedInfo = serviceModel.serviceInfo;
        protectionServiceVc.addedCardNumberCnt = [serviceModel.serviceCardList count]-1;
        protectionServiceVc.operationType = 1;
        [self.navigationController pushViewController:protectionServiceVc animated:YES];
    }else if ([serviceModel.serviceType intValue] == 3) {
        //电话服务
        AddPhoneServiceInfoVC *phoneServiceVc = [[AddPhoneServiceInfoVC alloc] init];
        phoneServiceVc.serviceInfo = [self getServiceTypeModelByType:serviceModel.serviceType];
        phoneServiceVc.unauthorizedInfo = serviceModel.serviceInfo;
        phoneServiceVc.addedCardNumberCnt = [serviceModel.serviceCardList count]-1;
        phoneServiceVc.operationType = 1;
        [self.navigationController pushViewController:phoneServiceVc animated:YES];
    }else if ([serviceModel.serviceType intValue] == 4) {
        //POS服务
        AddPosInfoVC *posServiceVc = [[AddPosInfoVC alloc] init];
        posServiceVc.posInfo = [self getServiceTypeModelByType:serviceModel.serviceType];
        posServiceVc.unauthorizedInfo = serviceModel.serviceInfo;
        posServiceVc.operationType = 1;
        [self.navigationController pushViewController:posServiceVc animated:YES];
    }
}

//审核未通过
- (void)reeditCommitInfomation:(BankCardListDataModel *)serviceModel {
    if ([serviceModel.paidState isEqualToString:@"1"]) {
        [ToolBox showAlertInfo:@"服务已退款，请重新购买"];
        return;
    }
    
    ServiceNotPassInfoVC *notPassVc = [[ServiceNotPassInfoVC alloc] init];
    notPassVc.desc = serviceModel.remark;
    
    //第一次提交未审核通过
    if ([serviceModel.serviceProcess intValue] ==0) {
        notPassVc.operationType = 2;
    }else {
        //续保未审核通过
        notPassVc.operationType = 3;
    }
    
    notPassVc.serviceBaseData = [self getServiceTypeModelByType:serviceModel.serviceType];
    if ([serviceModel.serviceType intValue] == 1) {
        notPassVc.serviceInfo = serviceModel.serviceInfo;
        notPassVc.addedCardNumberCnt = [serviceModel.serviceCardList count]-1;
        notPassVc.serviceType = 1;
    }else if ([serviceModel.serviceType intValue] == 2) {
        //盗刷保障
        notPassVc.serviceInfo = serviceModel.serviceInfo;
        notPassVc.addedCardNumberCnt = [serviceModel.serviceCardList count]-1;
        notPassVc.serviceType = 2;
 
    }else if ([serviceModel.serviceType intValue] == 3) {
        //电话服务
        notPassVc.serviceInfo = serviceModel.serviceInfo;
        notPassVc.addedCardNumberCnt = [serviceModel.serviceCardList count]-1;
        notPassVc.serviceType = 3;
   
    }else if ([serviceModel.serviceType intValue] == 4) {
        //POS服务
        notPassVc.serviceInfo = serviceModel.serviceInfo;
        notPassVc.serviceType = 4;
    }
    
    [self.navigationController pushViewController:notPassVc animated:YES];
}

- (ServiceInfoModel *)getServiceInfoModel:(NSDictionary *)serviceDict {
    if ([serviceDict[@"buyService"][@"type"] intValue] == 1) {
        return [self getLostProtectionServiceInfoModel:serviceDict];
    }else if ([serviceDict[@"buyService"][@"type"] intValue] == 2) {
        return [self getProtectionServiceInfoModel:serviceDict];
    }else if ([serviceDict[@"buyService"][@"type"] intValue] == 3) {
        return [self getPhoneServiceInfoModel:serviceDict];
    }else if ([serviceDict[@"buyService"][@"type"] intValue] == 4) {
        return [self getPosServiceInfoModel:serviceDict];
    }
    return NULL;
}

- (ServiceInfoModel *)getPosServiceInfoModel:(NSDictionary *)serviceDict {
    ServiceInfoModel *serviceInfoModel = [[ServiceInfoModel alloc] init];
    serviceInfoModel.name = serviceDict[@"memberName"];
    serviceInfoModel.identityCard = serviceDict[@"identityCard"];
    serviceInfoModel.productId = serviceDict[@"id"];
    serviceInfoModel.phoneNumber = serviceDict[@"contact"];
    serviceInfoModel.posAddress = serviceDict[@"address"];
    return serviceInfoModel;
}

- (ServiceInfoModel *)getPhoneServiceInfoModel:(NSDictionary *)serviceDict {
    ServiceInfoModel *serviceInfoModel = [[ServiceInfoModel alloc] init];
    serviceInfoModel.name = serviceDict[@"memberName"];
    serviceInfoModel.identityCard = serviceDict[@"identityCard"];
    serviceInfoModel.productId = serviceDict[@"id"];
    serviceInfoModel.phoneNumber = serviceDict[@"contact"];
    NSArray *cardList = serviceDict[@"cardList"];
    for (int i = 0; i<[cardList count]; i++) {
        NSDictionary *cardDict = cardList[i];
        [serviceInfoModel.cardNumberArr replaceObjectAtIndex:i withObject:cardDict[@"cardId"]];
        [serviceInfoModel.billDateArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",cardDict[@"billTime"]]];
        [serviceInfoModel.bankNameArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",cardDict[@"bankName"]]];
    }
    return serviceInfoModel;
}

- (ServiceInfoModel *)getProtectionServiceInfoModel:(NSDictionary *)serviceDict {
    ServiceInfoModel *serviceInfoModel = [[ServiceInfoModel alloc] init];
    serviceInfoModel.name = serviceDict[@"memberName"];
    serviceInfoModel.identityCard = serviceDict[@"identityCard"];
    serviceInfoModel.productId = serviceDict[@"id"];
    serviceInfoModel.phoneNumber = serviceDict[@"contact"];
    NSArray *cardList = serviceDict[@"cardList"];
    for (int i = 0; i<[cardList count]; i++) {
        NSDictionary *cardDict = cardList[i];
        [serviceInfoModel.cardNumberArr replaceObjectAtIndex:i withObject:cardDict[@"cardId"]];
        [serviceInfoModel.billDateArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",cardDict[@"billTime"]]];
        [serviceInfoModel.bankNameArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",cardDict[@"bankName"]]];
    }
    
    NSArray *idcardList = serviceDict[@"idcardImgFile"];
    for (int i = 0; i< [idcardList count]; i++) {
        NSDictionary *dict = idcardList[i];
        NSMutableString *hostUrl = [NSMutableString stringWithString:HostUrl];
        NSString* realurl = [hostUrl substringToIndex:[hostUrl length]-1];
        NSString *imagePath = [NSString stringWithFormat:@"%@%@/%@",realurl, [dict objectForKey:@"path"], [dict objectForKey:@"name"]];
        DLog(@"imagePath = %@", imagePath);
        [serviceInfoModel.uploadedImagePathsArr replaceObjectAtIndex:i withObject:imagePath];
    }
    
    NSString *idcardImgs = [NSString stringWithFormat:@"%@", serviceDict[@"idcardImg"]] ;
    NSArray *imageIds = [idcardImgs componentsSeparatedByString:@","];
    for (int i = 0; i< [imageIds count]; i++ ) {
        NSString *imageId = imageIds[i];
        [serviceInfoModel.uploadImageIdsArr replaceObjectAtIndex:i withObject:imageId];
    }
    return serviceInfoModel;
}

- (ServiceInfoModel *)getLostProtectionServiceInfoModel:(NSDictionary *)serviceDict {
    ServiceInfoModel *serviceInfoModel = [[ServiceInfoModel alloc] init];
    serviceInfoModel.name = serviceDict[@"memberName"];
    serviceInfoModel.identityCard = serviceDict[@"identityCard"];
    serviceInfoModel.productId = serviceDict[@"id"];
    serviceInfoModel.phoneNumber = serviceDict[@"contact"];
    NSArray *cardList = serviceDict[@"cardList"];
    for (int i = 0; i<[cardList count]; i++) {
        NSDictionary *cardDict = cardList[i];
        [serviceInfoModel.cardNumberArr replaceObjectAtIndex:i withObject:cardDict[@"cardId"]];
        [serviceInfoModel.bankNameArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",cardDict[@"bankName"]]];
    }
    return serviceInfoModel;
}

- (ServiceTypeDataModel *)getServiceTypeModelByType:(NSString *)serviceType {
    ServiceTypeDataModel *serviceModel = nil;
    for (ServiceTypeDataModel *service in _addedServiceArr) {
        if ([service.serviceType isEqualToString:serviceType]) {
            serviceModel = service;
            break;
        }
    }
    return serviceModel;
}

- (BOOL)checkNetState {
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        return false;
    }else {
        return true;
    }
}

@end
