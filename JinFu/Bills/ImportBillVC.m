//
//  ImportBillVC.m
//  JinFu
//
//  Created by ybon on 15/12/17.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "ImportBillVC.h"
#import "ImportBillTableCell.h"
#import "AFNetManager.h"
#import "JFTabBarController.h"
#import "ZFProgressView.h"

@interface ImportBillVC ()
{
    NSTimer *_progressTimer;
    NSMutableArray *_billDataArr;
    NSInteger _currentBillCount;
    NSInteger _totalBillCount;
    ZFProgressView *_zfProgressView;
}
@end

@implementation ImportBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = ViewMainColor;
    self.billsTableView.backgroundColor = [UIColor whiteColor];
    
    [self.billsTableView setMyViewLayerBoardColor:[UIColor whiteColor] AndBoardWidth:1 AndCornerRadius:10];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importBillNotification:) name:ImportBills object:nil];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:ImportBills andNotificationName:ImportBills];
//    ImportBills
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(sendProgressRequest) userInfo:nil repeats:YES];
    
    _currentBillCount = 0;
    _totalBillCount = 1;
    _billDataArr = [[NSMutableArray alloc] init];
    [self progressImageAnimation];
    self.billsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)progressImageAnimation {
    _zfProgressView = [[ZFProgressView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    _zfProgressView.innerBackgroundColor = [UIColor clearColor];
    [_zfProgressView setBackgroundStrokeColor:[UIColor colorWithRed:223/255.0 green:203/255.0 blue:175/255.0 alpha:1.0]];
    [_zfProgressView setProgressStrokeColor:[UIColor colorWithRed:253/255.0 green:179/255.0 blue:21/255.0 alpha:1.0]];
    [_zfProgressView setProgress:0.0 Animated:NO];
    [self.progressImage addSubview:_zfProgressView];
}

- (void)sendProgressRequest {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importProgressNotification:) name:ImportProgress object:nil];
    [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:ImportProgress andNotificationName:ImportProgress];
}

- (void)importProgressNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ImportProgress object:nil];
    DLog(@"resultDic = %@", resultDic);
    NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
    
    if (![[responseObject objectForKey:@"fetchedBills"] isEqual:[NSNull null]]) {
        _billDataArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"fetchedBills"]];
    }
    
    if (![[responseObject objectForKey:@"currentBillCount"] isEqual:[NSNull null]]) {
        _currentBillCount =  [[responseObject objectForKey:@"currentBillCount"] intValue];
    }
    
    if (![[responseObject objectForKey:@"totalBillCount"] isEqual:[NSNull null]]) {
        _totalBillCount =  [[responseObject objectForKey:@"totalBillCount"] intValue];
    }
    
    CGFloat percent = (CGFloat)_currentBillCount / (CGFloat)_totalBillCount * 100;
    [_zfProgressView setProgress:percent/100.0 Animated:YES];
    DLog(@"percent = %f _currentBillCount = %ld",  percent, _currentBillCount);
    self.importPercent.text = [NSString stringWithFormat:@"已导入%.0f%%", percent];
    [self.billsTableView reloadData];
    self.billCount.text = [NSString stringWithFormat:@"搜索到疑似账单%ld封", _totalBillCount];
    

    if (_totalBillCount == _currentBillCount) {
        [_progressTimer invalidate];
        [self presentViewController:[[JFTabBarController alloc] init] animated:YES completion:nil];
    }
}

- (void)importBillNotification:(NSNotification *)notification {
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ImportBills object:nil];
    DLog(@"resultDic = %@", resultDic);
    NSString *flag = [[resultDic objectForKey:@"responseObject"] objectForKey:@"flag"];
    DLog(@"flag = %@", flag);
    if ([flag isEqualToString:@"1"]) {
        [_progressTimer invalidate];
        [self presentViewController:[[JFTabBarController alloc] init] animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_billDataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cellName";
    ImportBillTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImportBillTableCell" owner:self options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *billData = [_billDataArr objectAtIndex:indexPath.row];
    
    
    cell.bankName.text = [billData objectForKey:@"cardname"];
    cell.billDate.text = [billData objectForKey:@"billDate"];
    return cell;
}

@end
