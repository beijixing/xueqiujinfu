//
//  RegisterSucceedViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "RegisterSucceedViewController.h"
#import "QGConfig.h"
#import "MyInComeViewController.h"
@interface RegisterSucceedViewController ()

@end

@implementation RegisterSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册成功";
    [self initUI];
    
}
- (void)initUI
{
    //创建UIView 头视图
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(5*SCALE, 5, 300*SCALE, 100)];
    [self.view addSubview:view];
    UIImageView * iView = [[UIImageView alloc]initWithFrame:CGRectMake(5*SCALE, 5, view.frame.size.width, view.frame.size.height)];
    [iView setImage:[UIImage imageNamed:@"tuiguangyuanzhuce-beijng@2x.png"]];
    //给imageview 加圆角
    iView.layer.cornerRadius = 5.0f;
    iView.layer.masksToBounds = YES;
    [view addSubview:iView];
    //创建注册成功 labelSccuued
    UILabel * labelSccuued = [[UILabel alloc]initWithFrame:CGRectMake(120*SCALE, 110, 80*SCALE, 40)];
    labelSccuued.text = @"注册成功!";
    labelSccuued.font = [UIFont systemFontOfSize:17];
    [view addSubview:labelSccuued];
    //创建注册成功下方 labelTitle
    UILabel * labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(50*SCALE, 150, 240*SCALE, 20)];
    labelTitle.text = @"您的手机号将成为被注册邀请人的邀请注册码!";
    labelTitle.font = [UIFont systemFontOfSize:11];
    [view addSubview:labelTitle];
    //创建邀请码label
    UILabel * labelInvite = [[UILabel alloc]initWithFrame:CGRectMake(30*SCALE,190*SCALE_H,260*SCALE,30*SCALE_H)];
    NSString * strCz = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    DLog(@"strCz~~~~~~~~~~~~~~~~~~~~~~~~%@",strCz);
    labelInvite.text = [NSString stringWithFormat:@"邀请码:%@",strCz];
    labelInvite.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    labelInvite.textColor = [UIColor colorWithRed:250.0/255 green:211.0f/255 blue:115.0f/255 alpha:1.0f];
    labelInvite.font = [UIFont systemFontOfSize:23];
    labelInvite.textAlignment = NSTextAlignmentCenter;
    labelInvite.layer.cornerRadius=15.0f;
    labelInvite.layer.masksToBounds=YES;
    [self.view addSubview:labelInvite];
    //画两侧的基准线
    UIView *  LeftCodeline = [[UIView alloc]initWithFrame:CGRectMake(10*SCALE,250*SCALE_H,110*SCALE,1)];
    LeftCodeline.backgroundColor = [UIColor grayColor];
    [self.view addSubview:LeftCodeline];
    UIView *  RightCodeline = [[UIView alloc]initWithFrame:CGRectMake(200*SCALE,250*SCALE_H,110*SCALE,1)];
    RightCodeline.backgroundColor = [UIColor grayColor];
    [self.view addSubview:RightCodeline];
    //创建返现说明label
    UILabel * labelIntroduce = [[UILabel alloc]initWithFrame:CGRectMake(130*SCALE,235*SCALE_H,70*SCALE,30*SCALE_H)];
    labelIntroduce.text = @"返现说明";
    labelIntroduce.textColor = [UIColor grayColor];
    labelIntroduce.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:labelIntroduce];
    //创建返现说明内容label
    UILabel * labelContent = [[UILabel alloc]initWithFrame:CGRectMake(20*SCALE,265*SCALE_H,290*SCALE,60*SCALE_H)];
    labelContent.text = @"被邀请注册成功的用户，成功购买金福服务中心业务（盗刷保障、丢卡保障、电话服务、POS机服务）将会按照X%，为您返现。";
    labelContent.numberOfLines = 0;
    labelContent.textColor = [UIColor grayColor];
    labelContent.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:labelContent];
    //创建确定按钮
    UIButton * btnGetMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetMoney.frame = CGRectMake(30*SCALE, 350*SCALE_H, 260*SCALE, 50*SCALE_H);
    [btnGetMoney setImage:[UIImage imageNamed:@"确--定@2x.png"] forState:UIControlStateNormal];
    btnGetMoney.tag = 101;
    [btnGetMoney addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnGetMoney];
}
- (void)btnClicked:(UIButton *)btn
{
    MyInComeViewController * vc = [[MyInComeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
