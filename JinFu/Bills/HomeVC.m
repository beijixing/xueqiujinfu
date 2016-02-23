//
//  HomeVCViewController.m
//  JinFu
//
//  Created by ybon on 15/12/16.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "HomeVC.h"
#import "LoginVC.h"
#import "BankCardCell.h"
#import "Masonry.h"
#import "AFNetManager.h"
#import "ProtectionCardCell.h"
#import "ProtectionCardCell4Phone6.h"
#import "BillDetailVC.h"
#import "MBProgressHUD.h"
#import "AFNetworkReachabilityManager.h"
#import "BankCardIconManager.h"
#import "CirculateView.h"
#import "BankCardListDataModel.h"
#import "ServiceCardListDataModel.h"
#import "DBManager.h"
#import "AdDataModel.h"
#import "BankCardCell4PhoneThan6.h"

//增值服务
#import "PhoneServiceVC.h"
#import "POSVC.h"
#import "LostCardVC.h"
#import "UnauthoProtectionVC.h"

//编辑增值服务
#import "AddProtectionInfoVC.h"
#import "AddPhoneServiceInfoVC.h"
#import "AddLostCardProtectionInfoVC.h"
#import "MJRefresh.h"


@interface HomeVC ()<CirculateViewDelegate>
{
    UIScrollView *_bankScrollView;
    NSMutableArray *_scrollViewItemArr;
    NSMutableArray *_cardInfoArr;
    NSMutableArray *_adDataArr;
    NSMutableArray *_addedServiceArr;
    MBProgressHUD *_hud;
    BOOL bShowScrollView;
    CirculateView *_tableHeader;
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首 页";
    
    [self initScrollView];
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    [self.bankTable addGestureRecognizer:pinchGesture];
    self.bankTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self pullDownUpdateData];
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0 || [[UserInfoModel sharedUserInfo].loginSuccess isEqualToString:@"false"]) {
        //从数据库读取数据
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _cardInfoArr = [[DBManager sharedDBManager] queryBankCardListData];
            _adDataArr = [[DBManager sharedDBManager] queryAdData];
            _addedServiceArr = [[DBManager sharedDBManager] queryServiceTypeData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateBankScrollViewData];
                [self initHeaderView];
                [self.bankTable reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }else {
        [self sendAdDataRequest];
        [self getAddedServiceList];
        [self checkPasswordCorrect];
    }
}

- (void)pullDownUpdateData {
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.refreshingBlock = ^{
        [self updateBillList];
    };
    self.bankTable.mj_header = header;
}

- (void)checkPasswordCorrect {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPasswordNotification:) name:PasswordCorrect object:nil];
    NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@", HostUrl, PasswordCorrect];
    [[AFNetManager sharedManager] postDataToServerWithHostUrl:fullUrlStr andParameters:nil andNotificationName:PasswordCorrect];
}

- (void)checkPasswordNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PasswordCorrect object:nil];
    DLog(@"resultDic = %@", resultDic);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *responseObject =  [resultDic objectForKey:@"responseObject"];
    if ([responseObject objectForKey:@"result"]) {
        //密码正确 可以请求账单
        DLog(@"验证密码正确");
        [self sendHomePageDataRequst:YES];
        [self updateBillList];
    }else {
        [ToolBox showAlertInfo:@"账单邮箱密码错误"];
    }
}

- (void)updateBillList {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBillListNotification:) name:AnalyzeAnalyze object:nil];
    NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@", HostUrl, AnalyzeAnalyze];
    [[AFNetManager sharedManager] postDataToServerWithHostUrl:fullUrlStr andParameters:nil andNotificationName:AnalyzeAnalyze];
}

- (void)updateBillListNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetAddedServiceList object:nil];
    NSDictionary *responseObj = [resultDic objectForKey:@"responseObject"];
    
    NSInteger flag = [[responseObj objectForKey:@"flag"] integerValue];
    if (flag == 1) {//有新账单
        [self sendHomePageDataRequst:NO];
    }
    [self.bankTable.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self.bankTable reloadData];
}

- (void)getAddedServiceList {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddedServiceNotification:) name:GetAddedServiceList object:nil];
    NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@", HostUrl, GetAddedServiceList];
    [[AFNetManager sharedManager] postDataToServerWithHostUrl:fullUrlStr andParameters:nil andNotificationName:GetAddedServiceList];
}

-(void)getAddedServiceNotification:(NSNotification*)notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetAddedServiceList object:nil];
//    DLog(@"resultDic = %@", resultDic);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _addedServiceArr = [[NSMutableArray alloc] init];
        NSArray *serviceDataArr = [resultDic objectForKey:@"responseObject"];
        for (NSDictionary *dataDict in serviceDataArr) {
            ServiceTypeDataModel *dataModel = [[ServiceTypeDataModel alloc] init];
            dataModel.serviceCycle = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"serviceTime1"]];
            dataModel.serviceId = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"id"]];
            dataModel.servicePrice = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"serviceTime1Money"]];
            dataModel.serviceRemark = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"remark"]];
            dataModel.serviceType = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"type"]];
            dataModel.serviceName = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"name"]];
            [_addedServiceArr addObject:dataModel];
        }
        [[DBManager sharedDBManager] saveServiceTypeData:_addedServiceArr];
    });
}

/**
 *  发送广告请求
 */
- (void)sendAdDataRequest {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AdDataNotification:) name:GetADList object:nil];
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@", HostUrl, GetADList];
    [[AFNetManager sharedManager] postDataToServerWithHostUrl:fullUrl andParameters:nil andNotificationName:GetADList];
}

- (void)AdDataNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GetADList object:nil];
//    DLog(@"resultDic = %@", resultDic);
    
    _adDataArr = [[NSMutableArray alloc] init];
    NSArray *adArr = [resultDic objectForKey:@"responseObject"];

    for (NSDictionary *dict in adArr) {
        AdDataModel *adData = [[AdDataModel alloc] init];
        NSDictionary *logoFile = [dict objectForKey:@"logoFile"];
        if ([logoFile isKindOfClass:[NSNull class]]) {
            adData.imageUrlStr = @"";
        }else{
            NSMutableString *hostUrl = [NSMutableString stringWithString:HostUrl];
            NSString* realurl = [hostUrl substringToIndex:[hostUrl length]-1];
            NSString *imagePath = [NSString stringWithFormat:@"%@%@/%@",realurl, [logoFile objectForKey:@"path"], [logoFile objectForKey:@"name"]];
            adData.imageUrlStr = imagePath;
        }

        adData.url = [NSString stringWithFormat:@"%@", [dict objectForKey:@"url"]];
        DLog(@"url = %@", adData.url);
        adData.content = [NSString stringWithFormat:@"%@", [dict objectForKey:@"content"]];
        DLog(@"url = %@", adData.content);
        adData.name = [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]];
        [_adDataArr addObject:adData];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DBManager sharedDBManager] saveAdData:_adDataArr];
    });
  
    [self initHeaderView];
    //接收新数据并存入数据库
}

/**
 *  发送信用卡信息列表请求
 */
- (void)sendHomePageDataRequst:(BOOL)showHud {
    if (showHud) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePageDataNotification:) name:HomePageData object:nil];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:HomePageData andNotificationName:HomePageData];
}

- (void)homePageDataNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HomePageData object:nil];
    DLog(@"resultDic = %@", resultDic);
    //接收新数据并存入数据库
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _cardInfoArr = [[NSMutableArray alloc] init];//[resultDic objectForKey:@"responseObject"];
        NSArray *cardListDataArr = [resultDic objectForKey:@"responseObject"];
        for (NSDictionary *dataDict in cardListDataArr) {
            BankCardListDataModel *bankCardModel = [[BankCardListDataModel alloc] init];
            NSDictionary *cardInfo =  [dataDict objectForKey:@"card"];
            if ([dataDict objectForKey:@"buyService"] == nil) {
                //bankCard
                bankCardModel.dataType = @"1";
                bankCardModel.bankName = [NSString stringWithFormat:@"%@", [cardInfo objectForKey:@"name"]];
                bankCardModel.cardLastNum = [NSString stringWithFormat:@"%@", [cardInfo objectForKey:@"number"]];
                bankCardModel.debt = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"debt"]];
                bankCardModel.minPay = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"minPay"]];
                bankCardModel.creditLine = [NSString stringWithFormat:@"%@", [cardInfo objectForKey:@"creditLine"]];
                bankCardModel.integral = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"integral"]];
                bankCardModel.period = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"period"]];
                bankCardModel.deadLine = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"deadLine"]];
                bankCardModel.cardId = [NSString stringWithFormat:@"%@", [cardInfo objectForKey:@"id"]];
                bankCardModel.billDate = [NSString stringWithFormat:@"%@", [cardInfo objectForKey:@"billDate"]];
                bankCardModel.payStatus = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"status"]];
                bankCardModel.partPayNum = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"paid"]];
                bankCardModel.billId = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"id"]];
            }else{
                //serviceInfo
                NSDictionary *buyService = [dataDict objectForKey:@"buyService"];
                bankCardModel.dataType = @"2";
                bankCardModel.bankName = [NSString stringWithFormat:@"%@", [buyService objectForKey:@"name"]];
                bankCardModel.period = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"period"]];
                bankCardModel.deadLine = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"deadLine"]];
                bankCardModel.serviceCycle = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"serviceCycle"]];
                bankCardModel.serviceId = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"id"]];
                bankCardModel.endTime = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"endTime"]];
                bankCardModel.serviceType = [NSString stringWithFormat:@"%@", [buyService objectForKey:@"type"]];
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
                    bankCardModel.serviceCardList = serviceCardList;
                }
            }
            bankCardModel.serviceInfo = [self getServiceInfoModel:dataDict];
            [_cardInfoArr addObject:bankCardModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self updateBankScrollViewData];
            [self.bankTable reloadData];
        });
        
        //缓存数据
        [[DBManager sharedDBManager] saveBankCardListData:_cardInfoArr];
    });
}

- (void)initScrollView{
//    _scrollViewItemArr = [[NSMutableArray alloc] init];
    bShowScrollView = NO;
    _bankScrollView = [[UIScrollView alloc] init];
//    _bankScrollView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped)];
    [_bankScrollView addGestureRecognizer:tapGesture];
    _bankScrollView.frame = CGRectMake(0, 150, MainScreenWidth, MainScreenHeight - 150 - 49);
}

- (void)updateBankScrollViewData {
    CGFloat scrollItemHeight = 183;
    if (MainScreenWidth > 320) {
        scrollItemHeight = 214;
    }
    
    CGFloat contentSizeHeight = ([_cardInfoArr count] - 1)*60 + scrollItemHeight;
    _bankScrollView.contentSize = CGSizeMake(self.bankTable.frame.size.width, contentSizeHeight);
    for (int i = 0; i<[_cardInfoArr count]; i++) {
        BankCardListDataModel *cardModel = [_cardInfoArr objectAtIndex:i];
        if ([cardModel.dataType isEqualToString:@"1"]) {
            if(MainScreenWidth >320)
            {
                BankCardCell4PhoneThan6 *cell = [[[NSBundle mainBundle] loadNibNamed:@"BankCardCell4PhoneThan6" owner:self options:nil] lastObject];
                [_bankScrollView addSubview:cell];
                cell.frame = CGRectMake(0, 60 * i, self.bankTable.frame.size.width, cell.frame.size.height);
                [_scrollViewItemArr addObject:cell];
                [self setBankCardCell4PhoneThan6Data:cell data:cardModel scrollViewCell:YES];
            }else {
                BankCardCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BankCardCell" owner:self options:nil] lastObject];
                [_bankScrollView addSubview:cell];
                cell.frame = CGRectMake(0, 60 * i, self.bankTable.frame.size.width, cell.frame.size.height);
                [_scrollViewItemArr addObject:cell];
                [self setBankCardCellData:cell data:cardModel scrollViewCell:YES];
            }
            
        }else {
            DLog(@"ProtectionCardCell");
            if (MainScreenWidth >320) {
                ProtectionCardCell4Phone6 *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionCardCell4Phone6" owner:self options:nil] lastObject];
                [_bankScrollView addSubview:cell];
                //CGFloat posx = (MainScreenWidth - cell.frame.size.width - 16)/2;
                cell.frame = CGRectMake(0, 60 * i, self.bankTable.frame.size.width, cell.frame.size.height);
                [self setProtectionCardCell4Phone6Data:cell data:cardModel scrollViewCell:YES];
            }else {
                ProtectionCardCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionCardCell" owner:self options:nil] lastObject];
                [_bankScrollView addSubview:cell];
                //CGFloat posx = (MainScreenWidth - cell.frame.size.width - 16)/2;
                cell.frame = CGRectMake(0, 60 * i, self.bankTable.frame.size.width, cell.frame.size.height);
                [self setProtectionCardCellData:cell data:cardModel scrollViewCell:YES];
            }
            
        }
    }
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    if (gesture.scale < 0.5) {
        bShowScrollView = YES;
        [self.bankTable reloadData];
    }
}

- (void)scrollViewTapped {
    [self endScrollViewAction];
}
- (void)endScrollViewAction {
    bShowScrollView = NO;
    [self.bankTable reloadData];
}

- (void)initHeaderView {
    _tableHeader = [[CirculateView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 150)];
    _tableHeader.delegate = self;
    [_tableHeader reloadDataWithArray:_adDataArr];
    self.bankTable.tableHeaderView = _tableHeader;
}

- (void)circulateViewClicked:(AdDataModel *)adModel {
    if ([adModel.url isEqualToString:@"1"]) {
        //丢卡保障
        LostCardVC *lostCardVc = [[LostCardVC alloc] init];
        for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
            if ([serviceModel.serviceType isEqualToString:@"1"]) {
                lostCardVc.serviceInfo = serviceModel;
                break;
            }
        }
        [self.navigationController pushViewController:lostCardVc animated:YES];
        
    }else if ([adModel.url isEqualToString:@"2"]) {
        //盗刷保障
        UnauthoProtectionVC *unauthoVc = [[UnauthoProtectionVC alloc] init];
        for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
            if ([serviceModel.serviceType isEqualToString:@"2"]) {
                unauthoVc.serviceInfo = serviceModel;
                break;
            }
        }
        [self.navigationController pushViewController:unauthoVc animated:YES];
    }else if ([adModel.url isEqualToString:@"3"]) {
        //电话服务
        PhoneServiceVC *phoneVc = [[PhoneServiceVC alloc] init];
        for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
            if ([serviceModel.serviceType isEqualToString:@"3"]) {
                phoneVc.serviceInfo = serviceModel;
                break;
            }
        }
        [self.navigationController pushViewController:phoneVc animated:YES];
        
    }else if ([adModel.url isEqualToString:@"4"]) {
        //Pos服务
        POSVC *posVc = [[POSVC alloc] init];
        for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
            if ([serviceModel.serviceType isEqualToString:@"3"]) {
                posVc.posInfo = serviceModel;
                break;
            }
        }
        [self.navigationController pushViewController:posVc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (MainScreenWidth >320)
    {
        return 214;
    }else {
     return 183;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (bShowScrollView) {
        return _bankScrollView.frame.size.height;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (bShowScrollView) {
        return _bankScrollView;
    }
    return NULL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (bShowScrollView) {
        return 0;
    }else {
        return [_cardInfoArr count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardListDataModel *cardModel = [_cardInfoArr objectAtIndex:indexPath.row];
    if ([cardModel.dataType isEqualToString:@"1"]) {
        BillDetailVC *billDetailVc = [[BillDetailVC alloc] init];
        billDetailVc.bankCardId = [NSString stringWithFormat:@"%@", cardModel.cardId];
        billDetailVc.bankCardInfo = cardModel;
        [self.navigationController pushViewController:billDetailVc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardListDataModel *cardModel = [_cardInfoArr objectAtIndex:indexPath.row];
    if ([cardModel.dataType isEqualToString:@"1"]) {
        if (MainScreenWidth > 320) {
            static NSString *cellName = @"BankCardCell4PhoneThan6";
            BankCardCell4PhoneThan6 *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BankCardCell4PhoneThan6" owner:self options:nil] lastObject];
            }
            return cell;
        }else {
            static NSString *cellName = @"BankCardCell";
            BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BankCardCell" owner:self options:nil] lastObject];
            }
            return cell;
        }
    }else {
        DLog(@"ProtectionCardCell");
        if (MainScreenWidth > 320) {
            static NSString *cellName = @"ProtectionCardCell4Phone6";
            ProtectionCardCell4Phone6 *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionCardCell4Phone6" owner:self options:nil] lastObject];
            }
            return cell;
        }else {
            static NSString *cellName = @"ProtectionCardCell";
            ProtectionCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionCardCell" owner:self options:nil] lastObject];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardListDataModel *cardModel = [_cardInfoArr objectAtIndex:indexPath.row];
    if ([cardModel.dataType isEqualToString:@"1"]) {
        if (MainScreenWidth > 320) {
            BankCardCell4PhoneThan6 *bankCardcell = (BankCardCell4PhoneThan6 *)cell;
            [self setBankCardCell4PhoneThan6Data:bankCardcell data:cardModel scrollViewCell:NO];
        }else {
            BankCardCell *bankCardcell = (BankCardCell *)cell;
            [self setBankCardCellData:bankCardcell data:cardModel scrollViewCell:NO];
        }

    }else {
        if (MainScreenWidth > 320) {
            ProtectionCardCell4Phone6 *protectionCardCell = (ProtectionCardCell4Phone6*)cell;
            [self setProtectionCardCell4Phone6Data:protectionCardCell data:cardModel scrollViewCell:NO];
        }else {
            ProtectionCardCell *protectionCardCell = (ProtectionCardCell*)cell;
            [self setProtectionCardCellData:protectionCardCell data:cardModel scrollViewCell:NO];
        }
    }
}

- (void)setBankCardCellData:(BankCardCell *)cell data:(BankCardListDataModel *)dataModel scrollViewCell:(BOOL)bScroll{
    cell.cardNameAndNumber.text = [NSString stringWithFormat:@"%@ %@", dataModel.bankName, dataModel.cardLastNum];
    
    cell.debt.text = [NSString stringWithFormat:@"%@", dataModel.debt];
    cell.minPay.text = [NSString stringWithFormat:@"%@", dataModel.minPay];
    cell.creditLine.text = [NSString stringWithFormat:@"%@", dataModel.creditLine];
    cell.integeral.text = [NSString stringWithFormat:@"%@", dataModel.integral];
    cell.period.text = [NSString stringWithFormat:@"%@", dataModel.period];
    
    NSMutableString *deadLine = [NSMutableString stringWithString: dataModel.deadLine];
    [deadLine replaceOccurrencesOfString:@"-" withString:@"." options:NSWidthInsensitiveSearch range:NSMakeRange(0,10)];
    DLog(@"deadLine = %@",deadLine);
    cell.deadDate.text = [NSString stringWithFormat:@"还款日%@", [deadLine substringWithRange:NSMakeRange(5, 6)]];
    
    NSString *dateNowStr = [ToolBox getDateStringWithDate:[[NSDate date] description] dateFormat:@"yyyy-MM-dd HH:mm:ss z" destFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *cdTimeStr = [ToolBox getDaysBetweenEndDate:[NSMutableString stringWithString: dataModel.deadLine] andStartDate:dateNowStr withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    cell.cdTime.text = [NSString stringWithFormat:@"%@", cdTimeStr];
    
    NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: dataModel.bankName];
    DLog(@"iconPath = %@", iconPath);
    cell.cardIcon.image = ImageName(iconPath);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell setPayState:dataModel.payStatus andPaidNum:dataModel.partPayNum];
    cell.billDetailButtonAction = ^(UIButton *button){
        if (bScroll) {
            return ;
        }
        DLog(@"billDetailButtonAction");
//        BillDetailVC *billDetailVc = [[BillDetailVC alloc] init];
//        billDetailVc.bankCardId = [NSString stringWithFormat:@"%@", dataModel.cardId];
//        billDetailVc.bankCardInfo = dataModel;
//        [self.navigationController pushViewController:billDetailVc animated:YES];
    };
    
    cell.getPayState = ^(NSInteger paystate, CGFloat partPayNUmber){
        [self setPayState:[NSString stringWithFormat:@"%ld", paystate] andPaidMoney:[NSString stringWithFormat:@"%0.2f", partPayNUmber] andBIllId:dataModel.billId];
        dataModel.partPayNum = [NSString stringWithFormat:@"%0.2f", partPayNUmber];
        dataModel.payStatus = [NSString stringWithFormat:@"%ld", paystate];
        [[DBManager sharedDBManager] updateBankCardListData:dataModel];
    };
    
    if (bScroll) {
        cell.payButtonView.userInteractionEnabled = NO;
        cell.contentView.userInteractionEnabled = NO;
    }
    
    [self setNextBilldateCDDays:cell data:dataModel];
}

- (void)setBankCardCell4PhoneThan6Data:(BankCardCell4PhoneThan6 *)cell data:(BankCardListDataModel *)dataModel scrollViewCell:(BOOL)bScroll{
    cell.cardNameAndNumber.text = [NSString stringWithFormat:@"%@ %@", dataModel.bankName, dataModel.cardLastNum];
    cell.debt.text = [NSString stringWithFormat:@"%@", dataModel.debt];
    cell.minPay.text = [NSString stringWithFormat:@"%@", dataModel.minPay];
    cell.creditLine.text = [NSString stringWithFormat:@"%@", dataModel.creditLine];
    cell.integeral.text = [NSString stringWithFormat:@"%@", dataModel.integral];
    cell.period.text = [NSString stringWithFormat:@"%@", dataModel.period];
    
    NSMutableString *deadLine = [NSMutableString stringWithString: dataModel.deadLine];
    [deadLine replaceOccurrencesOfString:@"-" withString:@"." options:NSWidthInsensitiveSearch range:NSMakeRange(0,10)];
    DLog(@"deadLine = %@",deadLine);
    cell.deadDate.text = [NSString stringWithFormat:@"还款日%@", [deadLine substringWithRange:NSMakeRange(5, 6)]];
    
    NSString *dateNowStr = [ToolBox getDateStringWithDate:[[NSDate date] description] dateFormat:@"yyyy-MM-dd HH:mm:ss z" destFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *cdTimeStr = [ToolBox getDaysBetweenEndDate:[NSMutableString stringWithString: dataModel.deadLine] andStartDate:dateNowStr withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    cell.cdTime.text = [NSString stringWithFormat:@"%@", cdTimeStr];
    
    NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName: dataModel.bankName];
    DLog(@"iconPath = %@", iconPath);
    cell.cardIcon.image = ImageName(iconPath);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setPayState:dataModel.payStatus andPaidNum:dataModel.partPayNum];
    cell.billDetailButtonAction = ^(UIButton *button){
        if (bScroll) {
            return ;
        }
        DLog(@"billDetailButtonAction");
//        BillDetailVC *billDetailVc = [[BillDetailVC alloc] init];
//        billDetailVc.bankCardId = [NSString stringWithFormat:@"%@", dataModel.cardId];
//        billDetailVc.bankCardInfo = dataModel;
//        [self.navigationController pushViewController:billDetailVc animated:YES];
    };
    
    cell.getPayState = ^(NSInteger paystate, CGFloat partPayNUmber){
        [self setPayState:[NSString stringWithFormat:@"%ld", paystate] andPaidMoney:[NSString stringWithFormat:@"%0.2f", partPayNUmber] andBIllId:dataModel.billId];
        dataModel.partPayNum = [NSString stringWithFormat:@"%0.2f", partPayNUmber];
        dataModel.payStatus = [NSString stringWithFormat:@"%ld", paystate];
        [[DBManager sharedDBManager] updateBankCardListData:dataModel];
    };
    
    if (bScroll) {
        cell.payButtonView.userInteractionEnabled = NO;
        cell.contentView.userInteractionEnabled = NO;
    }
    
    [self setNextBilldateCDDays:cell data:dataModel];
}

- (void)setNextBilldateCDDays:(UITableViewCell*)cell data:(BankCardListDataModel *)dataModel {
    if ([dataModel.period isEqual:[NSNull class]] || [dataModel.period isEqualToString:@"<null>"]) {
        return;
    }

    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    dateFormater.dateFormat = @"yyyy.MM";
    NSString *billDateStr = [[NSDate  date].description substringToIndex:7];
    NSDate *billdate = [dateFormater dateFromString:billDateStr];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    [comps setDay:dataModel.billDate.integerValue];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:billdate options:0];
    
    NSString *cdDays = [ToolBox getDaysBetweenEndDate:mDate.description andStartDate:[NSDate date].description withDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    if (MainScreenWidth >320) {
        BankCardCell4PhoneThan6 *currCell = (BankCardCell4PhoneThan6 *)cell;
        currCell.leftDaysToNextBillDay.text = [NSString stringWithFormat:@"%@", cdDays];
    }else {
        BankCardCell *currCell = (BankCardCell *)cell;
        currCell.leftDaysToNextBillDay.text = [NSString stringWithFormat:@"%@", cdDays];
    }
}

- (void)setProtectionCardCellData:(ProtectionCardCell*)cell data:(BankCardListDataModel *)dataModel scrollViewCell:(BOOL)bScroll {
    cell.title.text = [NSString stringWithFormat:@"%@", dataModel.bankName];
    cell.servicePeriod.text =  [NSString stringWithFormat:@"%@", dataModel.serviceCycle];
    NSMutableString *deadLine = [NSMutableString stringWithString:dataModel.endTime];
    [deadLine replaceOccurrencesOfString:@"-" withString:@"." options:NSWidthInsensitiveSearch range:NSMakeRange(0,10)];
    cell.endTime.text = [NSString stringWithFormat:@"服务截止日期%@", [deadLine substringWithRange:NSMakeRange(5, 6)]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *dateNowStr = [ToolBox getDateStringWithDate:[[NSDate date] description] dateFormat:@"yyyy-MM-dd HH:mm:ss z" destFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *cdTimeStr = [ToolBox getDaysBetweenEndDate:[NSMutableString stringWithString: dataModel.endTime] andStartDate:dateNowStr withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    cell.CDTime.text = [NSString stringWithFormat:@"%@", cdTimeStr];
    cell.operationButton.hidden = YES;
    
    if ([dataModel.serviceType integerValue]== 1) {
        [cell.icon setImage:ImageName(@"diu-ka-bao-zhang@2x.png")];
        
    }else if([dataModel.serviceType integerValue]== 2) {
         [cell.icon setImage:ImageName(@"dao-shua-bao-zhang-")];
    }
    else if([dataModel.serviceType integerValue]== 3) {
         [cell.icon setImage:ImageName(@"iconfont-phoneService")];
    }
    else if([dataModel.serviceType integerValue]== 4) {
         [cell.icon setImage:ImageName(@"pos-anniu")];
    }
    
    [cell setCardsInfo:dataModel.serviceCardList];   
    cell.buyService = ^(){
        if (bScroll) {
            return;
        }
        [self buyService:dataModel];
    };
}

- (void)setProtectionCardCell4Phone6Data:(ProtectionCardCell4Phone6*)cell data:(BankCardListDataModel *)dataModel scrollViewCell:(BOOL)bScroll {
    cell.title.text = [NSString stringWithFormat:@"%@", dataModel.bankName];
    cell.servicePeriod.text =  [NSString stringWithFormat:@"%@", dataModel.serviceCycle];
    NSMutableString *deadLine = [NSMutableString stringWithString:dataModel.endTime];
    [deadLine replaceOccurrencesOfString:@"-" withString:@"." options:NSWidthInsensitiveSearch range:NSMakeRange(0,10)];
    cell.endTime.text = [NSString stringWithFormat:@"服务截止日期%@", [deadLine substringWithRange:NSMakeRange(5, 6)]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *dateNowStr = [ToolBox getDateStringWithDate:[[NSDate date] description] dateFormat:@"yyyy-MM-dd HH:mm:ss z" destFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *cdTimeStr = [ToolBox getDaysBetweenEndDate:[NSMutableString stringWithString: dataModel.endTime] andStartDate:dateNowStr withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    cell.CDTime.text = [NSString stringWithFormat:@"%@", cdTimeStr];
    cell.operationButton.hidden = YES;
    
    if ([dataModel.serviceType integerValue]== 1) {
        [cell.icon setImage:ImageName(@"diu-ka-bao-zhang@2x.png")];
        
    }else if([dataModel.serviceType integerValue]== 2) {
        [cell.icon setImage:ImageName(@"dao-shua-bao-zhang-")];
    }
    else if([dataModel.serviceType integerValue]== 3) {
        [cell.icon setImage:ImageName(@"iconfont-phoneService")];
    }
    else if([dataModel.serviceType integerValue]== 4) {
        [cell.icon setImage:ImageName(@"pos-anniu")];
    }
    
    [cell setCardsInfo:dataModel.serviceCardList];
    cell.buyService = ^(){
        if (bScroll) {
            return;
        }
        [self buyService:dataModel];
    };
}

- (void)buyService:(BankCardListDataModel *)serviceData {
    if (![[AFNetManager sharedManager] checkNetStateWithTip:@"网络不好，请稍后再试"]){
        return;
    }
    DLog(@"%@", serviceData);
    if ([serviceData.serviceType isEqualToString:@"1"]) {
        AddLostCardProtectionInfoVC *lostCardVc = [[AddLostCardProtectionInfoVC alloc] init];
        lostCardVc.unauthorizedInfo = serviceData.serviceInfo;
        for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
            if ([serviceModel.serviceType isEqualToString:@"1"]) {
                lostCardVc.serviceInfo = serviceModel;
                break;
            }
        }
        lostCardVc.addedCardNumberCnt = [serviceData.serviceCardList count]-1;
        lostCardVc.operationType = 1;//续保
        
        [self.navigationController pushViewController:lostCardVc animated:YES];
        
    }else if ([serviceData.serviceType isEqualToString:@"2"]) {
        AddProtectionInfoVC *addProtectionVc = [[AddProtectionInfoVC alloc] init];
        for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
            if ([serviceModel.serviceType isEqualToString:@"2"]) {
                addProtectionVc.serviceInfo = serviceModel;
                break;
            }
        }
        addProtectionVc.unauthorizedInfo = serviceData.serviceInfo;
        addProtectionVc.addedCardNumberCnt = [serviceData.serviceCardList count]-1;
        addProtectionVc.operationType = 1;//续保
        
        [self.navigationController pushViewController:addProtectionVc animated:YES];
        
    }else if ([serviceData.serviceType isEqualToString:@"3"]) {
        AddPhoneServiceInfoVC *addPhoneVc = [[AddPhoneServiceInfoVC alloc] init];
        for (ServiceTypeDataModel *serviceModel in _addedServiceArr) {
            if ([serviceModel.serviceType isEqualToString:@"3"]) {
                addPhoneVc.serviceInfo = serviceModel;
                break;
            }
        }
        addPhoneVc.unauthorizedInfo = serviceData.serviceInfo;
        addPhoneVc.addedCardNumberCnt = [serviceData.serviceCardList count]-1;
        addPhoneVc.operationType = 1;//续保
        
        [self.navigationController pushViewController:addPhoneVc animated:YES];
    }
}

- (void)setPayState:(NSString *)state andPaidMoney:(NSString *)paid andBIllId:(NSString *)billId{
    if (![[AFNetManager sharedManager] checkNetStateWithTip:@"网络不好，请稍后再试"]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(billUpdateNotification:) name:BillUpdate object:nil];
    NSString *parameter = [NSString stringWithFormat:@"%@id=%@&status=%@&paid=%@",BillUpdate, billId, state, paid];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:parameter andNotificationName:BillUpdate];
}
- (void)billUpdateNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BillUpdate object:nil];
    DLog(@"resultDic = %@", resultDic);
}

- (ServiceInfoModel *)getServiceInfoModel:(NSDictionary *)serviceDict {
    if ([serviceDict[@"buyService"][@"type"] intValue] == 1) {
        return [self getLostProtectionServiceInfoModel:serviceDict];
    }else if ([serviceDict[@"buyService"][@"type"] intValue] == 2) {
        return [self getProtectionServiceInfoModel:serviceDict];
    }else if ([serviceDict[@"buyService"][@"type"] intValue] == 3) {
        return [self getPhoneServiceInfoModel:serviceDict];
    }
    return NULL;
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
@end
