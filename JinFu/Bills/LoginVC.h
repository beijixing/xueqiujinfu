//
//  ViewController.h
//  JinFu
//
//  Created by ybon on 15/12/17.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginVC : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailAccountTF;
@property (strong, nonatomic) IBOutlet UITextField *emailPswdTF;
@property (strong, nonatomic) IBOutlet UITextField *recommondCodeTF;

- (IBAction)rememberPswdBtnClick:(UIButton *)sender;


- (IBAction)agreeAuthorizationBtnClick:(UIButton *)sender;

- (IBAction)jfProtocolBtnClick:(UIButton *)sender;

- (IBAction)loginBtnClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *rememberPswdImage;
@property (strong, nonatomic) IBOutlet UIImageView *agreeAuthorizationImage;

@property (strong, nonatomic) IBOutlet UIView *emailContainerView;

@property (strong, nonatomic) IBOutlet UIView *emailPswdContainerView;

@property (strong, nonatomic) IBOutlet UIView *recommondCodeView;
@end
