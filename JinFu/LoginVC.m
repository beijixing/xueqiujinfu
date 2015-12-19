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

@interface LoginVC ()
{
    BOOL bRememberPswd;
    BOOL bAgreeProto;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateViewBorderColorWithId:1];
    self.view.backgroundColor = ViewMainColor;
    
    bRememberPswd = false;
    bAgreeProto = false;
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
    bRememberPswd = !bRememberPswd;
    if (bRememberPswd) {
        self.rememberPswdImage.image = [UIImage imageNamed:@"selected"];
    }
    else
    {
        self.rememberPswdImage.image = [UIImage imageNamed:@"unselect"];
    }
    
}

- (IBAction)agreeAuthorizationBtnClick:(UIButton *)sender {
    bAgreeProto = !bAgreeProto;
    if (bAgreeProto) {
        self.agreeAuthorizationImage.image = [UIImage imageNamed:@"selected"];
    }else {
        self.agreeAuthorizationImage.image = [UIImage imageNamed:@"unselect"];
    }
}

- (IBAction)jfProtocolBtnClick:(UIButton *)sender {
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
//    }else if ( [self.recommondCodeTF.text length] == 0) {
//        [ToolBox showAlertInfo:@"请输入推荐码"];
//        return;
    }else {
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotification:) name:Login object:nil];
        
        NSString *parameter = [NSString stringWithFormat:@"%@email=%@&password=%@",Login, self.emailAccountTF.text, self.emailPswdTF.text];
        [[AFNetManager sharedManager] getDataFromServerWithHostUrl:HostUrl andParameters:parameter andNotificationName:Login];

    }
    
    NSLog(@"login btn click");
}

- (void)registerNotification:(NSNotification *)notification {

    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:notification.userInfo];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Login object:nil];
    NSLog(@"resultDic = %@", resultDic);
    
    NSDictionary *responseObject = [resultDic objectForKey:@"responseObject"];
    if ([[responseObject objectForKey:@"flag"]isEqualToString:@"1"]) {
        
            [self presentViewController:[[ImportBillVC alloc] init] animated:YES completion:^{
        
            }];

        
    }
    
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


@end
