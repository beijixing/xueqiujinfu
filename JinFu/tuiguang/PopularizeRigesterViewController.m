//
//  PopularizeRigesterViewController.m
//  JinFu
//
//  Created by 山东远邦 on 15/12/23.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "PopularizeRigesterViewController.h"
#import "QGTools.h"
#import <QuartzCore/QuartzCore.h>
#import "QGConfig.h"
#import "MyInComeViewController.h"
#import "RegisterSucceedViewController.h"
#import "AFNetManager.h"
#import "AFNetworking.h"
#import "CustomTextField.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
//#define SCALE [UIScreen mainScreen].bounds.size.width/320

@interface PopularizeRigesterViewController ()<UITextFieldDelegate>
@property (nonatomic,retain)CustomTextField * textField;
@end

@implementation PopularizeRigesterViewController
{
    UIView * myView;
    UIImageView * bgImgView;
    UIAlertView *alertV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"推广员注册";
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    alertV = [[UIAlertView alloc] init];
    myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_width,SCREEN_height)];
    bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_width,SCREEN_height)];
    [bgImgView setImage:[UIImage imageNamed:@"tuiguangyuanzhuce-beijng@2x.png"]];
    [myView addSubview:bgImgView];
    [self.view addSubview:myView];
    [myView sendSubviewToBack:bgImgView];
    [self initUI];
    
}
- (void)initUI{
    
    //UITextField的创建
    NSArray * arrayName = @[@"姓名",@"手机号",@"银行卡号",@"发卡行"];
    NSArray * arrayIcon = @[@"icon-people@2x.png",@"icon-phone@2x.png",@"icon-ka@2x.png",@"bank.png"];
    for (int i = 0; i<4; i++) {
        if (i == 2 || i==3) {
            self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        }
        UIImage *mmImage = [UIImage imageNamed:arrayIcon[i]];
        UIImageView *mmIcon = [[UIImageView alloc] initWithImage:mmImage];
        mmIcon.frame = CGRectMake(0, 0, 20, 20);
        _textField = [[CustomTextField alloc]initWithFrame:CGRectMake(30 * SCALE, 40+60*i,260* SCALE, 40) drawingLeft:mmIcon];
        _textField.backgroundColor=[UIColor clearColor];
        _textField.textColor=[UIColor whiteColor];
        _textField.placeholder = arrayName[i];
        _textField.tag = 101+i;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.layer.borderWidth=1.5;
        _textField.layer.cornerRadius=20.0;
        _textField.delegate=self;
        _textField.autocorrectionType=UITextAutocorrectionTypeNo;
        _textField.layer.borderColor = [UIColor colorWithRed:0.95f green:0.72f blue:0.07f alpha:1.00f].CGColor;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:_textField];
    }
    //注册按钮的创建
    UIButton * buttonRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRegister.frame = CGRectMake(50* SCALE, 310, 220* SCALE, 50);
    [buttonRegister setImage:[UIImage imageNamed:@"注--册@2x.png"] forState:UIControlStateNormal];
    [buttonRegister addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonRegister.tag = 2002;
    [self.view addSubview:buttonRegister];
    //选中状态 button
    UIButton * iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(50* SCALE, 270, 20* SCALE, 20);
    [iconBtn setImage:[UIImage imageNamed:@"unselect@2x.png"] forState:UIControlStateNormal];
     [iconBtn setImage:[UIImage imageNamed:@"fuwutiaokuan-tongyi@2x.png"] forState:UIControlStateSelected];
    [iconBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.tag = 38;
    [self.view addSubview:iconBtn];
    //创建label
    UILabel * labelDeleg = [[UILabel alloc]initWithFrame:CGRectMake(80* SCALE, 270, 220* SCALE, 20)];
    labelDeleg.text = @"同意并确认 《推广员的注册协议》";
    labelDeleg.font = [UIFont systemFontOfSize:13];
    labelDeleg.textColor = [UIColor whiteColor];
    [self.view addSubview:labelDeleg];
    
}
//判断是否是数字，不是的话就输入失败
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    BOOL canChange = [string isEqualToString:filtered];
    return self.textField.text.length>=5?NO: canChange;
    
}
- (void)btnTap:(UIButton *)btn
{
    btn.selected =! btn.selected;
    if (btn.selected) {
    }else{
        
    }
}
//注册button的 点击事件
- (void)btnClicked:(UIButton *)btn
{
    //姓名phoneTf NameTf
    UITextField *NameTf = (UITextField *)[self.view viewWithTag:101];
    //手机号 phoneTf
    UITextField *phoneTf = (UITextField *)[self.view viewWithTag:102];
    //银行名称 BankName
    UITextField *BankName = (UITextField *)[self.view viewWithTag:103];
    //银行卡号 BankNumer
    UITextField *BankNumer = (UITextField *)[self.view viewWithTag:104];
    if (NameTf.text == nil || [NameTf.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"姓名不能为空"];
        return;
    }
    if (phoneTf.text == nil || [phoneTf.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"手机号码不能为空"];
        return;
    }
    if (BankName.text == nil || [BankName.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"银行卡号不能为空"];
        return;
    }
    if (BankNumer.text == nil || [BankNumer.text isEqualToString:@""]) {
        [ToolBox showAlertInfo:@"发卡行不能为空"];
        return;
    }
    //注册button
    UIButton * button = (UIButton *)[self.view viewWithTag:38];
    if (button.selected == YES) {
        NSString * Url = [HostUrl stringByAppendingString:RegisterMan];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:NameTf.text, @"name", phoneTf.text, @"phone", BankNumer.text, @"bankName",BankName.text,@"bankNumber" ,nil];
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:Url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSDictionary * dictJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            DLog(@"dictJSON********^^^^^^^***^^*^*^^**^*^*^*%@",dictJSON);
            if ([dictJSON[@"result"] isEqualToString:@"1"]) {
                RegisterSucceedViewController * vc = [[RegisterSucceedViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                }
            
            
            DLog(@"dictJSON == %@",dictJSON);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            DLog(@"failed");
            
        }];
    }else{
        alertV.title = @"是否同意授权？";
        [alertV show];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(disappear:) userInfo:nil repeats:NO];
    }
}
- (void)disappear:(NSTimer *)timer
{
    [alertV dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //姓名phoneTf NameTf
    UITextField *NameTf = (UITextField *)[self.view viewWithTag:101];
    //手机号 phoneTf
    UITextField *phoneTf = (UITextField *)[self.view viewWithTag:102];
    //银行名称 BankName
    UITextField *BankName = (UITextField *)[self.view viewWithTag:103];
    //银行卡号 BankNumer
    UITextField *BankNumer = (UITextField *)[self.view viewWithTag:104];
    [NameTf resignFirstResponder];
    [phoneTf resignFirstResponder];
    [BankName resignFirstResponder];
    [BankNumer resignFirstResponder];
    
}
@end
