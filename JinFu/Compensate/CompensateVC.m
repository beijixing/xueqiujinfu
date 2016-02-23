//
//  CompensateVC.m
//  JinFu
//
//  Created by ybon on 16/2/3.
//  Copyright © 2016年 ybon. All rights reserved.
//

#import "CompensateVC.h"
#import "AFNetManager.h"
#import "CompensateCell.h"
#import "CompensateDataModel.h"
#import "LostCardPaymentsDetailVC.h"
#import "UnauthorizedPaymentsDetailVC.h"

@interface CompensateVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_compensateArr;
}
@end

@implementation CompensateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"交易记录";
    self.compensateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self sendCompensateListRequest];
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)sendCompensateListRequest {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(compensateListNotification:) name:GetMemberPaymentByMID object:nil];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@", HostUrl, GetMemberPaymentByMID];
    [[AFNetManager sharedManager] postDataToServerWithHostUrl:fullUrl andParameters:nil andNotificationName:GetMemberPaymentByMID];
}

- (void)compensateListNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"%@", userInfo);
    NSArray *responseobj = [userInfo objectForKey:@"responseObject"];
    _compensateArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dataDict in responseobj) {
        CompensateDataModel *dataModel = [CompensateDataModel getInstanceWithDataDict:dataDict];
        [_compensateArr addObject:dataModel];
    }
    
    [self.compensateTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _compensateArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    CompensateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CompensateCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CompensateDataModel *dataModel = _compensateArr[indexPath.row];
    CompensateCell *showCell = (CompensateCell *)cell;
    showCell.compensateTitle.text = dataModel.compensateTitle;
    showCell.applyTime.text = dataModel.appyTime;
    showCell.state.text = dataModel.stateStr;
    if (dataModel.state == 0) {
        showCell.stateBg.image = [UIImage imageNamed:@"payStateBg2"];
    }else if(dataModel.state == 1) {
        showCell.stateBg.image = [UIImage imageNamed:@"payStateBg1"];
    }else if (dataModel.state == 2) {
        showCell.stateBg.image = [UIImage imageNamed:@"payStateBg0"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CompensateDataModel *dataModel = _compensateArr[indexPath.row];
    if (dataModel.compensateType == 1) {
        LostCardPaymentsDetailVC *detailVc = [[LostCardPaymentsDetailVC alloc] init];
        detailVc.dataModel = dataModel;
        [self.navigationController pushViewController:detailVc animated:YES];
    }else if (dataModel.compensateType == 2) {
        UnauthorizedPaymentsDetailVC *unauthorized = [[UnauthorizedPaymentsDetailVC alloc] init];
        unauthorized.dataModel = dataModel;
        [self.navigationController pushViewController:unauthorized animated:YES];
    }
}

@end
