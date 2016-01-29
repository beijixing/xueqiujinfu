//
//  WantGetMoneyViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "WantGetMoneyViewController.h"
#import "SucceedViewController.h"
#import "QGConfig.h"
#import "QGTools.h"
#import "AFNetworking.h"
@interface WantGetMoneyViewController ()

@end

@implementation WantGetMoneyViewController
{

    NSDictionary * dict;
    UILabel * labelName;
    UITextField * ufBankName;
    UITextField * ufPhone;
    UITextField * ufBankNumer;
    UIScrollView *_scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我要提现";
    [self initData];
    [self requestData];
    [self initScrollView];
}
- (void)initData
{

    dict = [[NSMutableDictionary alloc]init];
    
}
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREEN_height-64)];
    CGFloat content = 568;
    _scrollView.contentSize = CGSizeMake(SCREEN_width, content);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [self initUI];
    
}
- (void)initUI
{
    labelName = [[UILabel alloc]initWithFrame:CGRectMake(20*SCALE, 10, 280*SCALE, 40)];
    labelName.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    labelName.layer.cornerRadius = 5.0f;
    labelName.layer.masksToBounds = YES;
    [_scrollView addSubview:labelName];
    ufPhone = [QGTools creatTextField:CGRectMake(20*SCALE, 60, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"" keyboardType:UIKeyboardTypeDefault tag:1001 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufPhone];
    ufBankName = [QGTools creatTextField:CGRectMake(20*SCALE, 110, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"" keyboardType:UIKeyboardTypeDefault tag:1003 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufBankName];
    ufBankNumer = [QGTools creatTextField:CGRectMake(20*SCALE, 60+50*2, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"" keyboardType:UIKeyboardTypeDefault tag:1003 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufBankNumer];

    self.labelAmount = [[UILabel alloc]initWithFrame:CGRectMake(110*SCALE, 210, 190*SCALE, 40)];
    self.labelAmount.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    self.labelAmount.text = [NSString stringWithFormat:@"￥%@",self.str];
    self.labelAmount.font = [UIFont systemFontOfSize:30];
    self.labelAmount.layer.cornerRadius = 5.0f;
    self.labelAmount.layer.masksToBounds = YES;
    self.labelAmount.textColor = [UIColor colorWithRed:250.0/255 green:211.0f/255 blue:115.0f/255 alpha:1.0f];
    [_scrollView addSubview:self.labelAmount];

    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20*SCALE, 210, 90*SCALE, 40);
    [btn setTitle:@"提现金额:" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0f;
    [_scrollView addSubview:btn];
    //创建同意协议勾选 label
    UIButton * buttonAgreen = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonAgreen.frame = CGRectMake(35*SCALE, 260, 15*SCALE, 15);
    [buttonAgreen setImage:[UIImage imageNamed:@"fuwutiaokuan-tongyi@2x.png"] forState:UIControlStateNormal];
    [buttonAgreen setImage:[UIImage imageNamed:@"unselect@2x.png"] forState:UIControlStateSelected];
    [buttonAgreen addTarget:self action:@selector(bbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buttonAgreen];
    UILabel * labelAgreen = [[UILabel alloc]initWithFrame:CGRectMake(50*SCALE, 260, 80*SCALE, 20)];
    labelAgreen.text = @"同意服务条款";
    labelAgreen.textColor = [UIColor grayColor];
    labelAgreen.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labelAgreen];
    //创建提交 按钮btnCommit
    UIButton * btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCommit.frame = CGRectMake(30*SCALE, 290, 260*SCALE, 50);
    [btnCommit setImage:[UIImage imageNamed:@"buyBg@2x.png"] forState:UIControlStateNormal];
    btnCommit.tag = 1201;
    [btnCommit addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:btnCommit];
    //创建注 label
    UILabel * labelAtc = [[UILabel alloc]initWithFrame:CGRectMake(10*SCALE, 350, 300*SCALE, 140)];
    labelAtc.text = @"     不错，我就是叶良辰,你的行为实在欺人太甚，你若是感觉有实力跟我玩，良辰不介意奉陪到底。呵呵，我会让你明白，良辰从不说空话。别让我碰到你，如果在我的地盘，我有一百种方法让你们待不下去，可你，却无可奈何。呵呵，良辰最喜欢对那些自认为能力出众的人出手，你只需要记住，我叫叶良辰。";
    labelAtc.textColor = [UIColor grayColor];
    labelAtc.numberOfLines = 0;
    labelAtc.textAlignment = NSTextAlignmentLeft;
    labelAtc.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    labelAtc.font = [UIFont systemFontOfSize:13];
    UIImageView * iconIView = [[UIImageView alloc]initWithFrame:CGRectMake(20*SCALE, 350, 15*SCALE, 20)];
    [iconIView setImage:[UIImage imageNamed:@"note@2x.png"]];
    //[self.view addSubview:iconIView];
    [_scrollView addSubview:labelAtc];
}
- (void)bbtnClicked:(UIButton *)bbtn
{
    bbtn.selected =! bbtn.selected;
    if (bbtn.selected) {
        
    }else{
        
    }
}
- (void)requestData
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
     dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    DLog(@"%@",dict);
    labelName.text = [NSString stringWithFormat:@" %@",dict[@"name"]];
    ufPhone.text = dict[@"phone"];
    ufBankName.text = dict[@"bankName"];
    ufBankNumer.text = dict[@"bankNumber"];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"phone"] forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)btnClicked:(UIButton*)btn
{
    NSString * Url = [HostUrl stringByAppendingString:withdrawal_request];
    NSDictionary * parameters = @{@"phone":ufPhone.text,@"name":labelName.text,@"bankName":ufBankName.text,@"bankNumber":ufBankNumer.text};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:Url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * dictBack = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        DLog(@"%@",dictBack);
        if ([dictBack[@"result"] intValue] == 1) {
            SucceedViewController * vc = [[SucceedViewController alloc]init];
            vc.str = self.labelAmount.text;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        DLog(@"%@",error);
    }];
}
@end
