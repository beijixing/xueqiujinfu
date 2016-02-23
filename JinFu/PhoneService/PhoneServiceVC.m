//
//  PhoneServiceVC.m
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "PhoneServiceVC.h"
#import "AddPhoneServiceInfoVC.h"
#import <MBProgressHUD.h>
#import "AFNetManager.h"
@interface PhoneServiceVC ()

@end

@implementation PhoneServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.descriptionTextView.text = self.serviceInfo.serviceRemark;
    self.navigationItem.title = @"电话服务";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)buyProtectionButtonClick:(UIButton *)sender {
    if (![[AFNetManager sharedManager] checkNetStateWithTip:@"网络不好，请稍后再试"]){
        return;
    }
    AddPhoneServiceInfoVC *phoneServiceInfoVc = [[AddPhoneServiceInfoVC alloc] init];
    phoneServiceInfoVc.serviceInfo = self.serviceInfo;
    [self.navigationController pushViewController:phoneServiceInfoVc animated:YES];
}
@end