//
//  PhonePayServiceInfo.m
//  JinFu
//
//  Created by ybon on 15/12/29.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "PhonePayServiceInfo.h"
#import "PayWayCell.h"
#import "UserInfoCell.h"
#import "TotalPaymentCell.h"
#import "PaymentNumberCell.h"
#import "ProtectionTitleCell.h"
#import "WXApiManager.h"
#import "AliPayApiManager.h"
@interface PhonePayServiceInfo ()
{
    NSArray *_payWays;
    int addedCardNumberCnt;
}
@end

@implementation PhonePayServiceInfo
- (void)viewDidLoad {
    [super viewDidLoad];
    _payWays = [[NSArray alloc] initWithObjects: @[@"weChatIcon", @"微信付款"], @[@"zhifu", @"支付宝付款"], nil];
    
    self.phoneServiceInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    addedCardNumberCnt = 0;
    NSArray *cardArr = self.unautoProtectionInfo.cardNumberArr;
    for (NSString *cardNumber in cardArr) {
        if (![cardNumber isEqualToString:@""]) {
            addedCardNumberCnt++;
        }
    }
    if (addedCardNumberCnt == 1) {
        //        addedCardNumberCnt = 0;
    }
    else {
        //        addedCardNumberCnt = addedCardNumberCnt - 1;
    }
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            return 50;
        }else if(indexPath.row == 5+2*addedCardNumberCnt) {
            return 44;
        }else
        {
            return 30;
        }
    }else
    {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6+2*addedCardNumberCnt;
    }else {
        return 2;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ( section == 1) {
        return 44;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [ToolBox createViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 44)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *title = [ToolBox createLabelWithFrame:CGRectMake(20, 0, 200, 44) textColor:[UIColor grayColor] backgroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:@"Arial" size:16] text:@"选择支付方式"];
    [view addSubview:title];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0 ) {
            return [self getProtectionTitleCellOfTableView:tableView andIndexPath:indexPath];
        }else if(indexPath.row > 0 && indexPath.row < 5+2*addedCardNumberCnt) {
            return [self getUserInfoCellOfTableView:tableView andIndexPath:indexPath];
        }else {
            return [self getPaymentNumberCellOfTableView:tableView andIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 1) {
        return [self getPayWayCellOfTableView:tableView andIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] init];
}

- (UserInfoCell *)getUserInfoCellOfTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    UserInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1) {
        cell.keyText.text = [NSString stringWithFormat:@"%@：", NAME_STRING];
        cell.valueText.text = self.unautoProtectionInfo.name;
    }else if (indexPath.row == 2){
        cell.keyText.text = [NSString stringWithFormat:@"%@：", PHONE_NUMBER_STRING];
        cell.valueText.text = self.unautoProtectionInfo.phoneNumber;
    }else if (indexPath.row < 3+2*addedCardNumberCnt){
       if(indexPath.row%2 == 0)
       {
           cell.keyText.text = [NSString stringWithFormat:@"%@：", BILL_DATE_STRING];
           cell.valueText.text = [NSString stringWithFormat:@"%@",   self.unautoProtectionInfo.billDateArr[(indexPath.row - 4)/2]];
       }else
       {
           cell.keyText.text = [NSString stringWithFormat:@"%@：", self.unautoProtectionInfo.bankNameArr[ (indexPath.row - 3)/2 ]];
           cell.valueText.text = [NSString stringWithFormat:@"%@",   self.unautoProtectionInfo.cardNumberArr[ (indexPath.row - 3)/2 ]];
              DLog(@"indexPath.row = %ld", indexPath.row);
       }
        
    }else if (indexPath.row == 3+2*addedCardNumberCnt){
        cell.keyText.text = [NSString stringWithFormat:@"%@：", REMIND_DATE_STRING];
        cell.valueText.text = [NSString stringWithFormat:@"%@  %@",   self.unautoProtectionInfo.preRemindDays, self.unautoProtectionInfo.remindTime];
    }else if(indexPath.row == 4+2*addedCardNumberCnt){
        cell.keyText.text = [NSString stringWithFormat:@"%@：", SERVIEC_PERIOD_STRING];
        cell.valueText.text = self.unautoProtectionInfo.servicePeriod;
    }
    else{
//        cell.keyText.text = @"";
//        cell.valueText.text = [NSString stringWithFormat:@"%@",   self.unautoProtectionInfo.cardNumberArr[indexPath.row - 4]];
    }
    return cell;
}

- (PaymentNumberCell *)getPaymentNumberCellOfTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    PaymentNumberCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PaymentNumberCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payNumber.text = [NSString stringWithFormat:@"￥%@", self.unautoProtectionInfo.totalCost];
    return cell;
}

- (ProtectionTitleCell *)getProtectionTitleCellOfTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    ProtectionTitleCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionTitleCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image.image = ImageName(@"dianhuafuwu-icon");
    cell.title.text = @"电话服务";
    return cell;
}

- (PayWayCell *)getPayWayCellOfTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    PayWayCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayWayCell" owner:self options:nil] lastObject];
    NSArray *infoArr = _payWays[indexPath.row];
    cell.payWayIcon.image = ImageName(infoArr[0]);
    cell.title.text = infoArr[1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==1) {
        if (indexPath.row == 0) {
            DLog(@"微信支付");
            [[WXApiManager sharedManager] payOrder];
        }else if(indexPath.row == 1)
        {
            DLog(@"支付宝支付");
            [[AliPayApiManager sharedManager] payOrder];
        }
    }
    DLog(@"%ld", indexPath.row);
}
@end
