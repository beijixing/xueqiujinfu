//
//  PayServiceVC.m
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "PosPayServiceVC.h"
#import "PayWayCell.h"
#import "ProtectionTitleCell.h"
#import "UserInfoCell.h"
#import "PaymentNumberCell.h"
#import "WXApiManager.h"
#import "AliPayApiManager.h"

@interface PosPayServiceVC ()
{
    NSArray *_payWays;
    NSArray *_titlesArr;
    NSString *_payCount;
}
@end

@implementation PosPayServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _payWays = [[NSArray alloc] initWithObjects: @[@"weChatIcon", @"微信付款"], @[@"zhifu", @"支付宝付款"], nil];
    _titlesArr = [[NSArray alloc] initWithObjects:@"", @"姓名",@"手机号码",@"寄送地址", nil ];
    
    
    self.payServiceInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.payServiceInfoTable.scrollEnabled = false;
    
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
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            return 50;
        }else if(indexPath.row == 4) {
            return 44;
        }else {
            return 30;
        }
    }else
    {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
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
        }else if(indexPath.row > 0 && indexPath.row < 4) {
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
    }else if (indexPath.row == 3){
        cell.keyText.text = [NSString stringWithFormat:@"%@：", POST_ADDRESS_STRING];
        cell.valueText.text = self.unautoProtectionInfo.posAddress;
    }
    return cell;
}

- (PaymentNumberCell *)getPaymentNumberCellOfTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    PaymentNumberCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PaymentNumberCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payNumber.text = self.unautoProtectionInfo.totalCost;
    
    return cell;
}

- (ProtectionTitleCell *)getProtectionTitleCellOfTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    ProtectionTitleCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProtectionTitleCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.image.image = ImageName(@"pos-anniu");
    cell.title.text = @"POS机";
    
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
}

@end
