//
//  AddPosInfoVC.m
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "AddPosInfoVC.h"
#import "CommitCell.h"
#import "TotalPaymentCell.h"
#import "UserInfoInputCell.h"
#import "PosPayServiceVC.h"
#import "AFNetManager.h"

@interface AddPosInfoVC ()
{
//    ServiceInfoModel *_unauthorizedInfo;
    NSMutableArray *_inputDataArr;
    NSMutableArray *_inputPlaceHoldersArr;
    NSString *requstUrlString;
}
@end

@implementation AddPosInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _inputPlaceHoldersArr = [NSMutableArray arrayWithObjects:@"姓名",@"手机号",@"地址", nil];
    _inputDataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        [_inputDataArr addObject:@""];
    }
    
    if (!self.unauthorizedInfo) {
        self.unauthorizedInfo = [[ServiceInfoModel alloc] init];
    }
    self.addPosInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addPosInfoTable.scrollEnabled = false;
    
    self.navigationItem.title = @"POS机";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 120;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 3) {
        return [self getInputCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 3) {
        return [self getTotalPaymentCellOfTableview:tableView andIndexPath:indexPath];
    }else if (indexPath.row == 4) {
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
        if (  self.unauthorizedInfo.name != nil ) {
            cell.inputTF.text =  self.unauthorizedInfo.name;
        }else
        {
            cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
        }
    }else if (indexPath.row == 1){
        cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
        if (  self.unauthorizedInfo.phoneNumber != nil ) {
            cell.inputTF.text =  self.unauthorizedInfo.phoneNumber;
        }else
        {
            cell.inputTF.placeholder =  [NSString stringWithFormat:@"%@", _inputPlaceHoldersArr[indexPath.row]];
        }
    }else if (indexPath.row == 2){
        if (  self.unauthorizedInfo.phoneNumber != nil ) {
            cell.inputTF.text =  self.unauthorizedInfo.posAddress;
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
        }else if (indexPath.row == 2){
             self.unauthorizedInfo.posAddress = inputStr;
        }
    };
    return cell;
}

- (TotalPaymentCell *)getTotalPaymentCellOfTableview:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"TotalPaymentCell";
    TotalPaymentCell *cell = [tableview dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TotalPaymentCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *money = self.posInfo.servicePrice;
     self.unauthorizedInfo.totalCost = money;
    cell.totalCount.text = [NSString stringWithFormat:@"￥%@", money];
//    [_inputDataArr replaceObjectAtIndex:indexPath.row withObject:cell.totalCount.text];
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
        DLog(@"commit info");
    };
    
    return cell;
}

- (void)commitProtectionInfo{
    if ( self.unauthorizedInfo.name == nil || [ self.unauthorizedInfo.name isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"姓名不能为空"];
        return;
    }else if( self.unauthorizedInfo.phoneNumber == nil || [ self.unauthorizedInfo.phoneNumber isEqualToString:@""]){
        [ToolBox showAlertInfo:@"手机号不能为空"];
        return;
    }else if( self.unauthorizedInfo.posAddress == nil || [ self.unauthorizedInfo.posAddress isEqualToString:@""]){
        [ToolBox showAlertInfo:@"地址不能为空"];
        return;
    }else if(! self.unauthorizedInfo.agreeProtol) {
        [ToolBox showAlertInfo:@"是否同意服务条款"];
        return;
    }else{
        NSDictionary *parasDct ;
        if (self.operationType == 0) {
            requstUrlString = AddPOSService;
            parasDct = [self getAddPOSServiceParameter];
            DLog(@"AddPOSService");
        }else if (self.operationType == 1){
            requstUrlString = EditPOSService;
            parasDct = [self getEditPOSServiceParameter];
            DLog(@"EditPOSService");
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPOSServiceNotification:) name:requstUrlString object:nil];
        [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl, requstUrlString] andParameters:parasDct andNotificationName:requstUrlString];
    }
}

- (NSDictionary *)getAddPOSServiceParameter {
    NSDictionary *parasDct = @{
                               @"serviceId":self.posInfo.serviceId,
                               @"memberId":@"",
                               @"memberName": self.unauthorizedInfo.name,
                               @"contact": self.unauthorizedInfo.phoneNumber,
                               @"cost": self.unauthorizedInfo.totalCost,
                               @"identityCard":@"",
                               @"address": self.unauthorizedInfo.posAddress,
                               };
    return parasDct;
}

- (NSDictionary *)getEditPOSServiceParameter {
    NSDictionary *parasDct = @{
                               @"serviceId":self.posInfo.serviceId,
                               @"memberId":@"",
                               @"memberName": self.unauthorizedInfo.name,
                               @"contact": self.unauthorizedInfo.phoneNumber,
                               @"cost": self.unauthorizedInfo.totalCost,
                               @"identityCard":@"",
                               @"address": self.unauthorizedInfo.posAddress,
                               @"id":self.unauthorizedInfo.productId
                               };
    return parasDct;
}

- (void)addPOSServiceNotification:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:requstUrlString object:nil];
    DLog(@"resultDic = %@", resultDic);
    if ([resultDic objectForKey:@"responseObject"]) {
        NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
        NSString *msg = [responseObject objectForKey:@"MSG"];
        [ToolBox showAlertInfo:msg];
        if (self.operationType == 0) {
            PosPayServiceVC *payWayVc = [[PosPayServiceVC alloc] init];
            payWayVc.unautoProtectionInfo = _unauthorizedInfo;
            [self.navigationController pushViewController:payWayVc animated:YES];
        }
        
    }else{
        
    }
    
}

@end
