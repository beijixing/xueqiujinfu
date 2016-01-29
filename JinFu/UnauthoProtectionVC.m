//
//  UnauthoProtectionVC.m
//  JinFu
//
//  Created by ybon on 15/12/18.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "UnauthoProtectionVC.h"
#import "AddProtectionInfoVC.h"
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD.h"

@interface UnauthoProtectionVC ()

@end

@implementation UnauthoProtectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.descTextView.text = self.serviceInfo.serviceRemark;
    self.navigationItem.title = @"盗刷保障";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)buyServiceBtnClick:(UIButton *)sender {
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"网络不好，请稍后再试";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        return;
    }
    DLog(@"购买保障");
    AddProtectionInfoVC *addInfoVc = [[AddProtectionInfoVC alloc] init];
    addInfoVc.serviceInfo = self.serviceInfo;
    [self.navigationController pushViewController:addInfoVc animated:YES];
    
    
}
@end
