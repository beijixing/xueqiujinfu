//
//  LostCardVC.m
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "LostCardVC.h"
#include "AddLostCardProtectionInfoVC.h"
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD.h"

@interface LostCardVC ()

@end

@implementation LostCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionTextView.text = self.serviceInfo.serviceRemark;
    self.navigationItem.title = @"失卡保障";
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
    
    AddLostCardProtectionInfoVC *addProtectionInfoVc = [[AddLostCardProtectionInfoVC alloc] init];
    addProtectionInfoVc.serviceInfo = self.serviceInfo;
    [self.navigationController pushViewController:addProtectionInfoVc animated:YES];
}
@end
