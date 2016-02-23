//
//  SucceedViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "SucceedViewController.h"
#import "QGConfig.h"
@interface SucceedViewController ()

@end

@implementation SucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
- (void)initUI
{
    //创建提现  label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60*SCALE, 80, 30*SCALE, 10)];
    label.text = @"提现";
    label.textColor = [UIColor brownColor];
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    //创建提现金额 labelNum
    self.labelNum = [[UILabel alloc]initWithFrame:CGRectMake(100*SCALE, 40, 140*SCALE, 70)];
    self.labelNum.text = self.str;
    self.labelNum.textColor = [UIColor brownColor];
    self.labelNum.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:self.labelNum];
    //创建提现金额单位 labelNumName
    UILabel * labelNumName = [[UILabel alloc]initWithFrame:CGRectMake(230*SCALE, 80, 30*SCALE, 10)];
    labelNumName.text = @"元";
    labelNumName.textColor = [UIColor brownColor];
    labelNumName.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:labelNumName];
    //创建小黄人ImageView
    UIImageView * ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110*SCALE,150,100*SCALE,110)];
    [ImageView setImage:[UIImage imageNamed:@"xiaohuangren-tixianchenggong@2x.png"]];
    [self.view addSubview:ImageView];
    //创建恭喜注册成功labelSucceed
    UILabel * labelSucceed = [[UILabel alloc]initWithFrame:CGRectMake(90*SCALE, 290, 140*SCALE, 30)];
    labelSucceed.text = @"恭喜您提现成功!";
    labelSucceed.textColor = [UIColor blackColor];
    labelSucceed.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:labelSucceed];
}

@end
