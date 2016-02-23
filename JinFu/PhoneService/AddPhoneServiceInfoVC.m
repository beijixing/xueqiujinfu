//
//  AddPhoneServiceInfoVC.m
//  JinFu
//
//  Created by ybon on 15/12/28.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "AddPhoneServiceInfoVC.h"
#import "UserInfoInputCell.h"
#import "CardNumberAndDateCell.h"
#import "EditRemindDateCell.h"
#import "ServicePeriodCell.h"
#import "TotalPaymentCell.h"
#import "CommitCell.h"
#import "PhonePayServiceInfo.h"
#import "AFNetManager.h"

@interface AddPhoneServiceInfoVC ()
{
//    int addedCardNumberCnt;
    NSMutableArray *_inputPlaceHoldersArr;
    __block BOOL bShowPullDownList;
    __block BOOL bShowDatePullList;
    __block BOOL bShowTimePullList;
    
    NSMutableArray *_servicePeriodArr;
    NSMutableArray *_servicePriceArr;
    NSMutableDictionary *_periodInfoDict;
    NSMutableArray *_shownServiceTimeArr;
    
    NSDictionary *preRemindDays;
    NSDictionary *remindTime;
    
    NSMutableArray *preRemindDaysArr;
    NSMutableArray *remindTimeArr;
    
    NSString *requstUrlString;

}
@end

@implementation AddPhoneServiceInfoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    addedCardNumberCnt = 0;
    self.navigationItem.title = @"电话服务";
    _inputPlaceHoldersArr = [NSMutableArray arrayWithObjects:@"姓名",@"手机号",@"填写卡号", nil];
    self.phoneServiceInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    bShowPullDownList = false;
    bShowDatePullList = false;
    bShowTimePullList = false;
    
    if (!self.unauthorizedInfo) {
        self.unauthorizedInfo = [[ServiceInfoModel alloc] init];
    }
    
    _servicePeriodArr = [[NSMutableArray alloc] init];
    _servicePriceArr = [[NSMutableArray alloc] init];
    _shownServiceTimeArr = [[NSMutableArray alloc] init];
    [self getServicePeriodAndPrice];
    [self getConfigureRemindDate];
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)getConfigureRemindDate {
    NSString *dictPath = [[NSBundle mainBundle] pathForResource:@"RemindDateAndTimeList" ofType:@"plist"];
    DLog(@"dictPath = %@",dictPath);
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dictPath];
    DLog(@"%@", dict);
    preRemindDays = [dict objectForKey:@"preRemindDay"];
    remindTime = [dict objectForKey:@"remindTime"];
    preRemindDaysArr = [[NSMutableArray alloc] init];
    remindTimeArr = [[NSMutableArray alloc] init];
    NSArray *allKeys = [preRemindDays allKeys];
    for (int i = 1; i<= [allKeys count]; i++) {
        [preRemindDaysArr addObject:[preRemindDays objectForKey:[NSString stringWithFormat:@"%d", i]]];
    }
    
    allKeys = [remindTime allKeys];
    for (int i = 1; i<= [allKeys count]; i++) {
        [remindTimeArr addObject:[remindTime objectForKey:[NSString stringWithFormat:@"%d", i]]];
    }
    self.unauthorizedInfo.preRemindDays = preRemindDaysArr[0];
    self.unauthorizedInfo.remindTime = remindTimeArr[0];
}

- (void)getServicePeriodAndPrice {
    NSString *serviceTime1 = self.serviceInfo.serviceCycle;
    NSString *serviceTime1Money = self.serviceInfo.servicePrice;
    _servicePeriodArr = [NSMutableArray arrayWithArray:[serviceTime1 componentsSeparatedByString:@","]];
    _servicePriceArr = [NSMutableArray arrayWithArray:[serviceTime1Money componentsSeparatedByString:@","]];
    
    _periodInfoDict = [[NSMutableDictionary alloc] initWithObjects:_servicePriceArr forKeys:_servicePeriodArr];
    //    DLog(@"_servicePeriodArr  =%@", _servicePeriodArr);
    if ([_servicePeriodArr count] > 0){
        self.unauthorizedInfo.servicePeriod = [_servicePeriodArr objectAtIndex:0];
    }
    
    for (NSString *str in _servicePeriodArr) {
        [_shownServiceTimeArr addObject:[NSString stringWithFormat:@"%@月", str]];

//        NSInteger period = [str integerValue];
//        CGFloat showPeriod = (CGFloat)period/12.0;
//        if (showPeriod > 0.2 && showPeriod < 1) {
//            [_shownServiceTimeArr addObject:@"半年"];
//        }else{
//            [_shownServiceTimeArr addObject:[NSString stringWithFormat:@"%.0f年", showPeriod]];
//        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < 2 ) {
        return 44;
    }else if (indexPath.row <=2+self.addedCardNumberCnt) {
        return 88;
    }else if (indexPath.row == 3+self.addedCardNumberCnt) {
        return (bShowDatePullList ? 85: 44);
    }else if (indexPath.row == 4+self.addedCardNumberCnt) {
        return (bShowPullDownList ? 85: 44);
    }else if (indexPath.row == 6+self.addedCardNumberCnt) {
        return 120;
    }else{
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7+self.addedCardNumberCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 2) {
        return [self getInputCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row <= 2+self.addedCardNumberCnt) {
        return [self getCardNumberAndDateCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 3+self.addedCardNumberCnt) {
        return [self getRemindTimeCellOfTableview:tableView andIndexPath:indexPath];
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
        if ( self.unauthorizedInfo.name != nil ) {
            cell.inputTF.text = self.unauthorizedInfo.name;
        }else
        {
            cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
        }
        ( self.operationType != 0 ) ? (cell.inputTF.enabled = NO ):(cell.inputTF.enabled = YES);
    }else if (indexPath.row == 1){
        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        if ( self.unauthorizedInfo.phoneNumber != nil ) {
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
            self.unauthorizedInfo.phoneNumber = inputStr;
        }
    };
    return cell;
}

- (CardNumberAndDateCell *)getCardNumberAndDateCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CardNumberAndDateCell";
    CardNumberAndDateCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardNumberAndDateCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.unauthorizedInfo.cardNumberArr count] > indexPath.row - 2 && ![[self.unauthorizedInfo.cardNumberArr objectAtIndex:indexPath.row-2] isEqualToString:@""]) {
        cell.cardNumberTF.text = [NSString stringWithFormat:@"%@", self.unauthorizedInfo.cardNumberArr[indexPath.row-2]];
    }else
    {
        DLog(@"%@", _inputPlaceHoldersArr[indexPath.row]);
        cell.cardNumberTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
    }
    
    if ([self.unauthorizedInfo.billDateArr count] > indexPath.row - 2 && ![[self.unauthorizedInfo.billDateArr objectAtIndex:indexPath.row-2] isEqualToString:@""]) {
        cell.billDateTF.text = [NSString stringWithFormat:@"%@", self.unauthorizedInfo.billDateArr[indexPath.row-2]];
        DLog(@"cell.cardNumberTf.text = %@", cell.billDateTF.text);
    }else
    {
        cell.billDateTF.placeholder =  [NSString stringWithFormat:@"%@", @"账单日"];
    }
    
    if ([self.unauthorizedInfo.bankNameArr count] > indexPath.row - 2 && ![[self.unauthorizedInfo.bankNameArr objectAtIndex:indexPath.row-2] isEqualToString:@""]) {
        cell.bankNameTF.text = [NSString stringWithFormat:@"%@", self.unauthorizedInfo.bankNameArr[indexPath.row-2]];
    }else
    {
        cell.bankNameTF.placeholder =  [NSString stringWithFormat:@"%@", @"银行名称"];
    }
    
    ( self.operationType != 0 ) ? (cell.cardNumberTF.enabled = NO ):(cell.cardNumberTF.enabled = YES);
    ( self.operationType != 0 ) ? (cell.billDateTF.enabled = NO ):(cell.billDateTF.enabled = YES);
    ( self.operationType != 0 ) ? (cell.bankNameTF.enabled = NO ):(cell.bankNameTF.enabled = YES);
    
    if (indexPath.row < 2+self.addedCardNumberCnt) {
        cell.operationImage.image = [UIImage imageNamed:@"subCell"];
    }
    cell.buttonViewAction = ^{
        if (self.operationType != 0) {
            return;
        }
        if (indexPath.row < 2+self.addedCardNumberCnt) {
            //减少一行
            if ( self.addedCardNumberCnt > 0) {
                self.addedCardNumberCnt --;
                [_inputPlaceHoldersArr removeLastObject];
                [self.unauthorizedInfo.cardNumberArr replaceObjectAtIndex:indexPath.row-2 withObject:@""];
                [self.unauthorizedInfo.billDateArr replaceObjectAtIndex:indexPath.row-2 withObject:@""];
                [self.unauthorizedInfo.bankNameArr replaceObjectAtIndex:indexPath.row-2 withObject:@""];

                [self.phoneServiceInfoTable reloadData];
            }
            
        }else {
            self.addedCardNumberCnt++;
            [_inputPlaceHoldersArr addObject:@"填写卡号"];
            [self.phoneServiceInfoTable reloadData];
            DLog(@"buttonViewAction");
        }

    };
    
    cell.cardNumberBlcok = ^(NSString *cardNumber) {
        if (cardNumber.length == 0) {//信用卡号长度
            [ToolBox showAlertInfo:@"请填入正确的信用卡号"];
            return;
        }
        NSString *inputStr = [NSString stringWithString:cardNumber];
        [self.unauthorizedInfo.cardNumberArr replaceObjectAtIndex:indexPath.row-2 withObject:inputStr];
    };
    
    cell.billDateBlcok = ^(NSString *billDate) {
        NSString *inputStr = [NSString stringWithString:billDate];
        [self.unauthorizedInfo.billDateArr replaceObjectAtIndex:indexPath.row-2 withObject:inputStr];
    };
    
    cell.bankNameBlcok = ^(NSString *bankName) {
        if (bankName.length == 0) {//信用卡号长度
            [ToolBox showAlertInfo:@"请填入银行名称"];
            return;
        }
        NSString *inputStr = [NSString stringWithString:bankName];
        [self.unauthorizedInfo.bankNameArr replaceObjectAtIndex:indexPath.row-2 withObject:inputStr];
    };
    
    cell.cardNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    cell.billDateTF.keyboardType = UIKeyboardTypeNumberPad;
    return cell;
}

- (EditRemindDateCell *)getRemindTimeCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"EditRemindDateCell";
    EditRemindDateCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EditRemindDateCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.showListViewEvent=^{
        bShowDatePullList = YES;
        [tableview reloadData];
    };
    
    cell.hideListViewEvent = ^{
        bShowDatePullList = NO;
        [tableview reloadData];
    };
    
    cell.getDateText = ^(NSInteger idx, NSString *text){
        self.unauthorizedInfo.preRemindDays = text;
    };
    
    cell.getTimeText = ^(NSInteger idx, NSString *text){
        self.unauthorizedInfo.remindTime = text;
    };
    
    [cell setBlock];
    
    [cell setDateDataSoure:preRemindDaysArr andTimeDataSource:remindTimeArr];
    [cell setPullMenuState:bShowDatePullList];
    [cell setDate:[preRemindDaysArr indexOfObject:self.unauthorizedInfo.preRemindDays]  andTime: [remindTimeArr indexOfObject:self.unauthorizedInfo.remindTime]];
    
//    [cell setShowSmallImageView:YES];
    
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
//        [cell setSelectText:[NSString stringWithFormat:@"%@", inputStr]];
        [cell setSelectDataIdx:idx];
    }else {
//        [cell setSelectText:[NSString stringWithFormat:@"6"]];
        [cell setSelectDataIdx:0];
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
//    for (int i = 0; i <= self.addedCardNumberCnt; i++) {
//        NSString *cardStr = self.unauthorizedInfo.bankNameArr[i];
//        if ([cardStr isEqualToString:@""]) {
//            [ToolBox showAlertInfo:@"银行名称不能为空"];
//            bBreak = true;
//            break;
//        }
//    }
//    if (bBreak) {
//        return;
//    }
    
    //拼接卡号参数
    for (NSString *str in self.unauthorizedInfo.cardNumberArr ) {
        if (![str isEqualToString:@""]) {
            [cards appendFormat:@"%@,",str];
        }
    }
    //拼接银行名称参数
    NSMutableString *bankName = [[NSMutableString alloc] init];
    [bankName appendString:@""];
    for (NSString *str in self.unauthorizedInfo.bankNameArr ) {
        if (![str isEqualToString:@""]) {
            [bankName appendFormat:@"%@,",str];
        }
    }
    
    NSMutableString *billDate = [[NSMutableString alloc] init];
    for (NSString *str in self.unauthorizedInfo.billDateArr ) {
        if (![str isEqualToString:@""]) {
            [billDate appendFormat:@"%@,",str];
        }
    }
    
    if (self.unauthorizedInfo.name == nil || [self.unauthorizedInfo.name isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"姓名不能为空"];
        return;
    }else if(self.unauthorizedInfo.phoneNumber == nil || [self.unauthorizedInfo.phoneNumber isEqualToString:@""]){
        [ToolBox showAlertInfo:@"手机号不能为空"];
        return;
    }else if ([billDate isEqualToString:@""]){
        [ToolBox showAlertInfo:@"账单日不能为空"];
        return;
    }else if(!self.unauthorizedInfo.agreeProtol) {
        [ToolBox showAlertInfo:@"是否同意服务条款"];
        return;
    }else{
        
        NSString *callTime = [NSString stringWithFormat:@"%ld", [remindTimeArr indexOfObject: self.unauthorizedInfo.remindTime]+1];
        NSString *forwardTime = [NSString stringWithFormat:@"%ld", [preRemindDaysArr indexOfObject: self.unauthorizedInfo.preRemindDays]+1];
        
        NSDictionary *parasDct;
        if (self.operationType == 0) {
            requstUrlString = AddPhoneService;
            parasDct = [self getAddPhoneServiceParametesCards:cards andBillDate:billDate andCallTime:callTime andForwardTime:forwardTime andBankName:bankName];
        }else if (self.operationType == 1) {
            requstUrlString = ContPhoneService;
            parasDct = [self getContPhoneServiceParametesCards:cards andBillDate:billDate andCallTime:callTime andForwardTime:forwardTime andBankName:bankName];
        }else if (self.operationType == 2) {
            requstUrlString = EditPhoneService;
            parasDct = [self getContPhoneServiceParametesCards:cards andBillDate:billDate andCallTime:callTime andForwardTime:forwardTime andBankName:bankName];
        }else if (self.operationType == 3) {
            requstUrlString = CEditPhoneService;
            parasDct = [self getContPhoneServiceParametesCards:cards andBillDate:billDate andCallTime:callTime andForwardTime:forwardTime andBankName:bankName];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSwingCardServiceNotification:) name:requstUrlString object:nil];
        [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl, requstUrlString] andParameters:parasDct andNotificationName:requstUrlString];
    }
}

//添加未通过重新编辑和续保编辑以及续保未通过重新编辑的参数一样
- (NSDictionary *)getContPhoneServiceParametesCards:(NSString *)cards andBillDate:(NSString *)billDate andCallTime:(NSString *)callTime andForwardTime:(NSString *)forwardTime andBankName:(NSString *)bankName {
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc] init];
    [paraDict setObject:self.unauthorizedInfo.productId forKey:@"id"];
    [paraDict setObject:self.serviceInfo.serviceId forKey:@"serviceId"];
    [paraDict setObject:self.unauthorizedInfo.name forKey:@"memberName"];
    [paraDict setObject:self.unauthorizedInfo.phoneNumber forKey:@"contact"];
    [paraDict setObject:self.unauthorizedInfo.servicePeriod forKey:@"serviceCycle"];
    [paraDict setObject:self.unauthorizedInfo.totalCost forKey:@"cost"];
    [paraDict setObject:cards forKey:@"cards"];
    [paraDict setObject:bankName forKey:@"cardName"];
    [paraDict setObject:billDate forKey:@"billDate"];
    [paraDict setObject:callTime forKey:@"callTime"];
    [paraDict setObject:forwardTime forKey:@"forwardTime"];
    return paraDict;
}

- (NSDictionary *)getAddPhoneServiceParametesCards:(NSString *)cards andBillDate:(NSString *)billDate andCallTime:(NSString *)callTime andForwardTime:(NSString *)forwardTime andBankName:(NSString *)bankName {
    NSDictionary *parasDct = @{
                               @"serviceId":self.serviceInfo.serviceId,
                               @"memberId":@"",
                               @"memberName":self.unauthorizedInfo.name,
                               @"contact":self.unauthorizedInfo.phoneNumber,
                               @"serviceCycle":self.unauthorizedInfo.servicePeriod,
                               @"cost":self.unauthorizedInfo.totalCost,
                               @"identityCard":@"",
                               @"cards":cards,
                               @"cardName":bankName,
                               @"billDate":billDate,
                               @"callTime":callTime,
                               @"forwardTime":forwardTime
                               };
    return parasDct;
}

- (void)addSwingCardServiceNotification:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requstUrlString object:nil];
    DLog(@"resultDic = %@", resultDic);
    if ([resultDic objectForKey:@"responseObject"]) {
        NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
        NSString *msg = [responseObject objectForKey:@"MSG"];
        [ToolBox showAlertInfo:msg];
        if (self.operationType == 0 || self.operationType == 1) {//到付款页面
            PhonePayServiceInfo *payServiceVc = [[PhonePayServiceInfo alloc] init];
            payServiceVc.unautoProtectionInfo = self.unauthorizedInfo;
            [self.navigationController pushViewController:payServiceVc animated:YES];
        }
    }else{
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"tableView");
    if (indexPath.row == 3+self.addedCardNumberCnt) {
        bShowDatePullList = !bShowDatePullList;
        [tableView reloadData];
//        bShowTimePullList = !bShowTimePullList;
    }
    else if (indexPath.row == 4+self.addedCardNumberCnt) {
        bShowPullDownList = !bShowPullDownList;
        [tableView reloadData];
    }
    
}
@end
