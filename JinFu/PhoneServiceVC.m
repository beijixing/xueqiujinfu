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
#import <AFNetworkReachabilityManager.h>
@interface PhoneServiceVC ()

@end

@implementation PhoneServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"网络不好，请稍后再试";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        return;
    }
    AddPhoneServiceInfoVC *phoneServiceInfoVc = [[AddPhoneServiceInfoVC alloc] init];
    phoneServiceInfoVc.serviceInfo = self.serviceInfo;
    [self.navigationController pushViewController:phoneServiceInfoVc animated:YES];
}
@end
