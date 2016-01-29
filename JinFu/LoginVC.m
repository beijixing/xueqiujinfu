//
//  ViewController.m
//  JinFu
//
//  Created by ybon on 15/12/17.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "LoginVC.h"
#import "ImportBillVC.h"
#import "AFNetManager.h"
#import "UserInfoModel.h"
#import "DBManager.h"
#import "AppDelegate.h"

#import "MBProgressHUD.h"
#import "JFTabBarController.h"
#import "MyMD5.h"
#import "IllustrateVC.h"
#import "ShowProtocolVC.h"


@interface LoginVC ()
{
    BOOL bRememberPswd;
    BOOL bAgreeProto;
    MBProgressHUD *hud;
    NSInteger failCount;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateViewBorderColorWithId:1];
    self.view.backgroundColor = ViewMainColor;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:gesture];
    
    
    UITapGestureRecognizer *rememberPswdgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberPswdTapGesture:)];
    [self.rememberPswdImage addGestureRecognizer:rememberPswdgesture];
    self.rememberPswdImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *agreeAuthorizationgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreeAuthorizationTapGesture:)];
    [self.agreeAuthorizationImage addGestureRecognizer:agreeAuthorizationgesture];
    self.agreeAuthorizationImage.userInteractionEnabled = YES;
    
    bRememberPswd = false;
    bAgreeProto = false;
    failCount = 0;
}

- (void)tapGesture:(UIGestureRecognizer *)gesture {
    [self.emailAccountTF resignFirstResponder];
    [self.emailPswdTF resignFirstResponder];
    [self.recommondCodeTF resignFirstResponder];
}

- (void)updateViewBorderColorWithId:(int)tag {
    
    switch (tag) {
        case 1:
            [self.emailContainerView setMyViewLayerBoardColor:ColorWithRGB(236, 185, 0) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            [self.emailPswdContainerView setMyViewLayerBoardColor:ColorWithRGB(143, 144, 145) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            [self.recommondCodeView setMyViewLayerBoardColor:ColorWithRGB(143, 144, 145) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            
            self.emailContainerView.backgroundColor = ViewMainColor;
            self.emailPswdContainerView.backgroundColor = [UIColor whiteColor];
            self.recommondCodeView.backgroundColor = [UIColor whiteColor];
            
            break;
        case 2:
            
            [self.emailContainerView setMyViewLayerBoardColor:ColorWithRGB(143, 144, 145) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            [self.emailPswdContainerView setMyViewLayerBoardColor:ColorWithRGB(236, 185, 0) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            [self.recommondCodeView setMyViewLayerBoardColor:ColorWithRGB(143, 144, 145) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            
            self.emailContainerView.backgroundColor = [UIColor whiteColor];
            self.emailPswdContainerView.backgroundColor = ViewMainColor;
            self.recommondCodeView.backgroundColor = [UIColor whiteColor];
            
            break;
        case 3:
            [self.emailContainerView setMyViewLayerBoardColor:ColorWithRGB(143, 144, 145) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            [self.emailPswdContainerView setMyViewLayerBoardColor:ColorWithRGB(143, 144, 145) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            [self.recommondCodeView setMyViewLayerBoardColor:ColorWithRGB(236, 185, 0) AndBoardWidth:2.0f AndCornerRadius:20.0f];
            
            self.emailContainerView.backgroundColor = [UIColor whiteColor];
            self.emailPswdContainerView.backgroundColor = [UIColor whiteColor];
            self.recommondCodeView.backgroundColor = ViewMainColor;
            
            break;
        default:
            break;
    }
}


- (IBAction)rememberPswdBtnClick:(UIButton *)sender {
    [self setRememberPswdState];
}

- (void)setRememberPswdState {
    bRememberPswd = !bRememberPswd;
    if (bRememberPswd) {
        self.rememberPswdImage.image = [UIImage imageNamed:@"selected"];
    }
    else
    {
        self.rememberPswdImage.image = [UIImage imageNamed:@"unselect"];
    }
}

- (void)rememberPswdTapGesture:(UIGestureRecognizer *)gesture {
    [self setRememberPswdState];
}

- (IBAction)agreeAuthorizationBtnClick:(UIButton *)sender {
    [self setAgreeAuthorizationState];
}

- (void)setAgreeAuthorizationState {
    bAgreeProto = !bAgreeProto;
    if (bAgreeProto) {
        self.agreeAuthorizationImage.image = [UIImage imageNamed:@"selected"];
    }else {
        self.agreeAuthorizationImage.image = [UIImage imageNamed:@"unselect"];
    }
}

- (void)agreeAuthorizationTapGesture:(UIGestureRecognizer *)gesture {
    [self setAgreeAuthorizationState];
}

- (IBAction)jfProtocolBtnClick:(UIButton *)sender {
    ShowProtocolVC *protocolVc = [[ShowProtocolVC alloc] init];
    [self presentViewController:protocolVc animated:YES completion:nil];
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    
//    [self presentViewController:[[ImportBillVC alloc] init] animated:YES completion:^{
//            
//    }];
  
    
    if ([self.emailAccountTF.text length] == 0)
    {
        [ToolBox showAlertInfo:@"请输入邮箱账号"];
        return;
    }else if ( [self.emailPswdTF.text length] == 0) {
        
        [ToolBox showAlertInfo:@"请输入邮箱密码"];
        return;
    }else if ( !bAgreeProto ) {
        [ToolBox showAlertInfo:@"是否同意授权？"];
        return;
    }else {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotification:) name:Login object:nil];
        
        NSString *parameter = [NSString stringWithFormat:@"%@email=%@&password=%@&refCode=%@",Login, self.emailAccountTF.text, self.emailPswdTF.text, self.recommondCodeTF.text];
        [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:parameter andNotificationName:Login];
    }
    
    DLog(@"login btn click");
}

- (void)registerNotification:(NSNotification *)notification {
    hud.hidden = YES;
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Login object:nil];
    DLog(@"resultDic = %@", resultDic);
    
    NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
 
    if ([[responseObject objectForKey:@"flag"]isEqualToString:@"1"]) {//普通登陆
//        [self presentViewController:[[ImportBillVC alloc] init] animated:YES completion:^{
//        }];
        [self handleLoginSuccess:responseObject isRegister:NO];
    }else if([[responseObject objectForKey:@"flag"]isEqualToString:@"0"]) {//注册
        //第一次登录成功算是注册，这时候要导入账单
        if ([[responseObject objectForKey:@"register"]isEqualToString:@"1"]){//1导入账单
            [self presentViewController:[[ImportBillVC alloc] init] animated:YES completion:^{
            }];
        }else if([[responseObject objectForKey:@"register"]isEqualToString:@"2"]){
            [ToolBox showAlertInfo:@"存在相同邮箱"];
        }else {
            [ToolBox showAlertInfo:@"注册失败"];
        }
        
        [self handleLoginSuccess:responseObject isRegister:YES];
    }
}

- (void)handleLoginSuccess:(NSDictionary *)dataDict isRegister:(BOOL)bRegister {
    if ([[dataDict objectForKey:@"login"]isEqualToString:@"1"]) {//登陆成功
        if (bRememberPswd) {
            UserInfoModel *userInfo = [UserInfoModel sharedUserInfo];
            userInfo.email = self.emailAccountTF.text;
            NSString *md5PassWord = [MyMD5 md5:self.emailPswdTF.text];
            userInfo.passWord = md5PassWord;//self.emailPswdTF.text;
            userInfo.savePassword = bRememberPswd ? @"true" : @"false";
            userInfo.loginSuccess = @"true";
            [[DBManager sharedDBManager] saveUserInfo:userInfo];
        }
        
        if (!bRegister) {
            JFTabBarController *tabBarVc = [[JFTabBarController alloc] init];
            [self presentViewController:tabBarVc animated:YES completion:^{
            }];
        }
        //发送推送的chanellID
        AppDelegate *appDelegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate sendPushChanelIdToServer];
    }else {
        [self showAlert];
    }
}

- (void)showAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码错误或者邮箱禁止第三方登入，请阅读如何设置第三方邮箱登入" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        IllustrateVC *illustrateVc = [[IllustrateVC alloc] init];
        [self presentViewController:illustrateVc animated:YES completion:nil];
    }];
    
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.emailAccountTF)
    {
        [self updateViewBorderColorWithId:1];
    }
    else if(textField == self.emailPswdTF)
    {
        [self updateViewBorderColorWithId:2];
    }
    else if (textField == self.recommondCodeTF)
    {
        [self updateViewBorderColorWithId:3];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
