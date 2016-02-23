//
//  AddLostCardProtectionInfoVC.m
//  JinFu
//
//  Created by ybon on 15/12/28.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "AddLostCardProtectionInfoVC.h"
#import "UserInfoInputCell.h"
#import "AddCardNumberCell.h"
#import "ServicePeriodCell.h"
#import "TotalPaymentCell.h"
#import "CommitCell.h"

#import "LostCardPayServiceVC.h"
#import "AFNetManager.h"

@interface AddLostCardProtectionInfoVC ()
{
//    int addedCardNumberCnt;
    NSMutableArray *_inputPlaceHoldersArr;
//    UnauthorizedChargeInfo *_unauthorizedInfo;
    __block BOOL bShowPullDownList;
    
    NSMutableArray *_servicePeriodArr;
    NSMutableArray *_servicePriceArr;
    NSMutableDictionary *_periodInfoDict;
    NSMutableArray *_shownServiceTimeArr;
    NSString *requstUrlString;
}
@end

@implementation AddLostCardProtectionInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    if (self.addedCardNumberCnt != 0) {
//        
//    }
    _inputPlaceHoldersArr = [NSMutableArray arrayWithObjects:@"姓名",@"身份证号",@"手机号",@"填写卡号", nil];
    self.addProtectionInfoTabe.separatorStyle = UITableViewCellSeparatorStyleNone;
    bShowPullDownList = false;
    
    if (!self.unauthorizedInfo) {
        self.unauthorizedInfo = [[ServiceInfoModel alloc] init];
    }
    _servicePeriodArr = [[NSMutableArray alloc] init];
    _servicePriceArr = [[NSMutableArray alloc] init];
    _shownServiceTimeArr = [[NSMutableArray alloc] init];
    [self getServicePeriodAndPrice];
    
    DLog(@" operationtype = %ld", self.operationType);
    self.navigationItem.title = @"失卡保障";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)getServicePeriodAndPrice {
    NSString *serviceTime1 = self.serviceInfo.serviceCycle;
    NSString *serviceTime1Money =  self.serviceInfo.servicePrice;
    [ToolBox  splitString:serviceTime1 withCharacter:@"," andSubstrArr:_servicePeriodArr];
    [ToolBox  splitString:serviceTime1Money withCharacter:@"," andSubstrArr:_servicePriceArr];
    
    _periodInfoDict = [[NSMutableDictionary alloc] initWithObjects:_servicePriceArr forKeys:_servicePeriodArr];
    //    DLog(@"_servicePeriodArr  =%@", _servicePeriodArr);
    if ([_servicePeriodArr count] > 0){
        self.unauthorizedInfo.servicePeriod = [_servicePeriodArr objectAtIndex:0];
    }
    
    for (NSString *str in _servicePeriodArr) {
//        NSInteger period = [str integerValue];
        [_shownServiceTimeArr addObject:[NSString stringWithFormat:@"%@月", str]];
//        CGFloat showPeriod = (CGFloat)period/12.0;
//        if (showPeriod > 0.2 && showPeriod < 1) {
//            [_shownServiceTimeArr addObject:@"半年"];
//        }else{
//            [_shownServiceTimeArr addObject:[NSString stringWithFormat:@"%.0f年", showPeriod]];
//        }
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        return 44;
    }else if(indexPath.row <= 3+self.addedCardNumberCnt) {
        return 88;
    }else if (indexPath.row == 4+self.addedCardNumberCnt) {
        return (bShowPullDownList ? 85: 44);
    }else if (indexPath.row == 5+self.addedCardNumberCnt) {
        return 44;
    }else if (indexPath.row == 6+self.addedCardNumberCnt) {
        return 120;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7+self.addedCardNumberCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 3) {
        return [self getInputCellOfTableview:tableView andIndexPath:indexPath];
        
    }else if(indexPath.row <= 3+self.addedCardNumberCnt) {
        return [self getAddCardCellOfTableview:tableView andIndexPath:indexPath];
        
    }else if (indexPath.row == 4+self.addedCardNumberCnt) {
        return [self getServicePeriodCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 5+self.addedCardNumberCnt) {
        return [self getTotalPaymentCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 6+self.addedCardNumberCnt) {
        return [self getCommitCellOfTableview:tableView andIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] init];
}

- (UserInfoInputCell *)getInputCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"UserInfoInputCell";
    UserInfoInputCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoInputCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        ( self.operationType != 0 ) ? (cell.inputTF.enabled = NO ):(cell.inputTF.enabled = YES);
        
        if ( self.unauthorizedInfo.name != nil && ![self.unauthorizedInfo.name isEqualToString:@""]) {
            cell.inputTF.text = self.unauthorizedInfo.name;
        }else
        {
            cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
        }
    }else if (indexPath.row == 1){
        
        ( self.operationType != 0 ) ? (cell.inputTF.enabled = NO ):(cell.inputTF.enabled = YES);
        
        if ( self.unauthorizedInfo.identityCard != nil && ![self.unauthorizedInfo.identityCard isEqualToString:@""]) {
            cell.inputTF.text = self.unauthorizedInfo.identityCard;
        }else
        {
            cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
        }
        
    }else if (indexPath.row ==2){
        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        if ( self.unauthorizedInfo.phoneNumber != nil && ![self.unauthorizedInfo.phoneNumber isEqualToString:@""]) {
            cell.inputTF.text = self.unauthorizedInfo.phoneNumber;
        }else
        {
            cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
        }
    }
    
    cell.getInputText = ^(NSString *text){
        NSString *inputStr = [NSString stringWithString:text];
        if (indexPath.row == 0) {
            self.unauthorizedInfo.name = inputStr;
        }else if (indexPath.row == 1){
            self.unauthorizedInfo.identityCard = inputStr;
        }else if (indexPath.row == 2 )
        {
            self.unauthorizedInfo.phoneNumber = inputStr;
        }
    };
    
    return cell;
}

- (AddCardNumberCell *)getAddCardCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"AddCardNumberCell";
    AddCardNumberCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddCardNumberCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.unauthorizedInfo.cardNumberArr count] > indexPath.row - 3 && ![[self.unauthorizedInfo.cardNumberArr objectAtIndex:indexPath.row-3] isEqualToString:@""]) {
        cell.cardNumberTf.text = [NSString stringWithFormat:@"%@", self.unauthorizedInfo.cardNumberArr[indexPath.row-3]];
        DLog(@"cell.cardNumberTf.text = %@", cell.cardNumberTf.text);
    }else
    {
        DLog(@"%@", _inputPlaceHoldersArr[indexPath.row]);
        cell.cardNumberTf.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
    }
    
    ( self.operationType != 0 ) ? (cell.cardNumberTf.enabled = NO ):(cell.cardNumberTf.enabled = YES);
    
    if ([self.unauthorizedInfo.bankNameArr count] > indexPath.row - 3 && ![[self.unauthorizedInfo.bankNameArr objectAtIndex:indexPath.row-3] isEqualToString:@""]) {
        cell.bankNameTF.text = [NSString stringWithFormat:@"%@", self.unauthorizedInfo.bankNameArr[indexPath.row-3]];
        DLog(@"cell.cardNumberTf.text = %@", cell.bankNameTF.text);
    }else
    {
        cell.bankNameTF.placeholder = @"银行名称";
    }
    
    ( self.operationType != 0 ) ? (cell.bankNameTF.enabled = NO ):(cell.bankNameTF.enabled = YES);
    
    
    if (indexPath.row < 3+self.addedCardNumberCnt) {
         cell.operationImage.image = [UIImage imageNamed:@"subCell"];
    }
    cell.buttonViewAction = ^{
        if (self.operationType != 0) {
            return;
        }
        if (indexPath.row < 3+self.addedCardNumberCnt) {
            if (self.addedCardNumberCnt > 0) {
                self.addedCardNumberCnt--;
                [_inputPlaceHoldersArr removeLastObject];
                 [self.unauthorizedInfo.cardNumberArr replaceObjectAtIndex:indexPath.row-3 withObject:@""];
                [self.unauthorizedInfo.bankNameArr replaceObjectAtIndex:indexPath.row-3 withObject:@""];
                [self.addProtectionInfoTabe reloadData];
            }
        }else {
            self.addedCardNumberCnt++;
            [_inputPlaceHoldersArr addObject:@"填写卡号"];
            [self.addProtectionInfoTabe reloadData];
        }
        
    };
    
    cell.getCardNumber = ^(NSString *cardNumber) {
        if (cardNumber.length == 0) {//信用卡号长度
            [ToolBox showAlertInfo:@"请填入正确的信用卡号"];
            return;
        }
        NSString *inputStr = [NSString stringWithString:cardNumber];
        [self.unauthorizedInfo.cardNumberArr replaceObjectAtIndex:indexPath.row-3 withObject:inputStr];
    };
    
    cell.getBankName = ^(NSString *bankName) {
        if (bankName.length == 0) {//信用卡号长度
            [ToolBox showAlertInfo:@"请填入银行名称"];
            return;
        }
        NSString *inputStr = [NSString stringWithString:bankName];
        [self.unauthorizedInfo.bankNameArr replaceObjectAtIndex:indexPath.row-3 withObject:inputStr];
    };
    cell.cardNumberTf.keyboardType = UIKeyboardTypeNumberPad;
    return cell;
}

- (ServicePeriodCell *)getServicePeriodCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"ServicePeriodCell";
    ServicePeriodCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServicePeriodCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setpullMenuDataSoure:_shownServiceTimeArr];
    if ( self.unauthorizedInfo.servicePeriod != nil) {
        NSInteger idx = [_servicePeriodArr indexOfObject:self.unauthorizedInfo.servicePeriod];
        NSString *inputStr = [NSString stringWithString:_shownServiceTimeArr[idx]];
        [cell setSelectDataIdx:idx];
    }else {
        [cell setSelectDataIdx:0];;
    }
    
    DLog(@"getServicePeriodCellOfTableview");
    cell.showListViewEvent=^{
        DLog(@"cell.showListViewEvent");
        bShowPullDownList = YES;
        [tableview reloadData];
    };
    
    cell.hideListViewEvent = ^{
        DLog(@"cell.hideListViewEvent");
        bShowPullDownList = NO;
        [tableview reloadData];
    };
    cell.getSelectedText = ^(NSInteger idx, NSString *text){
//        NSInteger idx = [_shownServiceTimeArr indexOfObject:text];
        NSString *inputStr = [NSString stringWithString:_servicePeriodArr[idx]];
        self.unauthorizedInfo.servicePeriod = inputStr;
    };
    
    [cell setBlock];
    [cell setPullMenuState:bShowPullDownList];
    return cell;
}

- (TotalPaymentCell *)getTotalPaymentCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"TotalPaymentCell";
    TotalPaymentCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TotalPaymentCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *price =  [_periodInfoDict objectForKey:self.unauthorizedInfo.servicePeriod];
    //    [_unauthorizedInfo.cardNumberArr ];
    int i = 0;
    for (NSString *cardNumber in self.unauthorizedInfo.cardNumberArr) {
        if (![cardNumber isEqualToString:@""]) {
            i ++;
        }
    }
    
    cell.totalCount.text = [NSString stringWithFormat:@"￥%ld", [price integerValue] * i] ;
    self.unauthorizedInfo.totalCost = [NSString stringWithFormat:@"%ld", [price integerValue] * i];
    return cell;
}

- (CommitCell *)getCommitCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CommitCell";
    CommitCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommitCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.agreeProtocolAction = ^(BOOL bAgree){
        self.unauthorizedInfo.agreeProtol = bAgree;
    };
    cell.bAgreeProtocol = self.unauthorizedInfo.agreeProtol;
    cell.commitButtonAction = ^(){
        [self commitProtectionInfo];
    };
    
    return cell;
}

- (void)commitProtectionInfo{
    NSMutableString *cards = [[NSMutableString alloc] init];
    //检测卡号是否为空
    BOOL bBreak = false;
    for (int i = 0; i <= self.addedCardNumberCnt; i++) {
        NSString *cardStr = self.unauthorizedInfo.cardNumberArr[i];
        if ([cardStr isEqualToString:@""]) {
            [ToolBox showAlertInfo:@"银行卡号不能为空"];
            bBreak = true;
            break;
        }
    }
    
    if (bBreak) {
        return;
    }
    
    bBreak = false;
    for (int i = 0; i <= self.addedCardNumberCnt; i++) {
        NSString *cardStr = self.unauthorizedInfo.bankNameArr[i];
        if ([cardStr isEqualToString:@""]) {
            [ToolBox showAlertInfo:@"银行名称不能为空"];
            bBreak = true;
            break;
        }
    }
    if (bBreak) {
        return;
    }
    
    //拼接卡号参数
    for (NSString *str in self.unauthorizedInfo.cardNumberArr ) {
        if (![str isEqualToString:@""]) {
            [cards appendFormat:@"%@,",str];
        }
    }
    //拼接银行名称参数
    NSMutableString *bankName = [[NSMutableString alloc] init];
    for (NSString *str in self.unauthorizedInfo.bankNameArr ) {
        if (![str isEqualToString:@""]) {
            [bankName appendFormat:@"%@,",str];
        }
    }
    
    if (self.unauthorizedInfo.name == nil || [self.unauthorizedInfo.name isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"姓名不能为空"];
        return;
    }else if(self.unauthorizedInfo.phoneNumber == nil || ![ToolBox verifyPhone:self.unauthorizedInfo.phoneNumber] ){
//        [ToolBox showAlertInfo:@"手机号不能为空"];
        return;
    }else if(!self.unauthorizedInfo.agreeProtol) {
        [ToolBox showAlertInfo:@"是否同意服务条款"];
        return;
    }else{
        
        NSDictionary *parasDct;
        if (self.operationType == 0) {
            requstUrlString = AddBuyLostService;
            parasDct = [self getAddBuyLostServiceParameters:cards andBankName:bankName];
            
        }else if(self.operationType == 1) {
            requstUrlString = ContBuyLostService;
            parasDct = [self getContBuyLostServiceParameters:cards andBankName:bankName];
        }else if(self.operationType == 2) {
            requstUrlString = EditBuyLostService;
            parasDct = [self getContBuyLostServiceParameters:cards andBankName:bankName];
        }else if(self.operationType == 3) {
            requstUrlString = CEditBuyLostService;
            parasDct = [self getContBuyLostServiceParameters:cards andBankName:bankName];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBuyLostServiceNotification:) name:requstUrlString object:nil];
       
        
        [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl, requstUrlString] andParameters:parasDct andNotificationName:requstUrlString];
    }
}

//添加未通过重新编辑和续保编辑以及续保未通过重新编辑的参数一样
- (NSDictionary *)getContBuyLostServiceParameters:(NSString *)cards andBankName:(NSString*)bankName {
    NSDictionary *parasDct = @{
                               @"id":self.unauthorizedInfo.productId,
                               @"serviceId":self.serviceInfo.serviceId,
                               @"memberId":@"",
                               @"memberName":self.unauthorizedInfo.name,
                               @"contact":self.unauthorizedInfo.phoneNumber,
                               @"serviceCycle":self.unauthorizedInfo.servicePeriod,
                               @"cost":self.unauthorizedInfo.totalCost,
                               @"identityCard":self.unauthorizedInfo.identityCard,
                               @"cards":cards,
                               @"cardNmae":bankName
                               };
    return parasDct;
}

- (NSDictionary *)getAddBuyLostServiceParameters:(NSString *)cards andBankName:(NSString*)bankName {
    NSDictionary *parasDct = @{
                               @"serviceId":self.serviceInfo.serviceId,
                               @"memberId":@"",
                               @"memberName":self.unauthorizedInfo.name,
                               @"contact":self.unauthorizedInfo.phoneNumber,
                               @"serviceCycle":self.unauthorizedInfo.servicePeriod,
                               @"cost":self.unauthorizedInfo.totalCost,
                               @"identityCard":self.unauthorizedInfo.identityCard,
                               @"cards":cards,
                               @"cardName":bankName
                               };
    return parasDct;
}

- (void)addBuyLostServiceNotification:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requstUrlString object:nil];
    DLog(@"resultDic = %@", resultDic);
    if ([resultDic objectForKey:@"responseObject"]) {
        NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
        NSString *msg = [responseObject objectForKey:@"MSG"];
        [ToolBox showAlertInfo:msg];
        if (self.operationType == 0 || self.operationType == 1) {
            LostCardPayServiceVC *payserviceVc = [[LostCardPayServiceVC alloc] init];
            payserviceVc.unautoProtectionInfo = self.unauthorizedInfo;
            [self.navigationController pushViewController:payserviceVc animated:YES];
        }
    }else{
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"tableView");
    if (indexPath.row == 4+self.addedCardNumberCnt) {
        bShowPullDownList = !bShowPullDownList;
        [tableView reloadData];
    }
}

@end
