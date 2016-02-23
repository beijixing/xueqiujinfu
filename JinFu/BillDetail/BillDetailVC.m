//
//  BillDetailVC.m
//  JinFu
//
//  Created by ybon on 15/12/21.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "BillDetailVC.h"
#import "AFNetManager.h"
#import "TableHeaderView.h"
#import "BillDetailCellOne.h"
#import "BillDetailCellTwo.h"
#import "BillDetailCellThree.h"
#import "BankCardIconManager.h"
#import "DBManager.h"
#import "BillDetailDataModel.h"
#import "BillInfoDataModel.h"
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD.h"
#define lastOpenSection 9999

@interface BillDetailVC ()<TableHeaderViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *_sourceDataArray;  //  默认数据
    NSMutableArray *_sourceDataOpenState;
    NSInteger _lastOpenedSection;  //  记录上次打开的setion
    BOOL bShowPullView;
}
@end

@implementation BillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
      _lastOpenedSection = lastOpenSection;
    self.navigationController.navigationBarHidden = NO;

    
    [self initBankCardInfo];
    _sourceDataOpenState = [[NSMutableArray alloc] init];
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0 || [[UserInfoModel sharedUserInfo].loginSuccess isEqualToString:@"false"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _sourceDataArray = [[DBManager sharedDBManager] queryBillInfoDataWithCardId:self.bankCardId];
            [self initSourceDataOpenState];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.billDetailGroupTable reloadData];
            });
        });
    }else{
        [self sendBillDetailRequest];
    }
    self.billDetailGroupTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent)];
    [self.payButtonView addGestureRecognizer:tapGesture];
    self.payPartTF.delegate = self;
    bShowPullView = false;
    
    UITapGestureRecognizer *hideTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGestureEvent)];
    [self.view addGestureRecognizer:hideTapGesture];
    
     self.navigationItem.title = @"账单详情";
    [self configNavigationLeftButton];
    [self.view bringSubviewToFront:self.cardInfoView];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)hideGestureEvent {
    bShowPullView = false;
    self.pullMenuView.hidden = YES;
}

- (void)tapGestureEvent {
    bShowPullView = !bShowPullView;
    if (bShowPullView) {
        self.pullMenuView.hidden = NO;
    }else{
        self.pullMenuView.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)initBankCardInfo{
    self.bankNameAndNumber.text = [NSString stringWithFormat:@"%@ %@", self.bankCardInfo.bankName, self.bankCardInfo.cardLastNum];
    NSString *iconPath = [[BankCardIconManager sharedManager] getBankIconPathWithName:self.bankCardInfo.bankName];
    self.bankCardIconImageView.image = ImageName(iconPath);
    
    self.debt.text = [NSString stringWithFormat:@"%@", self.bankCardInfo.debt];
    self.minpay.text = [NSString stringWithFormat:@"%@", self.bankCardInfo.minPay];
    self.totalAmount.text = [NSString stringWithFormat:@"%@", self.bankCardInfo.creditLine];
    self.totalIntegeral.text = [NSString stringWithFormat:@"%@", self.bankCardInfo.integral];

    NSMutableString *deadLine = [NSMutableString stringWithString:self.bankCardInfo.deadLine];
    [deadLine replaceOccurrencesOfString:@"-" withString:@"." options:NSWidthInsensitiveSearch range:NSMakeRange(0,10)];
    DLog(@"deadLine = %@",deadLine);
    self.deadDate.text = [NSString stringWithFormat:@"还款日%@", [deadLine substringWithRange:NSMakeRange(5, 6)]];
    NSString *dateNowStr = [ToolBox getDateStringWithDate:[[NSDate date] description] dateFormat:@"yyyy-MM-dd HH:mm:ss z" destFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *cdTimeStr = [ToolBox getDaysBetweenEndDate:[NSMutableString stringWithString: self.bankCardInfo.deadLine] andStartDate:dateNowStr withDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    self.cdTime.text = [NSString stringWithFormat:@"%@", cdTimeStr];
    
    if ([self.bankCardInfo.payStatus isEqualToString:@"0"]) {
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg0"];
         self.payStateLabel.text = @"未还款";
    }else if ([self.bankCardInfo.payStatus isEqualToString:@"1"]){
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg1"];
         self.payStateLabel.text = @"已还款";
    }else if ([self.bankCardInfo.payStatus isEqualToString:@"3"]) {
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg2"];
         self.payStateLabel.text = self.bankCardInfo.partPayNum;
    }
}


- (void)sendBillDetailRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBillDetailNotification:) name:BillDetail object:nil];
    NSString *parameter = [NSString stringWithFormat:@"%@id=%@",BillDetail, self.bankCardId];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:parameter andNotificationName:BillDetail];
}

- (void)getBillDetailNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BillDetail object:nil];
    
    _sourceDataArray = [[NSMutableArray alloc] init];
    NSArray *billDetailArr = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"responseObject"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dataDict in billDetailArr) {
            BillInfoDataModel *billInfoModel = [[BillInfoDataModel alloc] init];
            billInfoModel.period = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"period"]];
            billInfoModel.billId = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"id"]];
            billInfoModel.cardId = self.bankCardInfo.cardId;
            billInfoModel.integral = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"integral"]];
            
            NSString *sendDate = [dataDict objectForKey:@"sendDate"];
            if (![sendDate isKindOfClass:[NSNull class]]) {
                billInfoModel.billMonth = [NSString stringWithFormat:@"%@", [sendDate substringWithRange:NSMakeRange(5, 2)]];
            }
            
            billInfoModel.newlyGainedIntegral = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"newlyGainedIntegral"]];
            billInfoModel.debt = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"debt"]];
            billInfoModel.repayment = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"repayment"]];
            
            NSArray *billDetails = [dataDict objectForKey:@"details"];
            for (NSDictionary *detailDict in billDetails) {
                DLog(@"detailDict = %@", detailDict);
                NSString *amount = [NSString stringWithFormat:@"%@", [detailDict objectForKey:@"amount"]];
                if ([amount floatValue] > 0) {
                    BillDetailDataModel *detailDataModel = [[BillDetailDataModel alloc] init];
                    detailDataModel.amount = [NSString stringWithFormat:@"%@", [detailDict objectForKey:@"amount"]];
                    detailDataModel.currency = [NSString stringWithFormat:@"%@", [detailDict objectForKey:@"currency"]];
                    detailDataModel.billDescription = [NSString stringWithFormat:@"%@", [detailDict objectForKey:@"description"]];
                    detailDataModel.postedDate = [NSString stringWithFormat:@"%@", [detailDict objectForKey:@"postedDate"]];
                    detailDataModel.billId = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"id"]];
                    [billInfoModel.details addObject:detailDataModel];
                }
            }
            
            [_sourceDataArray addObject:billInfoModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self initSourceDataOpenState];
            [self.billDetailGroupTable reloadData];
        });
        
        //数据存储
        [[DBManager sharedDBManager] saveBillInfoData:_sourceDataArray withCardId:self.bankCardId];
    });
    
}


- (void)initSourceDataOpenState{
    for (int i = 0; i< [_sourceDataArray count]; i++) {
        [_sourceDataOpenState addObject:[NSNumber numberWithBool:false]];
    }
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sourceDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BillInfoDataModel *billInfo = _sourceDataArray[section];
    NSNumber *number = _sourceDataOpenState[section];
    BOOL state = [number boolValue];
    if (state) {
        NSArray *details = billInfo.details;
        ;
        if (details.count >0){
            return [details count]+3;
        }else {
            return [details count]+2;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
         static NSString *cellIdentify = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }else if (indexPath.row == 1) {
        static NSString *cellIdentify = @"CellOne";
        BillDetailCellOne *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BillDetailCellOne" owner:self options:nil] lastObject];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        BillInfoDataModel *billInfoModel = _sourceDataArray[indexPath.section];
        cell.totalIntegral.text = [NSString stringWithFormat:@"%@", billInfoModel.integral];
        cell.currMonthNewIntegral.text = [NSString stringWithFormat:@"%@", billInfoModel.newlyGainedIntegral];
        cell.lastPaiedAmount.text = [NSString stringWithFormat:@"%@", billInfoModel.repayment];
        cell.currMonthAmount.text = [NSString stringWithFormat:@"%@", billInfoModel.debt];
       
        if (billInfoModel.details.count == 0) {
            cell.layer.cornerRadius = 10;
        }else {
            [self circleTopCorner:cell];
        }
        return cell;
    }else if (indexPath.row == 2) {
        static NSString *cellIdentify = @"CellTwo";
        BillDetailCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BillDetailCellTwo" owner:self options:nil] lastObject];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else {
        static NSString *cellIdentify = @"CellThree";
        BillDetailCellThree *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BillDetailCellThree" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        BillInfoDataModel *billInfoModel = _sourceDataArray[indexPath.section];
        NSArray *details = billInfoModel.details;
        BillDetailDataModel *billDetailData = [details objectAtIndex:indexPath.row - 3];
        
        NSString *transDate = [NSString stringWithString:billDetailData.postedDate];
        cell.date.text = [ToolBox getDateStringWithDate:transDate dateFormat:@"yyyy-MM-dd HH:mm:ss" destFormat:@"MMdd"];
        cell.amount.text = [NSString stringWithFormat:@"%@", billDetailData.amount];
        cell.payway.text = [NSString stringWithFormat:@"%@", billDetailData.billDescription];
        cell.place.text = [NSString stringWithFormat:@"%@", billDetailData.currency];
        if (indexPath.row - 3 == details.count-1) {
            [self circleBottomCorner:cell];
        }
        return cell;
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 4;
    }else if (indexPath.row == 1) {
        return 81;
    }else if (indexPath.row == 2){
        return 40;
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(MainScreenWidth > 320) {
        return 15;
    }else {
        return 10;
    }    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    view.backgroundColor = [UIColor whiteColor];
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerFooterViewIdentify = @"headerFooter";
    TableHeaderView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewIdentify];
    if (!headerFooterView) {
        headerFooterView = [[TableHeaderView alloc] initWithReuseIdentifier:headerFooterViewIdentify];
        headerFooterView.delegate = self;
        headerFooterView.contentView.backgroundColor = [UIColor whiteColor];
    }
    
//    ProductModel *productModel = _sourceDataArray[section];
//    headerFooterView.sectionTitle = [NSString stringWithFormat:@"%@ -- >%ld",productModel.productName,section];
//    headerFooterView.isOpen = productModel.isOpen;
    
    BillInfoDataModel *billInfoModel = _sourceDataArray[section];
    headerFooterView.sectionIndex = section;
    headerFooterView.sectionTitle = [NSString stringWithFormat:@"%@", billInfoModel.period];
//    DLog(@"period = %@",[dataDict objectForKey:@"period"]);
//    DLog(@"length = %d", [period length]);
    headerFooterView.month = [NSString stringWithFormat:@"%@月", billInfoModel.billMonth];
    headerFooterView.isOpen = [_sourceDataOpenState[section] boolValue];
    headerFooterView.layer.cornerRadius = 10;
    return headerFooterView;
}


- (void)circleTopCorner:(UITableViewCell *)cell {
    CGRect bounds = CGRectMake(0, 0,  self.billDetailGroupTable.frame.size.width, cell.frame.size.height);
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    maskLayer.frame=cell.layer.bounds;
    maskLayer.path=maskPath.CGPath;
    cell.layer.mask=maskLayer;
    cell.layer.masksToBounds=YES;
}

- (void)circleBottomCorner:(UITableViewCell *)cell {
    CGRect bounds = CGRectMake(0, 0,  self.billDetailGroupTable.frame.size.width, cell.frame.size.height);
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    maskLayer.frame=cell.layer.bounds;
    maskLayer.path=maskPath.CGPath;
    cell.layer.mask=maskLayer;
    cell.layer.masksToBounds=YES;
}

#pragma mark - TableHeaderViewDelegate
- (void)headerViewDidTaped:(TableHeaderView *)tableHeaderView sectionIndex:(NSInteger)sectionIndex
{
    if (_lastOpenedSection != lastOpenSection  &&  _lastOpenedSection != sectionIndex) {
          //说明 有未关闭section 需先关闭
        NSNumber *number = _sourceDataOpenState[_lastOpenedSection];
        if ([number boolValue]) {
            NSNumber *numberNew = [NSNumber numberWithBool:![number boolValue]];
            [_sourceDataOpenState replaceObjectAtIndex:_lastOpenedSection withObject:numberNew];
        }
    }
    
    NSNumber *number = _sourceDataOpenState[sectionIndex];
    NSNumber *numberNew = [NSNumber numberWithBool:![number boolValue]];
    [_sourceDataOpenState replaceObjectAtIndex:sectionIndex withObject:numberNew];
    _lastOpenedSection = sectionIndex;
    [_billDetailGroupTable reloadData];
}

- (IBAction)unpaiedButtonClick:(UIButton *)sender {
    self.payStateLabel.text = @"未还款";//0
    //通知服务端
    [self setPayState:@"0" andPaidMoney:@"0"];
    self.bankCardInfo.payStatus = @"0";
    self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg0"];
    [[DBManager sharedDBManager] updateBankCardListData:self.bankCardInfo];
}

- (IBAction)paiedButtonClick:(UIButton *)sender {
    self.payStateLabel.text = @"已还款";//1
    //通知服务端
    [self setPayState:@"1" andPaidMoney:@"0"];
    self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg1"];

    self.bankCardInfo.payStatus = @"1";
    [[DBManager sharedDBManager] updateBankCardListData:self.bankCardInfo];
}

- (IBAction)payPartButtonClick:(UIButton *)sender {
//    self.payStateLabel.text = @"部分还款";//3
    //通知服务端
    if ([self.payPartTF.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"请输入部分还款金额"];
    }else{
        [self setPayState:@"3" andPaidMoney:self.payPartTF.text];
        self.payStateBgImageView.image = [UIImage imageNamed:@"payStateBg2"];
        self.bankCardInfo.payStatus = @"3";
        self.bankCardInfo.partPayNum = [NSString stringWithFormat:@"%@", self.payPartTF.text];
        [[DBManager sharedDBManager] updateBankCardListData:self.bankCardInfo];
        self.payStateLabel.text = self.payPartTF.text;
    }
}

- (void)setPayState:(NSString *)state andPaidMoney:(NSString *)paid {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(billUpdateNotification:) name:BillUpdate object:nil];
    NSString *parameter = [NSString stringWithFormat:@"%@id=%@&status=%@&paid=%@",BillUpdate, self.bankCardInfo.billId, state, paid];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:parameter andNotificationName:BillUpdate];
}
- (void)billUpdateNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BillUpdate object:nil];
    DLog(@"resultDic = %@", resultDic);
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        self.payStateLabel.text = textField.text;
    }
}
@end
