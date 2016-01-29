//
//  POSVC.m
//  JinFu
//
//  Created by ybon on 15/12/25.
//  Copyright © 2015年 ybon. All rights reserved.
//

#import "POSVC.h"
#import "AddPosInfoVC.h"
#import "AFNetworkReachabilityManager.h"
#import "MBProgressHUD.h"

@interface POSVC ()

@end

@implementation POSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descTextView.text = self.posInfo.serviceRemark;
    self.navigationItem.title = @"POS机";
    [self configNavigationLeftButton];
}

- (void)configNavigationLeftButton {
    typeof(self) __weak WEAKSELF = self;
    [self setLeftNavigationBarButtonItemWithImage:@"icon-left" andAction:^{
        [WEAKSELF.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buyProtectionButtonClick:(UIButton *)sender {
    if ([AFNetworkReachabilityManager sharedManager].isReachable == 0) {
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"网络不好，请稍后再试";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        return;
    }
    AddPosInfoVC *addposInfoVc = [[AddPosInfoVC alloc] init];
    addposInfoVc.posInfo = self.posInfo;
    [self.navigationController pushViewController:addposInfoVc animated:YES];
}
@end
