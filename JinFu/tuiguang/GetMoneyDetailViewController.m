//
//  GetMoneyDetailViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "GetMoneyDetailViewController.h"
#import "IncomeDetailTableViewCell.h"
#import "QGConfig.h"
#import "QGTools.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "WithdrawDetail.h"
#import "DBManager.h"
#import "AFNetworkReachabilityManager.h"
@interface GetMoneyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GetMoneyDetailViewController
{
    UITableView * _tableView;
    NSMutableArray * _withdrawMomeyDataArr;
    UILabel * labelNum;
    float totalCount;
    float y;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提现明细";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        _withdrawMomeyDataArr = [[DBManager sharedDBManager] queryWithdrawDetail];
        [self updateTotalIncomeCount];
    }else{
        [self requestData];
    }
    [self initData];
    totalCount = 0;
}
- (void)initUI
{
    [self createView];
    [self createTableView];
}
- (void)initData
{
    
}
- (void)createView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    view.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    [self.view addSubview:view];
    //创建历史总收入 label
    UILabel * labelIncome = [[UILabel alloc]initWithFrame:CGRectMake(70*SCALE, 30, 80*SCALE, 20)];
    labelIncome.text = @"历史总提现";
    labelIncome.font = [UIFont systemFontOfSize:13];
    [view addSubview:labelIncome];
    //创建历史总收入金额 label
    labelNum = [[UILabel alloc]initWithFrame:CGRectMake(150*SCALE, 5, 180*SCALE, 60)];
    labelNum.textColor = [UIColor redColor];
    labelNum.font = [UIFont systemFontOfSize:25];
    [view addSubview:labelNum];
    //创建button 分类
    NSArray * arrayBtnTitle = @[@"提现日期",@"提现金额",@"状态"];
    for (int i = 0; i<3; i++) {
        UIButton * buttonTitle = [QGTools createButton:CGRectMake(40+90*i*SCALE, 80, 80*SCALE, 30) bgColor:nil title:arrayBtnTitle[i] titleColor:[UIColor blackColor] tag:101+i action:nil vc:self];
    buttonTitle.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:buttonTitle];
        }
}
- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * URL = [HostUrl stringByAppendingString:Get_My_WithDrawal];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self finishedDownloadData:responseObject];
        //DLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@",error);
    }];
}
- (void)finishedDownloadData:(NSData *)data
{
    _withdrawMomeyDataArr = [[NSMutableArray alloc] init];
    NSArray *arrayData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    DLog(@"%@",arrayData);
    for (NSDictionary * dic in arrayData) {
        WithdrawDetail *withDrawModel = [[WithdrawDetail alloc] init];
        withDrawModel.date = [NSString stringWithFormat:@"%@", dic[@"requestDate"]];
        withDrawModel.count = [NSString stringWithFormat:@"%@", dic[@"amount"]];
        withDrawModel.state = [NSString stringWithFormat:@"%@", dic[@"status"]];
        [_withdrawMomeyDataArr addObject:withDrawModel];
    }
    [self updateTotalIncomeCount];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_tableView reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DBManager sharedDBManager] saveWithdrawDetail:_withdrawMomeyDataArr];
    });
}

- (void)updateTotalIncomeCount {
    for (int i = 0; i<_withdrawMomeyDataArr.count; i++) {
        WithdrawDetail *withDrawModel = _withdrawMomeyDataArr[i];
        totalCount += [withDrawModel.count floatValue];
    }
    labelNum.text = [NSString stringWithFormat:@"%.2f",totalCount];
}

- (void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    //    _tableView.scrollEnabled = NO;
    self.edgesForExtendedLayout = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, MainScreenWidth, MainScreenHeight-64-49-110) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _withdrawMomeyDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"cellId";
    IncomeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[IncomeDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    WithdrawDetail *withDrawModel = _withdrawMomeyDataArr[indexPath.row];
    cell.labelGetNum.text = [NSString stringWithFormat:@"%@",withDrawModel.count];
    NSString * strDate = [NSString stringWithFormat:@"%@",withDrawModel.date];
    cell.labelGetDate.text = [strDate substringToIndex:10];
    if ([withDrawModel.state isEqualToString:@"0"])
    {
        cell.labelState.text = @"未结";
    }
    else{
        cell.labelState.text = @"已结";
    }
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
@end
