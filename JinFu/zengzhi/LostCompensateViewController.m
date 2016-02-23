//
//  LostCompensateViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/29.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "LostCompensateViewController.h"
#import "QGConfig.h"
#import "QGTools.h"
#import "AFNetManager.h"
@interface LostCompensateViewController ()<UITextViewDelegate,UITextFieldDelegate>

@end

@implementation LostCompensateViewController
{
    
    NSDictionary * dict;
    UIScrollView * _scrollView;
    //UILabel * labelName;
    UITextField * ufName;
    UITextField * ufBankName;
    UITextField * ufPhone;
    UITextField * ufBankNumer;
    UITextField * ufPayMoney;
    UITextField * ufCost;
    UIAlertView * alert;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"失卡赔付申请";
       self.view.backgroundColor = [UIColor whiteColor];
    //[self initUI];
    alert = [[UIAlertView alloc]init];
    [self initScrollView];
}
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREEN_height-64)];
    CGFloat content = 455;
    _scrollView.contentSize = CGSizeMake(SCREEN_width, content);
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    [self initUI];
    
}
- (void)initUI
{
    
    ufName = [QGTools creatTextField:CGRectMake(20*SCALE, 10, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"姓名" keyboardType:UIKeyboardTypeDefault tag:999 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufName];
    ufPhone = [QGTools creatTextField:CGRectMake(20*SCALE, 60, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"手机号码" keyboardType:UIKeyboardTypeDefault tag:1001 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    ufPhone.delegate = self;
    [_scrollView addSubview:ufPhone];
    ufBankName = [QGTools creatTextField:CGRectMake(20*SCALE, 110, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"身份证号" keyboardType:UIKeyboardTypeDefault tag:1003 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    
    [_scrollView addSubview:ufBankName];
    ufBankNumer = [QGTools creatTextField:CGRectMake(20*SCALE, 60+50*2, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"卡片号码" keyboardType:UIKeyboardTypeDefault tag:1005 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufBankNumer];
    //UITextView * tv = [[UITextView alloc]initWithFrame:CGRectMake(20*SCALE, 210, 280*SCALE, 40)];
    ufCost = [QGTools creatTextField:CGRectMake(20*SCALE, 210, 280*SCALE, 40) bgColor:[UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:0.8f] borderStyle:UITextBorderStyleRoundedRect placeHolder:@"赔付金额" keyboardType:UIKeyboardTypeDefault tag:1007 font:[UIFont systemFontOfSize:13] secureTextEntry:NO clearButtonMode:UITextFieldViewModeAlways];
    [_scrollView addSubview:ufCost];
    //勾选button
    UIButton * buttonAgreen = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonAgreen.frame = CGRectMake(30*SCALE, 262, 15*SCALE, 15);
    [buttonAgreen addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    buttonAgreen.tag = 1900;
    [buttonAgreen setImage:[UIImage imageNamed:@"unselect@2x.png"] forState:UIControlStateNormal];
        DLog(@"未点击呀");
    [buttonAgreen setImage:[UIImage imageNamed:@"fuwutiaokuan-tongyi@2x.png"] forState:UIControlStateSelected];
    [buttonAgreen setSelected:NO];
    [_scrollView addSubview:buttonAgreen];
    UILabel * labelAgreen = [[UILabel alloc]initWithFrame:CGRectMake(50*SCALE, 260, 80*SCALE, 20)];
    labelAgreen.text = @"同意服务条款";
    labelAgreen.textColor = [UIColor grayColor];
    labelAgreen.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:labelAgreen];
    //创建提交 按钮btnCommit
    UIButton * btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCommit.frame = CGRectMake(30*SCALE, 280, 260*SCALE, 50);
    [btnCommit setImage:[UIImage imageNamed:@"buyBg@2x.png"] forState:UIControlStateNormal];
    btnCommit.tag = 1201;
    [btnCommit addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnCommit];
    //创建注 textView
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(10*SCALE, 340, 300*SCALE, 120)];
    textView.delegate = self;
    //添加滚动区域
    //textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.font = [UIFont systemFontOfSize:13];
    textView.text = @"呵呵，哥曾信佛但佛信曾哥，如果在我的地盘，我有一百种方法让你们待不下去，可你，却无可奈何。呵呵，良辰最喜欢对那些自认为能力出众的人出手，你只需要记住，我叫叶良辰。";
    textView.layer.cornerRadius = 5.0f;
    textView.layer.masksToBounds = YES;
    textView.tag = 301;
    textView.textColor = [UIColor grayColor];
    textView.userInteractionEnabled = NO;
    textView.backgroundColor = [UIColor colorWithRed:243.0/255 green:244.0/255 blue:245.0/255 alpha:1.0f];
    [_scrollView addSubview:textView];
    UIImageView * iconIView = [[UIImageView alloc]initWithFrame:CGRectMake(20*SCALE, 350, 15*SCALE, 20)];
    [iconIView setImage:[UIImage imageNamed:@"note@2x.png"]];
}
- (void)btnTap:(UIButton *)btn
{
    btn.selected =! btn.selected;//每次点击都改变按钮的状态
    if (btn.selected) {
        DLog(@"点击了");
       
    }else{
        DLog(@"取消了");
    }
    
    
}
- (void)btnClicked:(UIButton*)btn
{
    //UITextView * uv = (UITextView *)[self.view viewWithTag:301];
    if (ufName.text == nil || [ufName.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"姓名不能为空"];
        return;
    }
    if (ufPhone.text == nil || [ufPhone.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"手机号码不能为空"];
        return;
    }
    if (ufBankName.text == nil || [ufBankName.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"身份证号不能为空"];
        return;
    }
    if (ufBankNumer.text == nil || [ufBankNumer.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"信用卡号码不能为空"];
        return;
    }
    if ([ufCost.text length] == 0) {
        [ToolBox showAlertInfo:@"请填写赔付金额"];
        return;
    }
    UIButton * btnrrr = (UIButton *)[self.view viewWithTag:1900];
    if (btnrrr.selected == YES) {
        NSDictionary * parameters = @{@"cost":ufCost.text,@"name":ufName.text,@"phone":ufPhone.text,@"idcard":ufBankName.text,@"credit":ufBankNumer.text,@"type":@1};
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddPaymentNotifications:) name:AddPayment object:nil];
        [[AFNetManager sharedManager] postDataToServerWithHostUrl:[NSString stringWithFormat:@"%@%@",HostUrl,AddPayment] andParameters:parameters andNotificationName:AddPayment];
    }else{
        alert.title = @"是否同意授权？";
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(disappear:) userInfo:nil repeats:NO];
    }
}
- (void)AddPaymentNotifications:(NSNotification *) notification{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddPayment object:nil];
    DLog(@"resultDic = %@", resultDic);
    if ([resultDic objectForKey:@"responseObject"]) {
        NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
        NSString *msg = [responseObject objectForKey:@"MSG"];
        [ToolBox showAlertInfo:msg];
        DLog(@"sssssssssssssssssssss");
    }
}
//正则表达式判断 手机号
- (BOOL)checkTelString:(NSString *)str
{
    NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        [ToolBox showAlertInfo:@"请输入正确的手机号"];
        return NO;
    }
    return YES;
}
- (void)disappear:(NSTimer *)timer
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkTelString:textField.text];
    
}





@end
