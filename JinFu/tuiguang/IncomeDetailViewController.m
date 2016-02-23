//
//  IncomeDetailViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "IncomeDetailViewController.h"
#import "IncomeDetailTableViewCell.h"
#import "QGConfig.h"
#import "QGTools.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "IncomeDetail.h"
#import "DBManager.h"
#import "AFNetworkReachabilityManager.h"
@interface IncomeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation IncomeDetailViewController
{
    UITableView * _tableView;
    UILabel * labelIncome;
    UILabel * labelNum;
    float y;
    float totalCount;
    
    NSMutableArray *_incomeDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收入明细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    totalCount = 0;
    [self initUI];
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        _incomeDataArr = [[DBManager sharedDBManager] queryIncomeDetail];
        [self updateTotalIncomeCount];
    }else{
       [self requestData];
    }
    
}
- (void)initUI
{
    [self createView];
    [self createTabelView];
}

- (void)createView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 80)];
    view.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    [self.view addSubview:view];
    //创建历史总收入 label
    labelIncome = [[UILabel alloc]initWithFrame:CGRectMake(70*SCALE, 30, 80*SCALE, 20)];
    labelIncome.text = @"历史总收入";
    labelIncome.font = [UIFont systemFontOfSize:13];
    [view addSubview:labelIncome];
    //创建历史总收入金额 label
    labelNum = [[UILabel alloc]initWithFrame:CGRectMake(150*SCALE, 5, 180*SCALE, 60)];
    labelNum.text = @"";
    labelNum.textColor = [UIColor colorWithRed:250.0/255 green:211.0f/255 blue:115.0f/255 alpha:1.0f];
    labelNum.font = [UIFont systemFontOfSize:25];
    [view addSubview:labelNum];
    
    //创建button 分类
    NSArray * arrayBtnTitle = @[@"客户名称",@"收入金额",@"收入日期"];
    for (int i = 0; i<3; i++) {
        UIButton * buttonTitle = [QGTools createButton:CGRectMake(20+100*i*SCALE, 80, 80*SCALE, 30) bgColor:nil title:arrayBtnTitle[i] titleColor:[UIColor blackColor] tag:101+i action:nil vc:self];
        buttonTitle.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:buttonTitle];
    }
}
- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * URL = [HostUrl stringByAppendingString:Get_My_Commission];
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
    _incomeDataArr = [[NSMutableArray alloc] init];
    NSArray *arrayBack = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    DLog(@"dict == %@",arrayBack);
    for (NSDictionary * dict in arrayBack) {
        IncomeDetail *incomeModel = [[IncomeDetail alloc] init];
        incomeModel.customerName = [NSString stringWithFormat:@"%@", dict[@"member"][@"realname"]];
        incomeModel.date = [NSString stringWithFormat:@"%@", dict[@"incomDate"]];
        incomeModel.count = [NSString stringWithFormat:@"%@", dict[@"amount"]];
        [_incomeDataArr addObject:incomeModel];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[DBManager sharedDBManager] saveIncomeDetail:_incomeDataArr];
    });
    [self updateTotalIncomeCount];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_tableView reloadData];
}

- (void)updateTotalIncomeCount {
    for (int i = 0; i<_incomeDataArr.count; i++) {
        IncomeDetail *incomeModel = _incomeDataArr[i];
        totalCount += [incomeModel.count floatValue];
    }
    labelNum.text = [NSString stringWithFormat:@"%.2f",totalCount];
}

- (void)createTabelView
{
    self.automaticallyAdjustsScrollViewInsets = YES;
//    _tableView.scrollEnabled = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, MainScreenWidth, MainScreenHeight-64-49-110) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentSize = CGSizeZero;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _incomeDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * str = @"cellId";
    IncomeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
   
    if (cell == nil) {
        cell = [[IncomeDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    IncomeDetail *incomeModel = _incomeDataArr[indexPath.row];
    
    if (![self isBlankString:incomeModel.customerName]) {
        if (incomeModel.customerName.length >3) {
            NSString * subString = [incomeModel.customerName substringToIndex:3];
            cell.labelName.text = subString;
        }else{
            cell.labelName.text = [NSString stringWithFormat:@"%@", incomeModel.customerName];
        }
    }

    cell.labelNum.text = [NSString stringWithFormat:@"%@ 元", incomeModel.count];
    NSString * strDate = [NSString stringWithFormat:@"%@",incomeModel.date];
    cell.labelDate.text = [strDate substringToIndex:10];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
//判断一个字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
