//
//  MyInComeViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/24.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "MyInComeViewController.h"
#import "QGConfig.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "WantGetMoneyViewController.h"
#import "IncomeDetailViewController.h"
#import "GetMoneyDetailViewController.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "UserInfoModel.h"
#import "DBManager.h"
#import <MBProgressHUD.h>
@interface MyInComeViewController ()

@end

@implementation MyInComeViewController
{
    NSDictionary * dic;
    NSDictionary * dict;
    UILabel * label;
    UIButton * btnGetMoney;
    UIScrollView * _scrollView;
    UILabel * label1;
    UILabel * labelInvite;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的收入";
    //隐藏系统默认导航栏左面的文字返回按钮
//    [self.navigationItem.backBarButtonItem setTitle:@""];
//    [self.navigationItem setHidesBackButton:YES];
    [self initScrollView];
    [self requestData];
    [self requestData2];
    [self requestData3];
    [self initData];
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0 && [[UserInfoModel sharedUserInfo].promoter isEqualToString:@"true"]) {
        [self hasUpaidMoneyUI];
        label.text = [NSString stringWithFormat:@"%@", [UserInfoModel sharedUserInfo].unpaidCount];
        [self addIncomeLable];
    }
}
- (void)initData
{
//    dic = [[NSDictionary alloc]init];
}
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREEN_height-64)];
    CGFloat content = 335+60;
    _scrollView.contentSize = CGSizeMake(SCREEN_width, content);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [self initUI];
    
}
- (void)initUI
{
    //定制返回按钮
    UIBarButtonItem *blackItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = blackItem;
    //返回按钮白色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];//用于返回按钮
    //创建钱带imageview
    UIImageView * iView = [[UIImageView alloc]initWithFrame:CGRectMake(50 *SCALE,30, 80*SCALE, 90)];
    [iView setImage:[UIImage imageNamed:@"qiandai@2x.png"]];
    [_scrollView addSubview:iView];
    //创建收入label
//    label = [[UILabel alloc]initWithFrame:CGRectMake(130*SCALE, 40, 110*SCALE, 100)];
    label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textColor = [UIColor colorWithRed:250.0/255 green:211.0f/255 blue:115.0f/255 alpha:1.0f];
    label.font = [UIFont systemFontOfSize:50];
    label.text = @"你好";
    [_scrollView addSubview:label];
    
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //创建邀请码label
    labelInvite = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_width-260)/2,280,260,30)];
    labelInvite.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f];
    labelInvite.textColor = [UIColor colorWithRed:250.0/255 green:211.0f/255 blue:115.0f/255 alpha:1.0f];
    labelInvite.font = [UIFont systemFontOfSize:23];
    labelInvite.textAlignment = NSTextAlignmentCenter;
    labelInvite.layer.cornerRadius=15.0f;
    labelInvite.layer.masksToBounds=YES;
    [_scrollView addSubview:labelInvite];
    //画两侧的基准线
       UIView *  LeftCodeline = [[UIView alloc]initWithFrame:CGRectMake(10*SCALE,330,110*SCALE,1)];
        LeftCodeline.backgroundColor = [UIColor grayColor];
        [_scrollView addSubview:LeftCodeline];
       UIView *  RightCodeline = [[UIView alloc]initWithFrame:CGRectMake(200*SCALE,330,110*SCALE,1)];
        RightCodeline.backgroundColor = [UIColor grayColor];
       [_scrollView addSubview:RightCodeline];
    //创建返现说明label
    UILabel * labelIntroduce = [[UILabel alloc]initWithFrame:CGRectMake(130*SCALE,315,70*SCALE,30)];
    labelIntroduce.text = @"返现说明";
    labelIntroduce.textColor = [UIColor grayColor];
    labelIntroduce.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:labelIntroduce];
    //创建返现说明内容label
    UILabel * labelContent = [[UILabel alloc]initWithFrame:CGRectMake(20*SCALE,335,290*SCALE,60)];
    labelContent.text = @"被邀请注册成功的用户，成功购买卡卡服务中心业务将会按照10%，为您返现。";
    labelContent.numberOfLines = 0;
    labelContent.textColor = [UIColor grayColor];
    labelContent.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labelContent];
    
}
- (void)requestData
{
    NSString * strURl = [HostUrl stringByAppendingString:Get_Unpaid_Amount];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:strURl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DLog(@"manager***unpaid == %@",dic[@"unpaid"]);
        if ([dic[@"unpaid"] isEqualToNumber:@0]) {
            label.text = [NSString stringWithFormat:@"%@.00",dic[@"unpaid"]];
        }else{
            label.text = [NSString stringWithFormat:@"%@",dic[@"unpaid"]];
            [UserInfoModel sharedUserInfo].unpaidCount = [NSString stringWithFormat:@"%@", dic[@"unpaid"]];
            [[DBManager sharedDBManager] saveUserInfo:[UserInfoModel sharedUserInfo]];
        }
        [self addIncomeLable];
        if ([dic[@"unpaid"]integerValue] == 0) {
            //创建钱带奔跑小黄人imageview
            UIImageView * CenteriView = [[UIImageView alloc]initWithFrame:CGRectMake(125*SCALE,120,70*SCALE,70)];
            [CenteriView setImage:[UIImage imageNamed:@"xiaohuangren@2x.png"]];
            [self.view addSubview:CenteriView];
            //创建小黄人下方字体label
            UILabel * labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(80*SCALE,190,200*SCALE,30)];
            labelTitle.text = @"抓紧邀请好友注册吧";
            labelTitle.textColor = [UIColor grayColor];
            labelTitle.font = [UIFont systemFontOfSize:17];
            [_scrollView addSubview:labelTitle];
            //创建收入明细 按钮btnIncome
            UIButton * btnIncome = [UIButton buttonWithType:UIButtonTypeCustom];
            btnIncome.frame = CGRectMake(30*SCALE, 220, 120*SCALE, 50);
            [btnIncome setImage:[UIImage imageNamed:@"收入明细@2x.png"] forState:UIControlStateNormal];
            btnIncome.tag = 102;
            [btnIncome addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btnIncome];
            //创建收入明细 按钮btnMoneyDetail
            UIButton * btnMoneyDetail = [UIButton buttonWithType:UIButtonTypeCustom];
            btnMoneyDetail.frame = CGRectMake(170*SCALE, 220, 120*SCALE, 50);
            [btnMoneyDetail setImage:[UIImage imageNamed:@"提现明细@2x.png"] forState:UIControlStateNormal];
            btnMoneyDetail.tag = 103;
            [btnMoneyDetail addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btnMoneyDetail];
        }else{
            //创建我要提现 按钮btnGetMoney
            [self hasUpaidMoneyUI];
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}

- (void)addIncomeLable {
    //label高度不变 自适应宽度的大小
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
    [label setFrame:CGRectMake(130*SCALE, 40, size.width, 100)];
    //创建收入单位label
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, 95, 20*SCALE, 10)];
    label1.text = @"元";
    label1.textColor = [UIColor colorWithRed:250.0/255 green:211.0f/255 blue:115.0f/255 alpha:1.0f];
    label1.font = [UIFont systemFontOfSize:17];
    [_scrollView addSubview:label1];
}

- (void)hasUpaidMoneyUI {
    btnGetMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetMoney.frame = CGRectMake(30*SCALE, 140, 260*SCALE, 50);
    [btnGetMoney setImage:[UIImage imageNamed:@"我要提现@2x.png"] forState:UIControlStateNormal];
    btnGetMoney.tag = 101;
    [btnGetMoney addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnGetMoney];
    //创建收入明细 按钮btnIncome
    UIButton * btnIncome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnIncome.frame = CGRectMake(30*SCALE, 200, 120*SCALE, 50);
    [btnIncome setImage:[UIImage imageNamed:@"收入明细@2x.png"] forState:UIControlStateNormal];
    btnIncome.tag = 102;
    [btnIncome addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnIncome];
    //创建收入明细 按钮btnMoneyDetail
    UIButton * btnMoneyDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMoneyDetail.frame = CGRectMake(170*SCALE, 200, 120*SCALE, 50);
    [btnMoneyDetail setImage:[UIImage imageNamed:@"提现明细@2x.png"] forState:UIControlStateNormal];
    btnMoneyDetail.tag = 103;
    [btnMoneyDetail addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnMoneyDetail];
}

- (void)requestData2
{
    NSString * url = [HostUrl stringByAppendingString:Get_Min_Pay];
    AFHTTPRequestOperationManager * LowestManager = [AFHTTPRequestOperationManager manager];
    LowestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [LowestManager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DLog(@"%@",dict);
        if ([dic[@"unpaid"] integerValue] > [dict[@"dict_code"] integerValue]) {
            DLog(@"LowestManager *** unpaid ******* %@",dic[@"unpaid"]);
            btnGetMoney.hidden = NO;
        }else{
            btnGetMoney.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}
- (void)requestData3
{
    NSString * strURL = [HostUrl stringByAppendingString:Get_Affiliate];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:strURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self finishedDownloadData:responseObject];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}
- (void)finishedDownloadData:(NSData *)data
{
    NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    DLog(@"%@",resultDic);
//    labelName.text = resultDic[@"name"];
//    ufPhone.text = resultDic[@"phone"];
//    ufBankName.text = resultDic[@"bankName"];
//    ufBankNumer.text = resultDic[@"bankNumber"];
    labelInvite.text = [NSString stringWithFormat:@"邀请码:%@",resultDic[@"phone"]];
    [[NSUserDefaults standardUserDefaults] setValue:resultDic[@"phone"] forKey:@"phone"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)btnClicked:(UIButton *)btn
{
    if (btn.tag == 101) {
        if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"网络不好！请稍后再试";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }
        WantGetMoneyViewController * vc = [[WantGetMoneyViewController alloc]init];
        vc.str = label.text;
        DLog(@"vc****%@",vc.labelAmount
              );
        DLog(@"label%@",label.text);
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 102) {
        IncomeDetailViewController * vc = [[IncomeDetailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 103) {
        GetMoneyDetailViewController * vc = [[GetMoneyDetailViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
